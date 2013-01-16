//
//  YNGAMenuViewController.m
//  Yanganese
//
//  Created by Michael Yang on 1/13/13.
//  Copyright (c) 2013 Michael Yang. All rights reserved.
//

#import "YNGAMenuViewController.h"

#import "YNGASegue.h"

#define kSideMargin 20

@interface YNGAMenuViewController ()

- (void)translateOut;

@end

@implementation YNGAMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Initialize translation constants
    [_iconImage sizeToFit];
	double shift = _iconImage.frame.size.height + kSideMargin;
	
	translateUp = CGAffineTransformMakeTranslation(0.0, -_iconImage.frame.size.height);
	translateLeft = CGAffineTransformMakeTranslation(-shift, 0.0);
	translateRight = CGAffineTransformMakeTranslation(shift, 0.0);
	translateDown = CGAffineTransformMakeTranslation(0.0, shift/2);
    
    // Set initial positions
	[self translateOut];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    // Fade and translate in
	[self.navigationController setNavigationBarHidden:YES animated:YES];
	[UIView animateWithDuration:kTransitionTime animations:^ {
        for(UIView *object in self.view.subviews) {
            if([object isKindOfClass:[UIButton class]] || [object isKindOfClass:[UIImageView class]]) {
                object.transform = CGAffineTransformIdentity;
                object.alpha = 1.0;
            }
        }
	}];
    
    [super viewWillAppear:animated];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue isKindOfClass:[YNGASegue class]])
    {
        YNGASegue *customSegue = (YNGASegue *)segue;
        customSegue.animations = ^
        {
            [self translateOut];
        };
    }
}

#pragma mark -

- (void)translateOut {
	// Map translations
    for(UIButton *button in _buttons)
    {
        if(button.tag % 2 == 1)
            button.transform = translateLeft;
        else
            button.transform = translateRight;
    }
    _iconImage.transform = translateUp;
	
    // Fade
	for(UIView *object in self.view.subviews) {
		if([object isKindOfClass:[UIButton class]] || [object isKindOfClass:[UIImageView class]]) {
			object.alpha = 0.0;
		}
	}
}

@end
