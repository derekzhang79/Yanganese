//
//  YNGADownloadViewController.h
//  Yanganese
//
//  Created by Michael Yang on 1/13/13.
//  Copyright (c) 2013 Michael Yang. All rights reserved.
//

#import "YNGASelectViewController.h"

@interface YNGADownloadViewController : YNGASelectViewController <NSURLConnectionDelegate>
{    
    NSMutableData *retainedData;
}

@end
