//
//  YNGASelectViewController.h
//  Yanganese
//
//  Created by Michael Yang on 1/13/13.
//  Copyright (c) 2013 Michael Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YNGAQuizCell;

@interface YNGASelectViewController : UITableViewController
{
    NSArray *categoryImages;
}

@property (weak, nonatomic) IBOutlet YNGAQuizCell *protoCell;

@property (nonatomic, retain) NSArray *quizzes;

@end
