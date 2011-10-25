#if IS_IOS

#import "ESRotatableViewController.h"

@implementation ESRotatableViewController

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Supports all orientations
	return YES;
}

-(void)viewDidUnload
{
    [super viewDidUnload];
    [self releaseRetainedXibObjects];
}

-(void)releaseRetainedXibObjects { /*override*/ }

-(void)dealloc
{
    [self releaseRetainedXibObjects];
    [super dealloc];
}

@end

#endif //IS_IOS
