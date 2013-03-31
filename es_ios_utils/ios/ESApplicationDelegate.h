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

@property(nonatomic, strong) IBOutlet  UIWindow                     *window;

@property(unsafe_unretained, nonatomic, readonly)         NSURL                        *applicationDocumentsDirectory;
@property(unsafe_unretained, nonatomic, readonly)         NSString                     *applicationDirectory;

@property(unsafe_unretained, nonatomic, readonly)         NSString                     *persistentStoreName;

@property(nonatomic, strong, readonly) NSManagedObjectContext       *managedObjectContext;
@property(nonatomic, strong, readonly) NSManagedObjectModel         *managedObjectModel;
@property(nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property(nonatomic, strong, readonly) NSDictionary                 *config;

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
