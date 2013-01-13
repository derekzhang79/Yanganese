//
//  Question.m
//  Yanganese
//
//  Created by Michael Yang on 1/13/13.
//  Copyright (c) 2013 Michael Yang. All rights reserved.
//

#import "Question.h"
#import "Quiz.h"


@implementation Question

@dynamic answer;
@dynamic categoryID;
@dynamic text;
@dynamic w;
@dynamic x;
@dynamic y;
@dynamic z;
@dynamic quiz;

#pragma mark -

- (id)initWithEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context andProperties:(NSDictionary *)APIResponse
{
    if(self =[super initWithEntity:entity insertIntoManagedObjectContext:context])
    {
        self.text = [APIResponse objectForKey:@"text"];
        self.answer = [APIResponse objectForKey:@"answer"];
        self.categoryID = [APIResponse objectForKey:@"category_id"];
        self.w = [APIResponse objectForKey:@"w"];
        self.x = [APIResponse objectForKey:@"x"];
        self.y = [APIResponse objectForKey:@"y"];
        self.z = [APIResponse objectForKey:@"z"];
    }
    
    return self;
}

@end
