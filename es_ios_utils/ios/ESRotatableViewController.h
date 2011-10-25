#if IS_IOS

#import <UIKit/UIKit.h>

@interface ESRotatableViewController : UIViewController
  -(void)releaseRetainedXibObjects; //override to release on viewDidUnload and dealloc
@end

#endif //IS_IOS