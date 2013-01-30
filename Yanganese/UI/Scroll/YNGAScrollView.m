//
//  YNGAScrollView.m
//  Yanganese
//
//  Created by Michael Yang on 1/14/13.
//  Copyright (c) 2013 Michael Yang. All rights reserved.
//

#import "YNGAScrollView.h"

#import <QuartzCore/QuartzCore.h>

#define kDefaultWidth 320
#define kDefaultHeight 313

@implementation YNGAScrollView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        self.autoresizesSubviews = YES;
        CGSize size = self.frame.size;
        UITextView *prevView = [[UITextView alloc] initWithFrame:CGRectMake(kSideMargin, 0, size.width - 2 * kSideMargin, size.height)];
        UITextView *currView = [[UITextView alloc] initWithFrame:CGRectMake(size.width + kSideMargin, 0, size.width - 2 * kSideMargin, size.height)];
        UITextView *nextView = [[UITextView alloc] initWithFrame:CGRectMake(2 * size.width + kSideMargin, 0, size.width - 2 * kSideMargin, size.height)];
        self.prev = prevView;
        self.curr = currView;
        self.next = nextView;
        [self addSubview:_prev];
        [self addSubview:_curr];
        [self addSubview:_next];
        
        for(UIView *object in self.subviews)
        {
            if([object isKindOfClass:[UITextView class]])
            {
                UITextView *cast = (UITextView *)object;
                cast.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7f];
                cast.layer.cornerRadius = kCornerRadius;
                cast.editable = NO;
                cast.textColor = [UIColor whiteColor];
                cast.font = [UIFont fontWithName:@"Helvetica" size:16.0];
                cast.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            }
        }
        
        self.page = 0;
        self.contentSize = CGSizeMake(3 * size.width, size.height);
        [self scrollToMiddle];
    }

    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.contentSize = CGSizeMake(3 * self.frame.size.width, self.frame.size.height);
}

#pragma mark -

- (void)scrollToMiddle
{
    CGSize size = self.frame.size;
    [self scrollRectToVisible:CGRectMake(size.width, 0, size.width, size.height) animated:NO];
}

@end
