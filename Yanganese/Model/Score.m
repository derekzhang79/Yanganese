//
//  Score.m
//  Yanganese
//
//  Created by Michael Yang on 1/13/13.
//  Copyright (c) 2013 Michael Yang. All rights reserved.
//

#import "Score.h"
#import "Quiz.h"

@implementation Score

@dynamic counts;
@dynamic totals;
@dynamic time;
@dynamic quiz;

- (id)initWithEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context
{
    if(self = [super initWithEntity:entity insertIntoManagedObjectContext:context])
    {
        self.counts = @[@0, @0, @0, @0, @0, @0, @0];
        self.totals = @[@0, @0, @0, @0, @0, @0, @0];
    }
    
    return self;
}

#pragma mark -

- (id)initWithEntity:(NSEntityDescription *)entity counts:(NSArray *)counts totals:(NSArray *)totals insertIntoManagedObjectContext:(NSManagedObjectContext *)context
{
    if(self = [super initWithEntity:entity insertIntoManagedObjectContext:context])
    {
        self.counts = counts;
        self.totals = totals;
    }
    
    return self;
}

@end
