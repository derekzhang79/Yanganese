//
//  YNGACreateViewController.m
//  Yanganese
//
//  Created by Michael Yang on 1/21/13.
//  Copyright (c) 2013 Michael Yang. All rights reserved.
//

#import "YNGACreateViewController.h"

#import <QuartzCore/QuartzCore.h>
#import "YNGAAppDelegate.h"
#import "Quiz.h"

@interface YNGACreateViewController ()

- (void)animateBack;
- (Quiz *)createQuiz;

@end

@implementation YNGACreateViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _titleField.layer.cornerRadius = kCornerRadius;
    _authorField.layer.cornerRadius = kCornerRadius;
    _categoryButton.layer.cornerRadius = kCornerRadius;
    
    categories = @[@"Astronomy", @"Biology", @"Chemistry", @"Earth Science", @"General Science", @"Mathematics", @"Physics"];
    
    actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:nil
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    
    [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    
    lastRow = 5;
    
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
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [super viewWillAppear:animated];
}

#pragma mark -

- (IBAction)showPicker
{
    [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
    [actionSheet setBounds:CGRectMake(0, 0, 320, 485)];
}

- (IBAction)dismissKeyboard
{
    [_titleField resignFirstResponder];
    [_authorField resignFirstResponder];
}

- (IBAction)dismissActionSheet
{
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)animateBack
{
    [self dismissKeyboard];
	[self.navigationController setNavigationBarHidden:YES animated:YES];
    
    void(^fade)(void) = ^(void) {
        self.view.alpha = 0.0;
    };
    
    void(^popController)(BOOL) = ^(BOOL completed) {
        [self.navigationController popViewControllerAnimated:NO];
    };
    
    [UIView animateWithDuration:kTransitionTime animations:fade completion:popController];
}

- (Quiz *)createQuiz
{
    YNGAAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Quiz" inManagedObjectContext:context];
    
    Quiz *quiz = [[Quiz alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    quiz.title = _titleField.text;
    quiz.author = _authorField.text;
    quiz.categoryID = [NSNumber numberWithInteger:(lastRow + 1)];
    
    return quiz;
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