//
//  YNGAReviewSelectViewController.m
//  Yanganese
//
//  Created by Michael Yang on 1/14/13.
//  Copyright (c) 2013 Michael Yang. All rights reserved.
//

#import "YNGAReviewSelectViewController.h"

#import "YNGAAppDelegate.h"
#import "YNGAReviewQuestionViewController.h"
#import "Quiz.h"

@implementation YNGAReviewSelectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.emptyMessage = @"You have no finished quizzes to review. Try finishing a quiz to begin reviewing.";
    
    // Load quizzes
    YNGAAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Quiz" inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *hasScore = [NSPredicate predicateWithFormat:@"score != nil"];
    [request setEntity:entity];
    [request setPredicate:hasScore];
    
    NSError *fetchError;
    NSArray *fetchedObjects = [context executeFetchRequest:request error:&fetchError];
    self.quizzes = [[NSMutableArray alloc] initWithArray:fetchedObjects];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"showReviewQuestions"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Quiz *quiz = [self.quizzes objectAtIndex:[indexPath row]];
        
        YNGAReviewQuestionViewController *questionController = segue.destinationViewController;
        questionController.quiz = quiz;
    }
}

@end
