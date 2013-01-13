//
//  YNGARatingView.h
//  Yanganese
//
//  Created by Michael Yang on 1/12/13.
//  Copyright (c) 2013 Michael Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YNGARatingView : UIView
{
    UIImageView *foregroundView, *backgroundView;
}

@property (nonatomic) float rating;

@end
