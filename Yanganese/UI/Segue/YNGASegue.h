//
//  YNGASegue.h
//  Yanganese
//
//  Created by Michael Yang on 1/15/13.
//  Copyright (c) 2013 Michael Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^VoidBlock)(void);

@interface YNGASegue : UIStoryboardSegue

@property (readwrite, copy) VoidBlock animations;

@end
