//
//  Quiz.m
//  Yanganese
//
//  Created by Michael Yang on 1/13/13.
//  Copyright (c) 2013 Michael Yang. All rights reserved.
//

#import "Quiz.h"
#import "Question.h"


@implementation Quiz

@dynamic author;
@dynamic categoryID;
@dynamic finished;
@dynamic quizID;
@dynamic rating;
@dynamic title;
@dynamic questions;

#pragma mark -

- (id)initWithEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context andProperties:(NSDictionary *)APIResponse
{
    if(self = [super initWithEntity:entity insertIntoManagedObjectContext:context])
    {
        self.quizID = [APIResponse objectForKey:@"quiz_id"];
        self.title = [APIResponse objectForKey:@"title"];
        self.author = [APIResponse objectForKey:@"author"];
        self.categoryID  = [APIResponse objectForKey:@"category_id"];
        self.rating = [APIResponse objectForKey:@"rating_percent"];
    }
    
    return self;
}

@end
