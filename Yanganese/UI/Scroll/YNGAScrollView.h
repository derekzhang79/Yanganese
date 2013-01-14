//
//  YNGAScrollView.h
//  Yanganese
//
//  Created by Michael Yang on 1/14/13.
//  Copyright (c) 2013 Michael Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YNGAScrollView : UIScrollView

@property (nonatomic) NSUInteger page;
@property (weak, nonatomic) UITextView *prev;
@property (weak, nonatomic) UITextView *curr;
@property (weak, nonatomic) UITextView *next;

- (void)scrollToMiddle;

@end
