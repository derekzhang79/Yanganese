//
//  YNGAReviewQuestionViewController.h
//  Yanganese
//
//  Created by Michael Yang on 1/14/13.
//  Copyright (c) 2013 Michael Yang. All rights reserved.
//

#import "YNGAQuestionViewController.h"

@class YNGAScrollView;

@interface YNGAReviewQuestionViewController : YNGAQuestionViewController <UIScrollViewDelegate>
{
    NSArray *categories;
}
@property (weak, nonatomic) IBOutlet YNGAScrollView *questionScroll;
@property (weak, nonatomic) IBOutlet UIButton *toggleButton;

- (IBAction)show;

@end
