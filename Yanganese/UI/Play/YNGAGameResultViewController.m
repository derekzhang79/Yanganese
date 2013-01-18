//
//  YNGAGameResultViewController.m
//  Yanganese
//
//  Created by Michael Yang on 1/14/13.
//  Copyright (c) 2013 Michael Yang. All rights reserved.
//

#import "YNGAGameResultViewController.h"

#import "Score.h"

@interface YNGAGameResultViewController ()

- (void)animateBack;

@end

@implementation YNGAGameResultViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.hidesBackButton = YES;
    
	UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(animateBack)];
	self.navigationItem.rightBarButtonItem = done;
}

#pragma mark -

- (void)animateBack
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    void(^fade)(void) = ^ {
        for(UIView *view in self.view.subviews)
            view.alpha = 0.0;
    };
    
    void(^home)(BOOL) = ^(BOOL completion) {
        [self.navigationController popToRootViewControllerAnimated:NO];
    };
    
    [UIView animateWithDuration:kTransitionTime animations:fade completion:home];
}

@end
