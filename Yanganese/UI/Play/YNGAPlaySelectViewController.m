//
//  YNGAPlaySelectViewController.m
//  Yanganese
//
//  Created by Michael Yang on 1/13/13.
//  Copyright (c) 2013 Michael Yang. All rights reserved.
//

#import "YNGAPlaySelectViewController.h"

#import "YNGAGameViewController.h"
#import "YNGAAppDelegate.h"
#import "Quiz.h"

@implementation YNGAPlaySelectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.emptyMessage = @"There are no quizzes available. Try downloading a quiz to start playing.";

    // Load quizzes
    YNGAAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Quiz" inManagedObjectContext:context];
    [request setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:request error:&error];
    self.data = [[NSMutableArray alloc] initWithArray:fetchedObjects];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{    
    if([segue.identifier isEqualToString:@"startGame"])
    {
        NSIndexPath *indexPath;
        Quiz *quiz;
        if(sender == self.searchDisplayController.searchResultsTableView)
        {
            indexPath = [self.tableView indexPathForSelectedRow];
            quiz = [self.filteredData objectAtIndex:[indexPath row]];
        }
        else
        {
            indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            quiz = [self.data objectAtIndex:[indexPath row]];
        }
        
        YNGAGameViewController *gameController = segue.destinationViewController;
        gameController.quiz = quiz;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"startGame" sender:tableView];
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        Quiz *quiz = [self.data objectAtIndex:[indexPath row]];
        
        // Remove from array
        [self.data removeObjectAtIndex:[indexPath row]];
        
        // Remove from data store
        YNGAAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        [context deleteObject:quiz];
        [context save:nil];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

@end
