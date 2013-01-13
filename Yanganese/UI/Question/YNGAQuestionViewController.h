//
//  YNGAQuestionViewController.h
//  Yanganese
//
//  Created by Michael Yang on 1/13/13.
//  Copyright (c) 2013 Michael Yang. All rights reserved.
//

#import "YNGASelectViewController.h"

@class Quiz;

@interface YNGAQuestionViewController : UIViewController
{
    CGAffineTransform translateOriginal, translateDown;

    BOOL answerHidden;
}

@property (weak, nonatomic) IBOutlet UIView *dashView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerLabel;
@property (nonatomic, retain) Quiz *quiz;

@end
