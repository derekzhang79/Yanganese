//
//  YNGASegue.m
//  Yanganese
//
//  Created by Michael Yang on 1/15/13.
//  Copyright (c) 2013 Michael Yang. All rights reserved.
//

#import "YNGASegue.h"

@interface YNGASegue ()

- (void)animationDone:(UIViewController *)viewController;

@end

@implementation YNGASegue

- (void)perform
{    
    UIViewController *dst = [self destinationViewController];
    [dst viewWillAppear:NO];
    [dst viewDidAppear:NO];

    [UIView animateWithDuration:kTransitionTime animations:_animations];
    
    [self performSelector:@selector(animationDone:) withObject:dst afterDelay:kTransitionTime];
}

- (void)animationDone:(UIViewController *)viewController
{
    UINavigationController *nav = [[self sourceViewController] navigationController];
    [nav pushViewController:viewController animated:NO];
}

@end
