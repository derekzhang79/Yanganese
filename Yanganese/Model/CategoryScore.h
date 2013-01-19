//
//  CategoryScore.h
//  Yanganese
//
//  Created by Michael Yang on 1/19/13.
//  Copyright (c) 2013 Michael Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Score;

@interface CategoryScore : NSManagedObject

@property (nonatomic, retain) NSNumber * count;
@property (nonatomic, retain) NSNumber * total;
@property (nonatomic, retain) Score *score;

@end
