#if IS_IOS

#import "ESRotatableViewController.h"

@implementation ESRotatableViewController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Supports all orientations
	return YES;
}

@end

#endif //IS_IOS
