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
            
            YNGAAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            NSManagedObjectContext *context = appDelegate.managedObjectContext;
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"Quiz" inManagedObjectContext:context];
            
            self.quizzes = [[NSMutableArray alloc] initWithCapacity:json.count];
            for(NSDictionary *dict in json)
            {
                Quiz *quiz = [[Quiz alloc] initWithEntity:entity insertIntoManagedObjectContext:context andProperties:dict];
                [self.quizzes addObject:quiz];
            }
        }
    });
    dispatch_group_notify(group, queue, ^{
        [self.tableView reloadData];
    });
}

#pragma mark - Table view delegate

@end
