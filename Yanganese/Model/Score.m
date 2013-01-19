//
//  Score.m
//  Yanganese
//
//  Created by Michael Yang on 1/13/13.
//  Copyright (c) 2013 Michael Yang. All rights reserved.
//

#import "Score.h"
#import "CategoryScore.h"
#import "Quiz.h"

@implementation Score

@dynamic timeSecond;
@dynamic timeMinute;
@dynamic categoryScores;
@dynamic quiz;

#pragma mark - Temp fix for generated accessor

- (void)addCategoryScoresObject:(CategoryScore *)value
{
    NSMutableOrderedSet* temp = [NSMutableOrderedSet orderedSetWithOrderedSet:self.categoryScores];
    [temp addObject:value];
    self.categoryScores = temp;
}

@end
