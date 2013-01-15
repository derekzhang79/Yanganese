//
//  YNGADownloadViewController.m
//  Yanganese
//
//  Created by Michael Yang on 1/13/13.
//  Copyright (c) 2013 Michael Yang. All rights reserved.
//

#import "YNGADownloadViewController.h"

#import "YNGAAppDelegate.h"
#import "Quiz.h"
#import "Question.h"

@interface YNGADownloadViewController ()

- (void)loadData;

@end

@implementation YNGADownloadViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self loadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -

- (void)loadData
{
    YNGAAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Quiz" inManagedObjectContext:context];

    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_async(group, queue, ^{
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:kQuizURL]];
        
        NSHTTPURLResponse *response;
        NSError *error;
        
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        if(data != nil)
        {
            NSError *jsonReadError;
            NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonReadError];
            
            self.quizzes = [[NSMutableArray alloc] initWithCapacity:json.count];
            for(NSDictionary *dict in json)
            {
                Quiz *quiz = [[Quiz alloc] initWithEntity:entity insertIntoManagedObjectContext:nil andProperties:dict];
                [self.quizzes addObject:quiz];
            }
        }
    });
    dispatch_group_notify(group, queue, ^{
        [self.tableView reloadData];
    });
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
    });
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

@end
