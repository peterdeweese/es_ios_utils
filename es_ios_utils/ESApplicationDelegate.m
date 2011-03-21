//
//  ESApplicationDelegate.m
//  es_ios_utils
//
//  Created by Peter DeWeese on 3/21/11.
//  Copyright 2011 Eye Street Research, LLC. All rights reserved.
//

#import "ESApplicationDelegate.h"
#import "ESUtils.h"

@implementation ESApplicationDelegate

@synthesize managedObjectContext=__managedObjectContext, managedObjectModel=__managedObjectModel, persistentStoreCoordinator=__persistentStoreCoordinator;

+(ESApplicationDelegate*)delegate
{
    id<UIApplicationDelegate> d = [UIApplication sharedApplication].delegate;
    if([d isKindOfClass:ESApplicationDelegate.class])
        return d;
    [NSException raise:NSInternalInconsistencyException format:@"Your UIApplicationDelegate must extend ESApplicationDelegate to use this method.", NSStringFromSelector(_cmd)];
    return nil;
}

- (void)dealloc
{
    [__managedObjectContext release];
    [__managedObjectModel release];
    [__persistentStoreCoordinator release];
    
    [super dealloc];
}

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].lastObject;
}

#pragma mark - Core Data stack

+(NSManagedObjectContext*)managedObjectContext
{
    return [self delegate].managedObjectContext;
}

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext)
        return __managedObjectContext;
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        __managedObjectContext.persistentStoreCoordinator = coordinator;
    }
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel)
        return __managedObjectModel;
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"cap" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator)
        return __persistentStoreCoordinator;
    
    NSURL *storeURL = [self.applicationDocumentsDirectory URLByAppendingPathComponent:@"cap.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        [error log];
        abort(); //FIXME: remove before final product
    }    
    
    return __persistentStoreCoordinator;
}

@end
