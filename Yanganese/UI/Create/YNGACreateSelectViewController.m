//
//  YNGACreateSelectViewController.m
//  Yanganese
//
//  Created by Michael Yang on 1/23/13.
//  Copyright (c) 2013 Michael Yang. All rights reserved.
//

#import "YNGACreateSelectViewController.h"

#import <QuartzCore/QuartzCore.h>
#import "YNGAAppDelegate.h"
#import "YNGACreateQuestionViewController.h"
#import "YNGAPopupView.h"
#import "YNGAProgressView.h"
#import "YNGAAlertView.h"
#import "Quiz.h"
#import "Question.h"

@interface YNGACreateSelectViewController ()

- (void)uploadQuestions;
- (void)addQuestion:(id)sender;

@end

@implementation YNGACreateSelectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.notificationView = nil;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addQuestion:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    // Add header view
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 78)];
    headerView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3f];

    UIButton *finishButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 280, 38)];//[UIButton buttonWithType:UIButtonTypeCustom];
    finishButton.layer.cornerRadius = kCornerRadius;
    [finishButton setTitle:@"Upload and Finish" forState:UIControlStateNormal];
    finishButton.titleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    finishButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7f];
    [finishButton addTarget:self action:@selector(uploadQuiz) forControlEvents:UIControlEventTouchUpInside];
    
    [headerView addSubview:finishButton];
    self.tableView.tableHeaderView = headerView;
    
    // Add popup view
    popupView = [[YNGAPopupView alloc] initWithFrame:CGRectMake(20, 200, 280, 40)];
    popupView.messageLabel.text = @"Quiz Uploaded";
    popupView.alpha = 0.0;
    [self.tableView addSubview:popupView];
    
    // Add progress view
    progressView = [[YNGAProgressView alloc] initWithFrame:CGRectMake(20, 200, 280, 40)];
    [progressView setProgress:0];
    progressView.alpha = 0.0;
    [self.tableView addSubview:progressView];
    
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

- (IBAction)uploadQuiz
{
    // Save quiz locally
    YNGAAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    [context insertObject:_quiz];
    
    for(Question *question in self.data)
        [_quiz addQuestionsObject:question];
    
    [context save:nil];
    
    // Upload quiz
    NSDictionary *quizDict = @{@"quiz":[_quiz properties]};
    NSData *data = [NSJSONSerialization dataWithJSONObject:quizDict options:kNilOptions error:nil];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:kQuizURL]];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data];
    
    NSURLResponse *response;
    NSError *error;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if(responseData)
    {
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
        _quiz.quizID = [jsonResponse objectForKey:@"quiz_id"];
        [context save:nil];
        
        void(^uploadQuestions)(BOOL) = ^(BOOL completion) {
            [self uploadQuestions];
        };
        
        [UIView animateWithDuration:kTransitionTime animations:^{
            progressView.alpha = 1.0f;
        } completion:uploadQuestions];
    }
    else
    {
    }
}

- (void)uploadQuestions
{
    // Upload questions
    NSInteger questionCount = 0;
    for(Question *question in _quiz.questions)
    {
        NSDictionary *quizDict = @{@"question":[question properties]};
        NSData *data = [NSJSONSerialization dataWithJSONObject:quizDict options:kNilOptions error:nil];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:kQuestionURL]];
        [request setHTTPMethod:@"POST"];
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:data];
        
        NSURLResponse *response;
        NSError *error;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        if(responseData)
        {
            questionCount++;
            [progressView setProgress:(questionCount * 1.0f / _quiz.questions.count)];
        }
    }
    
    // Fade and reset progress
    void(^fadeProgress)(void) = ^ {
        progressView.alpha = 0.0f;
    };
    
    void(^clearProgress)(BOOL) = ^(BOOL completion) {
        YNGAAlertView *alertView = [[YNGAAlertView alloc] initWithFrame:CGRectMake(30, 120, 260, 200)];
        alertView.cancelButton.hidden = YES;
        alertView.messageLabel.text = @"Upload finished. You will now be taken back to the main menu.";
        alertView.delegate = self;
        
        [self.view addSubview:alertView];
        [alertView show];
    };
    
    [UIView animateWithDuration:kTransitionTime animations:fadeProgress completion:clearProgress];
}

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

#pragma mark - Alert view delegate

- (void)alertView:(YNGAAlertView *)alertView didDismissWithButtonIndex:(ButtonIndex)buttonIndex
{
    if(buttonIndex == kOKButtonIndex)
    {
        void(^fadeView)(void) = ^ {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            for(UIView *view in self.view.subviews)
                view.alpha = 0.0f;
        };
        
        void(^popToRoot)(BOOL) = ^(BOOL completion) {
            [self.navigationController popToRootViewControllerAnimated:NO];
        };
        
        [UIView animateWithDuration:kTransitionTime animations:fadeView completion:popToRoot];
    }
}

@end
