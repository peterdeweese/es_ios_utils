#import "appDelegate.h"
#import "TestViewController.h"

@implementation appDelegate

@synthesize window=_window;

@synthesize viewController=_viewController;

-(NSString*)persistentStoreName
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


@end
