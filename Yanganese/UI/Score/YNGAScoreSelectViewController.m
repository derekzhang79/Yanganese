//
//  YNGAScoreSelectViewController.m
//  Yanganese
//
//  Created by Michael Yang on 1/14/13.
//  Copyright (c) 2013 Michael Yang. All rights reserved.
//

#import "YNGAScoreSelectViewController.h"

#import "YNGAAppDelegate.h"
#import "YNGAScoreViewController.h"

@implementation YNGAScoreSelectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"History";
    
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

@end
