//
//  YNGAAboutViewController.m
//  Yanganese
//
//  Created by Michael Yang on 1/18/13.
//  Copyright (c) 2013 Michael Yang. All rights reserved.
//

#import "YNGAAboutViewController.h"

#import "YNGAAlertView.h"

@implementation YNGAAboutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    NSString *formattedVersion = [[NSString alloc] initWithFormat:@"v%@", version];
    _versionLabel.text = formattedVersion;
}

#pragma mark -

- (IBAction)back
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)sendSupportMail
{
    YNGAAlertView *alertView = [[YNGAAlertView alloc] initWithFrame:CGRectMake(30, 120, 260, 200)];
    alertView.messageLabel.text = @"Switch to the mail app?";
    alertView.delegate = self;
    
    [self.view addSubview:alertView];
    [alertView show];
}

#pragma mark - Alert view delegate

- (void)alertView:(YNGAAlertView *)alertView didDismissWithButtonIndex:(ButtonIndex)buttonIndex
{
    if(buttonIndex == kOKButtonIndex)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kMailAddress]];
    }
}

@end
