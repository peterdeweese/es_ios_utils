#import "ESUtils.h"

#if IS_IOS

@interface ESTextField : UITextField
  @property(nonatomic, retain) IBOutlet UIResponder* customNextResponder;
@end

#endif /*IS_IOS*/