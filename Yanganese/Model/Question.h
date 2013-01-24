//
//  Question.h
//  Yanganese
//
//  Created by Michael Yang on 1/13/13.
//  Copyright (c) 2013 Michael Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Quiz;

@interface Question : NSManagedObject

@property (nonatomic, retain) NSString * answer;
@property (nonatomic, retain) NSNumber * categoryID;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * w;
@property (nonatomic, retain) NSString * x;
@property (nonatomic, retain) NSString * y;
@property (nonatomic, retain) NSString * z;
@property (nonatomic, retain) Quiz *quiz;

- (id)initWithEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context andProperties:(NSDictionary *)APIResponse;
- (NSDictionary *)properties;

- (NSString *)fullText;
- (NSString *)answerText;

@end
