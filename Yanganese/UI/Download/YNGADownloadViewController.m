//
//  YNGADownloadViewController.m
//  Yanganese
//
//  Created by Michael Yang on 1/13/13.
//  Copyright (c) 2013 Michael Yang. All rights reserved.
//

#import "YNGADownloadViewController.h"

#import "YNGAAppDelegate.h"
#import "YNGATableNotificationView.h"
#import "YNGAPopupView.h"
#import "Quiz.h"
#import "Question.h"

@interface YNGADownloadViewController ()

- (void)loadRequest:(NSURLRequest *)request;
- (void)updateQuizzes:(NSData *)data;
- (void)togglePopup;

@end

@implementation YNGADownloadViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Add popup view
    popupView = [[YNGAPopupView alloc] initWithFrame:CGRectMake(20, 200, 280, 40)];
    popupView.messageLabel.text = @"Quiz Downloaded";
    popupView.alpha = 0.0;
    [self.tableView addSubview:popupView];
    
    self.emptyMessage = @"No quizzes available for download.";
    
    retainedData = [[NSMutableData alloc] init];
    
    NSURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:kQuizURL]];
    [self loadRequest:request];
}

#pragma mark -

- (void)loadRequest:(NSURLRequest *)request
{
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(connection)
        self.notificationView.hidden = YES;
    else
    {
        self.notificationView.imageView.image = [UIImage imageNamed:@"error.png"];
        self.notificationView.textView.text = @"There was a problem connecting to the server. Please try again later.";
        self.notificationView.hidden = NO;
    }
}

- (void)updateQuizzes:(NSData *)data
{
    YNGAAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Quiz" inManagedObjectContext:context];
        
    NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    self.quizzes = [[NSMutableArray alloc] initWithCapacity:json.count];
    for(NSDictionary *dict in json)
    {
        Quiz *quiz = [[Quiz alloc] initWithEntity:entity insertIntoManagedObjectContext:nil andProperties:dict];
        [self.quizzes addObject:quiz];
    }
    
    if(self.quizzes.count > 0)
        self.notificationView.hidden = YES;
    
    [self.tableView reloadData];
}

- (void)togglePopup
{
    [UIView animateWithDuration:kTransitionTime animations:^{
        popupView.alpha = popupView.alpha == 0.0 ? 1.0 : 0.0;
    }];
}

#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YNGAAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Question" inManagedObjectContext:context];
    
    Quiz *quiz = [self.quizzes objectAtIndex:[indexPath row]];
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_async(group, queue, ^{
        NSString *fullPath = [kQuizURL stringByAppendingPathComponent:[quiz.quizID stringValue]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:fullPath]];
        
        NSHTTPURLResponse *response;
        NSError *error;
        
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        if(data != nil)
        {
            NSError *jsonReadError;
            NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonReadError];
            
            [context insertObject:quiz];
            
            for(NSDictionary *dict in json) {
                Question *question = [[Question alloc] initWithEntity:entity insertIntoManagedObjectContext:context andProperties:dict];
                [quiz addQuestionsObject:question];
            }
        }
    });
    dispatch_group_notify(group, queue, ^{
        NSError *contextError;
        
        [context save:&contextError];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self togglePopup];
            
            [self performSelector:@selector(togglePopup) withObject:nil afterDelay:2 * kTransitionTime];
        });
    });
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark - Connection delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [retainedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [retainedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self updateQuizzes:retainedData];
}

@end
