//
//  YNGAProgressView.h
//  Yanganese
//
//  Created by Michael Yang on 1/15/13.
//  Copyright (c) 2013 Michael Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YNGAProgressView : UIView
{
    UILabel *percentageLabel;
    UIProgressView *progressView;
}

- (void)setProgress:(float)progress;

@end
