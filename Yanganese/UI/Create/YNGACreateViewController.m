//
//  YNGACreateViewController.m
//  Yanganese
//
//  Created by Michael Yang on 1/25/13.
//  Copyright (c) 2013 Michael Yang. All rights reserved.
//

#import "YNGACreateViewController.h"

@interface YNGACreateViewController ()

- (void)addQuiz:(id)sender;

@end

@implementation YNGACreateViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addQuiz:)];
    self.navigationItem.rightBarButtonItem = addButton;
}

- (void)addQuiz:(id)sender
{
    [self performSegueWithIdentifier:@"addQuiz" sender:sender];
}

@end
