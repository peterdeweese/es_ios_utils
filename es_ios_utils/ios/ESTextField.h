#import "ESUtils.h"

#if IS_IOS

@interface ESTextField : UITextField
  @property(nonatomic, strong) IBOutlet UIResponder* nextEditor;
@end

#endif /*IS_IOS*/