//
//  YNGAAppDelegate.h
//  Yanganese
//
//  Created by Michael Yang on 1/12/13.
//  Copyright (c) 2013 Michael Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YNGAAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
