@class TestViewController;

#import "ESApplicationDelegate.h"

//Use ESApplicationDelegate to automatically include core data properties usually included in Apple templates.
@interface appDelegate : ESApplicationDelegate {

}

@property (nonatomic, strong) IBOutlet UIWindow *window;

@property (nonatomic, strong) IBOutlet TestViewController *viewController;

@end
