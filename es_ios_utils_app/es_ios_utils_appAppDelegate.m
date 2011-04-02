#import "es_ios_utils_appAppDelegate.h"
#import "es_ios_utils_appViewController.h"

@implementation es_ios_utils_appAppDelegate

@synthesize window=_window;

@synthesize viewController=_viewController;

-(NSString*)persistantStoreName
{
    return @"Model";
}

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
     
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

-(void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

@end
