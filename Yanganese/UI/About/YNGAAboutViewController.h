//
//  YNGAAboutViewController.h
//  Yanganese
//
//  Created by Michael Yang on 1/18/13.
//  Copyright (c) 2013 Michael Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YNGAAlertView.h"

@interface YNGAAboutViewController : UIViewController <YNGAAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

- (IBAction)back;
- (IBAction)sendSupportMail;

@end
