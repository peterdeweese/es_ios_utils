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
 * Many Apple templates contain singletons for managaged objects, the documents directory, etc.  This class obviates such repetition and clutter.
 */
@interface ESApplicationDelegate : NSObject<UIApplicationDelegate> {
    
}

+(ESApplicationDelegate*)delegate;

+(NSManagedObjectContext*)managedObjectContext;

@property (nonatomic, readonly)         NSURL                        *applicationDocumentsDirectory;

@property (nonatomic, retain, readonly) NSManagedObjectContext       *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel         *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end
