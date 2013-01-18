//
//  YNGASegue.m
//  Yanganese
//
//  Created by Michael Yang on 1/15/13.
//  Copyright (c) 2013 Michael Yang. All rights reserved.
//

#import "YNGASegue.h"

@implementation YNGASegue

- (void)perform
{    
    UIViewController *dst = [self destinationViewController];
    [dst viewWillAppear:YES];
    [dst viewDidAppear:YES];

    void(^pushController)(BOOL) = ^(BOOL completion) {
        UINavigationController *navigationController = [self.sourceViewController navigationController];
        [navigationController pushViewController:dst animated:NO];
    };
    
    [UIView animateWithDuration:kTransitionTime animations:_animations completion:pushController];
}

@end
