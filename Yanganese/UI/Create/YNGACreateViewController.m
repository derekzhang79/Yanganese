//
//  YNGACreateViewController.m
//  Yanganese
//
//  Created by Michael Yang on 1/25/13.
//  Copyright (c) 2013 Michael Yang. All rights reserved.
//

#import "YNGACreateViewController.h"

#import "YNGAAppDelegate.h"
#import "YNGACreateQuizViewController.h"
#import "YNGACreateQuestionSelectViewController.h"
#import "Quiz.h"

@interface YNGACreateViewController ()

- (void)addQuiz:(id)sender;

@end

@implementation YNGACreateViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addQuiz:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    self.emptyMessage = @"There are no unuploaded quizzes. Quizzes that you do not upload are saved here.";
    
    // Load quizzes
    YNGAAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Quiz" inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *notUploaded = [NSPredicate predicateWithFormat:@"quizID == nil"];
    [request setEntity:entity];
    [request setPredicate:notUploaded];
    
    NSError *fetchError;
    NSArray *fetchedObjects = [context executeFetchRequest:request error:&fetchError];
    self.data = [[NSMutableArray alloc] initWithArray:fetchedObjects];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];

    [super viewWillAppear:animated];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"addQuiz"])
    {
        YNGAAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Quiz" inManagedObjectContext:context];
        
        Quiz *quiz = [[Quiz alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
        
        YNGACreateQuizViewController *createController = segue.destinationViewController;
        createController.quiz = quiz;
        
        [self.data addObject:quiz];
    }
    else if([segue.identifier isEqualToString:@"editQuiz"])
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
        
        YNGACreateQuestionSelectViewController *createSelectController = segue.destinationViewController;
        createSelectController.quiz = quiz;
    }
}

#pragma mark -

- (void)addQuiz:(id)sender
{
    [self performSegueWithIdentifier:@"addQuiz" sender:sender];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"editQuiz" sender:tableView];
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

@end
