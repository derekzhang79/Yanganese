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
    
    // Disable editing
    self.navigationItem.rightBarButtonItem = nil;
    
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
    self.data = [[NSMutableArray alloc] initWithArray:fetchedObjects];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"showReviewQuestions"])
    {
        NSIndexPath *indexPath;
        Quiz *quiz;
        if(sender == self.searchDisplayController.searchResultsTableView)
        {
            indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            quiz = [self.filteredData objectAtIndex:[indexPath row]];
        }
        else
        {
            indexPath = [self.tableView indexPathForSelectedRow];
            quiz = [self.data objectAtIndex:[indexPath row]];
        }
        
        YNGAReviewQuestionViewController *questionController = segue.destinationViewController;
        questionController.quiz = quiz;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"showReviewQuestions" sender:tableView];
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

@end
