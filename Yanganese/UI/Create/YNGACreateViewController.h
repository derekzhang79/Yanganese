//
//  YNGACreateViewController.h
//  Yanganese
//
//  Created by Michael Yang on 1/21/13.
//  Copyright (c) 2013 Michael Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YNGACreateViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>
{
    NSArray *categories;
    NSInteger lastRow;
    
    UIActionSheet *actionSheet;
}

@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextField *authorField;
@property (weak, nonatomic) IBOutlet UIButton *categoryButton;
@property (weak, nonatomic) IBOutlet UIPickerView *categoryPicker;

- (IBAction)showPicker;
- (IBAction)dismissKeyboard;
- (IBAction)dismissActionSheet;

@end
