//
//  Score.h
//  Yanganese
//
//  Created by Michael Yang on 1/13/13.
//  Copyright (c) 2013 Michael Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CategoryScore, Quiz;

@interface Score : NSManagedObject

@property (nonatomic, retain) NSNumber * timeSecond;
@property (nonatomic, retain) NSNumber * timeMinute;
@property (nonatomic, retain) NSOrderedSet *categoryScores;
@property (nonatomic, retain) Quiz *quiz;

@end

@interface Score (CoreDataGeneratedAccessors)

- (void)insertObject:(CategoryScore *)value inCategoryScoresAtIndex:(NSUInteger)idx;
- (void)removeObjectFromCategoryScoresAtIndex:(NSUInteger)idx;
- (void)insertCategoryScores:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeCategoryScoresAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInCategoryScoresAtIndex:(NSUInteger)idx withObject:(CategoryScore *)value;
- (void)replaceCategoryScoresAtIndexes:(NSIndexSet *)indexes withCategoryScores:(NSArray *)values;
- (void)addCategoryScoresObject:(CategoryScore *)value;
- (void)removeCategoryScoresObject:(CategoryScore *)value;
- (void)addCategoryScores:(NSOrderedSet *)values;
- (void)removeCategoryScores:(NSOrderedSet *)values;

@end