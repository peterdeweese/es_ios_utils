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

@synthesize managedObjectContext, managedObjectModel, persistentStoreCoordinator, window, config;

-(NSString*)persistantStoreName
{
    $must_override;
    return nil;
}

+(ESApplicationDelegate*)delegate
{
    id<UIApplicationDelegate> d = [UIApplication sharedApplication].delegate;
    if([d isKindOfClass:ESApplicationDelegate.class])
        return d;
    $must_override;
    return nil;
}

+(BOOL)isProduction
{
    return IS_PRODUCTION;
}

- (void)dealloc
{
    [managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
    [config release];
    
    [super dealloc];
}

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL*)applicationDocumentsDirectory
{
    return [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].lastObject;
}

/**
 Returns the URL to the application's directory.
 */
- (NSString*)applicationDirectory
{
    return [NSBundle mainBundle].bundlePath;
}


#pragma mark - Core Data stack

+(NSManagedObjectContext*)managedObjectContext
{
    return self.delegate.managedObjectContext;
}

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if(managedObjectContext)
        return managedObjectContext;
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator)
    {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        managedObjectContext.persistentStoreCoordinator = coordinator;
    }
    return managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (managedObjectModel)
        return managedObjectModel;
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:self.persistantStoreName withExtension:@"momd"];
    managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created. Then we check to see if a default DB
 is bundled with app and, if so, use that if the database doesn't already exist.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (persistentStoreCoordinator)
        return persistentStoreCoordinator;
    
    NSString *storePath = [[self.applicationDocumentsDirectory path] stringByAppendingPathComponent:$format(@"%@.sqlite", self.persistantStoreName)];
    NSFileManager *fileManager = [NSFileManager defaultManager];

    // If the expected store doesn't exist, copy the default store.
    if (![fileManager fileExistsAtPath:storePath]) {
        NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:$format(@"%@", self.persistantStoreName) ofType:@"sqlite"];
        if (defaultStorePath) {
            [fileManager copyItemAtPath:defaultStorePath toPath:storePath error:NULL];
        }
    }
    NSURL *storeURL = [NSURL fileURLWithPath:storePath];
    
    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL 
                                                        options:options error:&error])
    {
        [error log];
        abort(); //FIXME: remove before final product
    }    
    
    return persistentStoreCoordinator;
}

-(NSDictionary*)config
{
    if(!config)
    {
        NSString *environment = [ESApplicationDelegate isProduction] ? @"production" : @"development";
        NSLog(@"test: %@", self.applicationDirectory);
        NSString *configPath = [self.applicationDirectory stringByAppendingPathComponent:$format(@"%@.plist", environment)];
        //[[NSURL URLWithString:$format(@"%@.plist", environment) relativeToURL:self.applicationDirectory] path];

        if([[NSFileManager defaultManager] fileExistsAtPath:configPath])
            config = [[NSDictionary dictionaryWithContentsOfFile:configPath] retain];
        else
            NSLog(@"ERROR: no config file found at %@", configPath); 
    }
    return config;
}

- (void)saveContext
{
    if(managedObjectContext.hasChanges)
    {
        [managedObjectContext saveAndDoOnError:^(NSError *e) {
            [e log];
            abort();
        }];
    }
}

@end
