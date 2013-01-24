//
//  YNGACreateSelectViewController.h
//  Yanganese
//
//  Created by Michael Yang on 1/23/13.
//  Copyright (c) 2013 Michael Yang. All rights reserved.
//

#import "YNGAQuestionSelectViewController.h"

#import "YNGAAlertView.h"

@class YNGAPopupView, YNGAProgressView;
@class Quiz;

@interface YNGACreateSelectViewController : YNGAQuestionSelectViewController <YNGAAlertViewDelegate>
{
    YNGAPopupView *popupView;
    YNGAProgressView *progressView;

    NSMutableData *retainedData;
}

@property (nonatomic, retain) Quiz *quiz;

- (IBAction)uploadQuiz;

@end
