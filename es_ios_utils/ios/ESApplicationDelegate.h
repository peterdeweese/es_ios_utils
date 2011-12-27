#import "ESUtils.h"

#if (IS_IOS && CORE_DATA_AVAILABLE) || USE_APPLICATION_UNIT_TEST

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

#import "ESCDCategories.h"

/*
 * Many Apple templates contain singletons for managaged objects, the documents directory, etc.  This class obviates such repetition and clutter.  Subclasses must implement persistentStoreName.
 */
@interface ESApplicationDelegate : NSObject<UIApplicationDelegate>

+(ESApplicationDelegate*)instance;

+(NSManagedObjectContext*)managedObjectContext;
+(BOOL)isProduction;

@property(nonatomic, retain) IBOutlet  UIWindow                     *window;

@property(nonatomic, readonly)         NSURL                        *applicationDocumentsDirectory;
@property(nonatomic, readonly)         NSString                     *applicationDirectory;

@property(nonatomic, readonly)         NSString                     *persistentStoreName;

@property(nonatomic, retain, readonly) NSManagedObjectContext       *managedObjectContext;
@property(nonatomic, retain, readonly) NSManagedObjectModel         *managedObjectModel;
@property(nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property(nonatomic, retain, readonly) NSDictionary                 *config;

@property(nonatomic, readonly) BOOL isDisplayingAlert;

+(BOOL)saveContext;
-(BOOL)saveContext; //Override to prevent aborting the app upon error.

-(void)clearAllPersistentStores;

@end

#ifndef __OPTIMIZE__ // __OPTIMIZE__ is not enabled, so we will assume that we are in development mode
    #define IS_PRODUCTION NO
#else
    #define IS_PRODUCTION YES
#endif

#endif /*IS_IOS*/
