//
//  YNGAMenuViewController.h
//  Yanganese
//
//  Created by Michael Yang on 1/13/13.
//  Copyright (c) 2013 Michael Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YNGAMenuViewController : UIViewController
{
    CGAffineTransform translateLeft, translateRight, translateDown, translateUp;
}

@property (nonatomic) BOOL settingsHidden;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet UIButton *aboutButton;
@property (weak, nonatomic) IBOutlet UIView *settingsView;
@property (nonatomic, retain) IBOutletCollection(UIButton) NSArray *buttons;

- (IBAction)toggleSettings:(id)sender;

@end
