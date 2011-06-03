//
//  ESApplicationDelegate.h
//  es_ios_utils
//
//  Created by Peter DeWeese on 3/21/11.
//  Copyright 2011 Eye Street Research, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

/*
 * Many Apple templates contain singletons for managaged objects, the documents directory, etc.  This class obviates such repetition and clutter.  Subclasses must implement persistantStoreName.
 */
@interface ESApplicationDelegate : NSObject<UIApplicationDelegate> {
    
}

+(ESApplicationDelegate*)delegate;

+(NSManagedObjectContext*)managedObjectContext;
+(BOOL)isProduction;

@property(nonatomic, retain) IBOutlet  UIWindow                     *window;

@property(nonatomic, readonly)         NSURL                        *applicationDocumentsDirectory;
@property(nonatomic, readonly)         NSString                     *applicationDirectory;

@property(nonatomic, readonly)         NSString                     *persistantStoreName;

@property(nonatomic, retain, readonly) NSManagedObjectContext       *managedObjectContext;
@property(nonatomic, retain, readonly) NSManagedObjectModel         *managedObjectModel;
@property(nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property(nonatomic, retain, readonly) NSDictionary                 *config;

- (void)saveContext;

@end

#ifndef __OPTIMIZE__ // __OPTIMIZE__ is not enabled, so we will assume that we are in development mode
    #define IS_PRODUCTION NO
#else
    #define IS_PRODUCTION YES
#endif