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

- (NSDictionary *)properties
{
    return
    @{
    @"text": self.text,
    @"answer": self.answer,
    @"category_id": self.categoryID,
    @"w": self.w,
    @"x": self.x,
    @"y": self.y,
    @"z": self.z,
    @"quiz_id": self.quiz.quizID
    };
}

- (NSString *)fullText
{
    NSMutableString *text = [[NSMutableString alloc] initWithString:self.text];
    [text appendString:@"\n"];
    
    NSArray *choices = @[@"w", @"x", @"y", @"z"];
    for(NSString *choice in choices)
        [text appendFormat:@"\n%@. %@", choice, [self valueForKey:choice]];
    
	return text;
}

- (NSString *)answerText
{
    return [NSString stringWithFormat:@"%@. %@", self.answer, [self valueForKey:self.answer]];
}

@end
