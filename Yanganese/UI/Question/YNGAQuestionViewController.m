//
//  YNGAQuestionViewController.m
//  Yanganese
//
//  Created by Michael Yang on 1/13/13.
//  Copyright (c) 2013 Michael Yang. All rights reserved.
//

#import "YNGAQuestionViewController.h"

#import <QuartzCore/QuartzCore.h>

@implementation YNGAQuestionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set style
	_dashView.layer.cornerRadius = kCornerRadius;
	_answerLabel.layer.cornerRadius = kCornerRadius;
	_answerLabel.alpha = 0.0;
    
	// Initialize transformation constants
	translateOriginal = CGAffineTransformMakeTranslation(0.0, 0.0);
	translateDown = CGAffineTransformMakeTranslation(0.0, 63.0);
}

- (void)viewWillAppear:(BOOL)animated {
	[self.navigationController setNavigationBarHidden:NO animated:YES];

	[super viewWillAppear:animated];
}

@end
