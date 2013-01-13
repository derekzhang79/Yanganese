//
//  YNGAQuizCell.h
//  Yanganese
//
//  Created by Michael Yang on 1/12/13.
//  Copyright (c) 2013 Michael Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YNGARatingView;

@interface YNGAQuizCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet YNGARatingView *ratingView;
@property float rating;

@end
