//
//  YNGAPopupView.m
//  Yanganese
//
//  Created by Michael Yang on 1/15/13.
//  Copyright (c) 2013 Michael Yang. All rights reserved.
//

#import "YNGAPopupView.h"

#import <QuartzCore/QuartzCore.h>

@implementation YNGAPopupView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.layer.cornerRadius = kCornerRadius;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9];
        
        self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _messageLabel.backgroundColor = [UIColor clearColor];
        _messageLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        _messageLabel.textColor = [UIColor whiteColor];
        _messageLabel.textAlignment = NSTextAlignmentCenter;

        [self addSubview:_messageLabel];
    }

    return self;
}

@end
