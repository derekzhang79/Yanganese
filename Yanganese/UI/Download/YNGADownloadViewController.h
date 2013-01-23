//
//  YNGADownloadViewController.h
//  Yanganese
//
//  Created by Michael Yang on 1/13/13.
//  Copyright (c) 2013 Michael Yang. All rights reserved.
//

#import "YNGAQuizSelectViewController.h"

@class YNGAPopupView;

@interface YNGADownloadViewController : YNGAQuizSelectViewController <NSURLConnectionDelegate>
{
    YNGAPopupView *popupView;
    UIActivityIndicatorView *activityView;
    
    NSMutableData *retainedData;
}

@end
