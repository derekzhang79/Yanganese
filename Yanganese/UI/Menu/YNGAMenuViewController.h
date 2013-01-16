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

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (nonatomic, retain) IBOutletCollection(UIButton) NSArray *buttons;

@end
