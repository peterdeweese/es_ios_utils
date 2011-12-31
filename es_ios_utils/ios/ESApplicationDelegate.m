#import "ESUtils.h"
#import "ESApplicationDelegate.h"

#if IS_IOS && CORE_DATA_AVAILABLE

@interface ESApplicationDelegate()
  @property(retain) NSManagedObjectModel*         privateManagedObjectModel;
  @property(retain) NSManagedObjectContext*       privateManagedObjectContext;
  @property(retain) NSPersistentStoreCoordinator* privatePersistentStoreCoordinator;
  @property(retain) NSDictionary*                 privateConfig;
@end

@implementation ESApplicationDelegate

@synthesize window, privateManagedObjectModel, privateManagedObjectContext, privatePersistentStoreCoordinator, privateConfig;

-(BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    NSLog(@"Application Directory: %@", self.applicationDirectory);
    return YES;
}

-(void)applicationWillTerminate:(UIApplication*)application
{
    [self saveContext];
}

-(NSString*)persistentStoreName { return @"Database"; }

+(ESApplicationDelegate*)instance
{
    id<UIApplicationDelegate> d = UIApplication.sharedApplication.delegate;
    if([d isKindOfClass:ESApplicationDelegate.class])
        return d;
    $must_override;
    return nil;
}

+(BOOL)isProduction
{
    return IS_PRODUCTION;
}

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL*)applicationDocumentsDirectory
{
    return [NSFileManager.defaultManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].lastObject;
}

/**
 Returns the URL to the application's directory.
 */
- (NSString*)applicationDirectory
{
    return NSBundle.mainBundle.bundlePath;
}


#pragma mark - Core Data stack

+(NSManagedObjectContext*)managedObjectContext
{
    return self.instance.managedObjectContext;
}

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if(!privateManagedObjectContext && self.persistentStoreCoordinator)
    {    
        self.privateManagedObjectContext = [[[NSManagedObjectContext alloc] init] autorelease];
        privateManagedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    }
    return privateManagedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel*)managedObjectModel
{
    if (!privateManagedObjectModel)
    {
        NSURL *modelURL = [NSBundle.mainBundle URLForResource:self.persistentStoreName withExtension:@"momd"];
        self.privateManagedObjectModel = [[[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL] autorelease];
    }
    return privateManagedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created. Then we check to see if a default DB
 is bundled with app and, if so, use that if the database doesn't already exist.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (self.privatePersistentStoreCoordinator)
        return privatePersistentStoreCoordinator;
    
    NSString *storePath = [self.applicationDocumentsDirectory.path stringByAppendingPathComponent:$format(@"%@.sqlite", self.persistentStoreName)];
    NSFileManager *fileManager = NSFileManager.defaultManager;

    // If the expected store doesn't exist, copy the default store.
    if (![fileManager fileExistsAtPath:storePath]) {
        NSString *defaultStorePath = [NSBundle.mainBundle pathForResource:$format(@"%@", self.persistentStoreName) ofType:@"sqlite"];
        if (defaultStorePath)
            [fileManager copyItemAtPath:defaultStorePath toPath:storePath error:NULL];
    }
    NSURL *storeURL = [NSURL fileURLWithPath:storePath];
    
    NSError *error = nil;
    self.privatePersistentStoreCoordinator = [[[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel] autorelease];
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    if (![privatePersistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error])
    {
        [error log];
        abort(); //FIXME: remove before final product
    }    
    
    return privatePersistentStoreCoordinator;
}

-(NSDictionary*)config
{
    if(!privateConfig)
    {
        NSString *environment = ESApplicationDelegate.isProduction ? @"production" : @"development";
        NSLog(@"applicationDirectory: %@", self.applicationDirectory);
        NSString *configPath = [self.applicationDirectory stringByAppendingPathComponent:$format(@"%@.plist", environment)];
        //[[NSURL URLWithString:$format(@"%@.plist", environment) relativeToURL:self.applicationDirectory] path];

        if([NSFileManager.defaultManager fileExistsAtPath:configPath])
            self.privateConfig = [NSDictionary dictionaryWithContentsOfFile:configPath];
        else
            NSLog(@"ERROR: no config file found at %@", configPath); 
    }

    return privateConfig;
}

-(BOOL)isDisplayingAlert { return self.window.isDisplayingAlert; }

+(BOOL)saveContext
{
    return [self.instance saveContext];
}

//Override to prevent aborting the app upon error.
-(BOOL)saveContext
{
    if(self.managedObjectContext.hasChanges)
    {
        return [self.managedObjectContext saveAndDoOnError:^(NSError *e) {
            [e log];
            [e logDetailedErrors];
            abort();
        }];
    }
    return YES;
}

-(void)clearAllPersistentStores
{
    [self persistentStoreCoordinator]; //initialize if needed
        
    for(NSPersistentStore *store in self.persistentStoreCoordinator.persistentStores)
    {
        [self.persistentStoreCoordinator removePersistentStore:store error:nil];
        [NSFileManager.defaultManager removeItemAtPath:store.URL.path error:nil];
    }
    
    self.privatePersistentStoreCoordinator = nil;
    self.privateManagedObjectContext = nil;
    self.privateManagedObjectModel = nil;
}

- (void)dealloc
{
    self.privatePersistentStoreCoordinator = nil;
    self.privateManagedObjectContext       = nil;
    self.privateManagedObjectModel         = nil;
    self.privateConfig                     = nil;
    [super dealloc];
}

@end

#endif /*IS_IOS*/