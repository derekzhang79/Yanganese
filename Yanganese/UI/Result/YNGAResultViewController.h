//
//  YNGAResultViewController.h
//  Yanganese
//
//  Created by Michael Yang on 1/13/13.
//  Copyright (c) 2013 Michael Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Score.h"

@interface YNGAResultViewController : UIViewController
{
    NSArray *categoryList;
}

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UITableView *resultTable;
@property (nonatomic, retain) Score *score;

@end
