//
//  YNGARatingView.m
//  Yanganese
//
//  Created by Michael Yang on 1/12/13.
//  Copyright (c) 2013 Michael Yang. All rights reserved.
//

#import "YNGARatingView.h"

#define kMaxRating 5

@interface YNGARatingView ()

- (void)commonInit;

@end

@implementation YNGARatingView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
		[self commonInit];
	
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    if (self = [super initWithCoder:coder])
        [self commonInit];
    
    return self;
}

#pragma mark -

- (void)commonInit
{
    backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"starsBackground.png"]];
    backgroundView.contentMode = UIViewContentModeLeft;
    [self addSubview:backgroundView];
    
    foregroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"starsForeground.png"]];
    foregroundView.contentMode = UIViewContentModeLeft;
    foregroundView.clipsToBounds = YES;
    [self addSubview:foregroundView];
}

- (void)setRating:(float)newRating
{
    _rating = newRating;
	int backWidth = backgroundView.frame.size.width;
	int frontWidth = foregroundView.bounds.size.height;
    foregroundView.frame = CGRectMake(0.0, 0.0, backWidth * (_rating / kMaxRating), frontWidth);
}

@end
