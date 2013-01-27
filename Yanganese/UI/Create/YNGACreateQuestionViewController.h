//
//  YNGACreateQuestionViewController.h
//  Yanganese
//
//  Created by Michael Yang on 1/21/13.
//  Copyright (c) 2013 Michael Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Question;

@interface YNGACreateQuestionViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
{
    UIActionSheet *actionSheet;
    UIButton *lastButton;

    NSArray *categories;
    
    NSInteger lastRow;
    BOOL fieldTrigger;
}

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSMutableArray *choiceFields;
@property (weak, nonatomic) IBOutlet UIButton *categoryButton;
@property (nonatomic, retain) Question *question;

- (IBAction)showPicker;
- (IBAction)dismissKeyboard;
- (IBAction)dismissActionSheet;
- (IBAction)answerChanged:(id)sender;
- (IBAction)saveQuestion;

@end
