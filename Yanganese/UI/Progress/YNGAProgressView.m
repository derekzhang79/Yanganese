//
//  YNGAProgressView.m
//  Yanganese
//
//  Created by Michael Yang on 1/15/13.
//  Copyright (c) 2013 Michael Yang. All rights reserved.
//

#import "YNGAProgressView.h"

#import <QuartzCore/QuartzCore.h>

#define kProgressViewHeight 9

@implementation YNGAProgressView

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.layer.cornerRadius = kCornerRadius;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9];
        
        CGRect progressFrame = CGRectMake(frame.origin.x + kSideMargin, (frame.size.height - kProgressViewHeight) / 2, (frame.size.width - 2 * kSideMargin) * 0.6, kProgressViewHeight);
        CGRect labelFrame = CGRectMake(progressFrame.origin.x + progressFrame.size.width * 1.1, 0, (frame.size.width - 2 * kSideMargin) * 0.2, frame.size.height);
        
        progressView = [[UIProgressView alloc] initWithFrame:progressFrame];
        percentageLabel = [[UILabel alloc] initWithFrame:labelFrame];
        
        percentageLabel.backgroundColor = [UIColor clearColor];
        percentageLabel.textColor = [UIColor whiteColor];
        percentageLabel.textAlignment = NSTextAlignmentLeft;
        
        [self addSubview:progressView];
        [self addSubview:percentageLabel];
    }
    
    return self;
}

#pragma mark -

- (void)setProgress:(float)progress
{
    [progressView setProgress:progress animated:YES];
    percentageLabel.text = [NSString stringWithFormat:@"%d%%", (int)(progress * 100)];
}

@end
