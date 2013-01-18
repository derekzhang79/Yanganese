//
//  YNGAGameViewController.h
//  Yanganese
//
//  Created by Michael Yang on 1/13/13.
//  Copyright (c) 2013 Michael Yang. All rights reserved.
//

#import "YNGAQuestionViewController.h"

#import "YNGAAlertView.h"

#define kCategoryCount 7

@class Question;

@interface YNGAGameViewController : YNGAQuestionViewController <YNGAAlertViewDelegate>
{
    NSArray *categories;
	int correctCount[kCategoryCount];
	int questionTotal[kCategoryCount];
	
    NSUInteger questionNumber;
	NSUInteger score;
	NSUInteger timeMin;
	NSUInteger timeSec;
    NSInteger lastButtonTag;
	
	CGAffineTransform translations[4];
    
    Question *question;
}

@property (weak, nonatomic) IBOutlet UITextView *questionView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (nonatomic, retain) IBOutletCollection(UIButton) NSArray *buttons;
@property (nonatomic, retain) NSTimer *timer;

- (IBAction)answer:(id)sender;

@end
