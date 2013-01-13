//
//  Score.h
//  Yanganese
//
//  Created by Michael Yang on 1/13/13.
//  Copyright (c) 2013 Michael Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Score : NSManagedObject

@property (nonatomic, retain) NSArray * counts;
@property (nonatomic, retain) NSArray * totals;
@property (nonatomic, retain) NSNumber * time;

- (id)initWithEntity:(NSEntityDescription *)entity counts:(NSArray *)counts totals:(NSArray *)totals insertIntoManagedObjectContext:(NSManagedObjectContext *)context;

@end
