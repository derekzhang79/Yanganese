//
//  YNGAQuestionCell.h
//  Yanganese
//
//  Created by Michael Yang on 1/21/13.
//  Copyright (c) 2013 Michael Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YNGAQuestionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *questionTextLabel;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSMutableArray *optionLabels;

@end
