//
//  YNGAScoreViewController.m
//  Yanganese
//
//  Created by Michael Yang on 1/14/13.
//  Copyright (c) 2013 Michael Yang. All rights reserved.
//

#import "YNGAScoreViewController.h"

#import "YNGAAppDelegate.h"
#import "Score.h"

@implementation YNGAScoreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.title = @"Overall";
    
    // Load global score
    YNGAAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Score" inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *noQuiz = [NSPredicate predicateWithFormat:@"quiz == nil"];
    [request setEntity:entity];
    [request setPredicate:noQuiz];
    [request setFetchLimit:1];
    
    NSError *fetchError;
    NSArray *fetchedObjects = [context executeFetchRequest:request error:&fetchError];
    
    Score *globalScore = [fetchedObjects lastObject];
    if(globalScore == nil)
    {
        globalScore = [[Score alloc] initWithEntity:entity insertIntoManagedObjectContext:context];

        NSError *contextError;
        [context save:&contextError];
    }

    self.score = globalScore;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [super viewWillAppear:animated];
}

@end
