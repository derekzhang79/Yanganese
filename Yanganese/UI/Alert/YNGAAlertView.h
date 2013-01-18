//
//  YNGAAlertView.h
//  Yanganese
//
//  Created by Michael Yang on 1/17/13.
//  Copyright (c) 2013 Michael Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YNGAAlertViewDelegate;

typedef enum {
    kCancelButtonIndex = 1,
    kOKButtonIndex
} ButtonIndex;

@interface YNGAAlertView : UIView

@property (weak, nonatomic) id <YNGAAlertViewDelegate> delegate;

@property (weak, nonatomic) UILabel *messageLabel;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIButton *okButton;

- (void)show;

@end

@protocol YNGAAlertViewDelegate <NSObject>
@optional

- (void)alertView:(YNGAAlertView *)alertView didDismissWithButtonIndex:(ButtonIndex)buttonIndex;

@end