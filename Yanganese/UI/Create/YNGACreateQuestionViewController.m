//
//  YNGACreateQuestionViewController.m
//  Yanganese
//
//  Created by Michael Yang on 1/21/13.
//  Copyright (c) 2013 Michael Yang. All rights reserved.
//

#import "YNGACreateQuestionViewController.h"

#import <QuartzCore/QuartzCore.h>
#import "YNGAAppDelegate.h"
#import "YNGAAlertView.h"
#import "Question.h"

@interface YNGACreateQuestionViewController ()

- (void)keyboardWillChange:(NSNotification *)notification;

@end

@implementation YNGACreateQuestionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    fieldTrigger = NO;
    
    categories = @[@"Astronomy", @"Biology", @"Chemistry", @"Earth Science", @"General Science", @"Mathematics", @"Physics"];
    
    // Initialize question information
    _textView.text = _question.text;
    
    for(UITextField *field in _choiceFields)
    {
        NSString *key = [NSString stringWithFormat:@"%c", ('w' + field.tag - 1)];
        field.text = [_question valueForKey:key];
    }
    
    lastRow = [_question.categoryID integerValue] - 1;
    if(lastRow < 0)
        lastRow = 4;

    [_categoryButton setTitle:[categories objectAtIndex:lastRow] forState:UIControlStateNormal];
    
    for(UITextField *field in _choiceFields)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        if(field.tag == [_question.answer characterAtIndex:0] - 'w' + 1)
        {
            lastButton = button;
            [lastButton setImage:[UIImage imageNamed:@"editCorrect.png"] forState:UIControlStateNormal];
        }
        else
            [button setImage:[UIImage imageNamed:@"editWrong.png"] forState:UIControlStateNormal];
        
        button.frame = CGRectMake(0, 0, 10, 38);
        button.backgroundColor = [UIColor clearColor];
        [button addTarget:self action:@selector(answerChanged:) forControlEvents:UIControlEventTouchUpInside];
        field.leftView = button;
        field.leftViewMode = UITextFieldViewModeAlways;
        field.layer.cornerRadius = kCornerRadius;
    }

    _textView.layer.cornerRadius = kCornerRadius;
    _categoryButton.layer.cornerRadius = kCornerRadius;
    
    actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                              delegate:nil
                                     cancelButtonTitle:nil
                                destructiveButtonTitle:nil
                                     otherButtonTitles:nil];
    
    [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    
    CGRect pickerFrame = CGRectMake(0, 40, 0, 0);
    
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
    pickerView.showsSelectionIndicator = YES;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    
    [actionSheet addSubview:pickerView];
    
    UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:@[@"Close"]];
    closeButton.momentary = YES;
    closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
    closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
    closeButton.tintColor = [UIColor blackColor];
    [closeButton addTarget:self action:@selector(dismissActionSheet) forControlEvents:UIControlEventValueChanged];
    [actionSheet addSubview:closeButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter  defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillHideNotification object:nil];
    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [super viewWillDisappear:animated];
}

#pragma mark -

- (IBAction)showPicker
{
    [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
    [actionSheet setBounds:CGRectMake(0, 0, 320, 485)];
}

- (IBAction)dismissKeyboard
{
    [_textView resignFirstResponder];
    for(UITextField *field in _choiceFields)
        [field resignFirstResponder];
}

- (IBAction)dismissActionSheet
{
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

- (IBAction)answerChanged:(id)sender
{    
    [lastButton setImage:[UIImage imageNamed:@"editWrong.png"] forState:UIControlStateNormal];
    
    UIButton *button = (UIButton *)sender;
    lastButton = button;
    [lastButton setImage:[UIImage imageNamed:@"editCorrect.png"] forState:UIControlStateNormal];
}

- (IBAction)saveQuestion
{
    // Update and check validity attributes
    _question.text = _textView.text;

    BOOL incompleteFields = NO;
    for(UITextField *field in _choiceFields)
    {
        NSString *key = [NSString stringWithFormat:@"%c", ('w' + field.tag - 1)];
        [_question setValue:field.text forKey:key];
        incompleteFields = incompleteFields || [field.text isEqualToString:@""] || field.text == nil;
    }
    
    if([_textView.text isEqualToString:@""] || _textView.text == nil || incompleteFields)
    {
        YNGAAlertView *alertView = [[YNGAAlertView alloc] initWithFrame:CGRectMake(30, 120, 260, 200)];
        alertView.cancelButton.hidden = YES;
        alertView.messageLabel.text = @"Please enter text and answer choices for the question.";
        
        [self.view addSubview:alertView];
        [alertView show];
        return;
    }
    
    _question.categoryID = [NSNumber numberWithInteger:(lastRow + 1)];
    
    UITextField *lastField = (UITextField *)lastButton.superview;
    _question.answer = [NSString stringWithFormat:@"%c", ('w' + lastField.tag - 1)];
    
    if(lastField.tag == 0)
    {
        YNGAAlertView *alertView = [[YNGAAlertView alloc] initWithFrame:CGRectMake(30, 120, 260, 200)];
        alertView.cancelButton.hidden = YES;
        alertView.messageLabel.text = @"Tap the color of the answer choice that is the answer.";
        
        [self.view addSubview:alertView];
        [alertView show];
        return;
    }
    
    // Save and return to question list
    YNGAAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    [context insertObject:_question];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)keyboardWillChange:(NSNotification *)notification
{
    if(!fieldTrigger)
        return;
    
    NSDictionary* info = [notification userInfo];
    CGFloat keyboardHeight = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
    
    [UIView animateWithDuration:kTransitionTime/2 animations:^{
        CGRect rect = self.view.frame;
        if (self.view.frame.origin.y >= 0)
        {
            rect.origin.y -= keyboardHeight;
            rect.size.height += keyboardHeight;
            _textView.alpha = 0.0f;
        }
        else
        {
            rect.origin.y += keyboardHeight;
            rect.size.height -= keyboardHeight;
            _textView.alpha = 1.0f;
        }
        self.view.frame = rect;
    }];
}

#pragma mark - Text field delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    fieldTrigger = YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    fieldTrigger = NO;
}

#pragma mark - Text view delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [UIView animateWithDuration:kTransitionTime/2 animations:^{
        for(UITextField *field in _choiceFields)
            field.alpha = 0.0f;
    }];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [UIView animateWithDuration:kTransitionTime/2 animations:^{
        for(UITextField *field in _choiceFields)
            field.alpha = 1.0f;
    }];
}

#pragma mark - Picker view data source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return categories.count;
}

#pragma mark - Picker view delegate

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSAttributedString *attrTitle = [[NSAttributedString alloc] initWithString:[categories objectAtIndex:row]];
    return attrTitle;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [_categoryButton setTitle:[categories objectAtIndex:row] forState:UIControlStateNormal];
    lastRow = row;
}

@end
