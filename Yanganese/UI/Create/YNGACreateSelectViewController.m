//
//  YNGACreateSelectViewController.m
//  Yanganese
//
//  Created by Michael Yang on 1/23/13.
//  Copyright (c) 2013 Michael Yang. All rights reserved.
//

#import "YNGACreateSelectViewController.h"

#import "YNGAAppDelegate.h"
#import "YNGACreateQuestionViewController.h"
#import "Question.h"

@implementation YNGACreateSelectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.notificationView = nil;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addQuestion:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    self.data = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
    
    [super viewWillAppear:animated];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"addQuestion"])
    {
        YNGAAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Question" inManagedObjectContext:context];
        
        Question *question = [[Question alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
        
        YNGACreateQuestionViewController *questionController = (YNGACreateQuestionViewController *)segue.destinationViewController;
        questionController.question = question;
        
        [self.data addObject:question];
    }
    else if([segue.identifier isEqualToString:@"editQuestion"])
    {
        NSIndexPath *indexPath;
        Question *question;
        if(sender == self.searchDisplayController.searchResultsTableView)
        {
            indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            question = [self.filteredData objectAtIndex:[indexPath row]];
        }
        else
        {
            indexPath = [self.tableView indexPathForSelectedRow];
            question = [self.data objectAtIndex:[indexPath row]];
        }
        
        YNGACreateQuestionViewController *questionController = (YNGACreateQuestionViewController *)segue.destinationViewController;
        questionController.question = question;
    }
}

#pragma mark -

- (void)addQuestion:(id)sender
{
    [self performSegueWithIdentifier:@"addQuestion" sender:sender];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"editQuestion" sender:tableView];
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        Question *question = [self.data objectAtIndex:[indexPath row]];
        
        // Remove from array
        [self.data removeObjectAtIndex:[indexPath row]];
        
        // Remove from data store
        YNGAAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        [context deleteObject:question];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

@end
