@class TestViewController;

#import "ESApplicationDelegate.h"

//Use ESApplicationDelegate to automatically include core data properties usually included in Apple templates.
@interface es_ios_utils_appAppDelegate : ESApplicationDelegate {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet TestViewController *viewController;

@end
