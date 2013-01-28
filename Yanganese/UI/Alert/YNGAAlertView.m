//
//  YNGAAlertView.m
//  Yanganese
//
//  Created by Michael Yang on 1/17/13.
//  Copyright (c) 2013 Michael Yang. All rights reserved.
//

#import "YNGAAlertView.h"

#import <QuartzCore/QuartzCore.h>

#define kButtonHeightProportion 0.2f
#define kButtonMarginProportion 0.05f

@interface YNGAAlertView ()

- (void)dismiss:(id)sender;

@end

@implementation YNGAAlertView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = kCornerRadius;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9];
        self.alpha = 0.0;
        
        CGFloat marginWidth = kButtonMarginProportion * frame.size.width;
        
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, (1 - 2 * kButtonMarginProportion - kButtonHeightProportion) * frame.size.height)];
        self.messageLabel = messageLabel;
        _messageLabel.backgroundColor = [UIColor clearColor];
        _messageLabel.numberOfLines = 3;
        _messageLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        _messageLabel.textColor = [UIColor whiteColor];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        
        UIButton *cancelButton = [[UIButton alloc] init];
        self.cancelButton = cancelButton;
        _cancelButton.frame = CGRectMake(marginWidth, (1 - kButtonMarginProportion - kButtonHeightProportion) * frame.size.height, (0.5f - 2 * kButtonMarginProportion) * frame.size.width, kButtonHeightProportion * frame.size.height);
        _cancelButton.tag = kCancelButtonIndex;
        _cancelButton.backgroundColor = [UIColor colorWithRed:(204.0f/255.0f) green:0 blue:0 alpha:0.9f];
        [_cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        
        UIButton *okButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.okButton = okButton;
        _okButton.frame = CGRectMake(frame.size.width / 2.0f + marginWidth, (1 - kButtonMarginProportion - kButtonHeightProportion) * frame.size.height, (0.5f - 2 * kButtonMarginProportion) * frame.size.width, kButtonHeightProportion * frame.size.height);
        _okButton.tag = kOKButtonIndex;
        _okButton.backgroundColor = [UIColor colorWithRed:(67.0)/255 green:(149.0)/255 blue:(192.0)/255 alpha:1.0];
        [_okButton setTitle:@"OK" forState:UIControlStateNormal];
        
        for(UIButton *button in [NSArray arrayWithObjects:_cancelButton, _okButton, nil])
        {
            button.layer.cornerRadius = kCornerRadius;
            button.titleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
            button.titleLabel.textColor = [UIColor whiteColor];
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            [button addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
        }
    
        [self addSubview:_messageLabel];
        [self addSubview:_cancelButton];
        [self addSubview:_okButton];
    }
    return self;
}

#pragma mark -

- (void)show
{
    [UIView animateWithDuration:kTransitionTime animations:^{
        self.alpha = 1.0f;
    }];
}

- (void)dismiss:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    void(^delegate)(BOOL) = ^(BOOL completion) {
        [self removeFromSuperview];
        [_delegate alertView:self didDismissWithButtonIndex:button.tag];
    };
    
    [UIView animateWithDuration:kTransitionTime animations:^{
        self.alpha = 0.0f;
    } completion:delegate];
}

@end
