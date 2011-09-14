#import "ESUtils.h"

#if IS_IOS

@interface ESTextField : UITextField
  @property(nonatomic, retain) IBOutlet UIResponder* nextEditor;
@end

#endif /*IS_IOS*/