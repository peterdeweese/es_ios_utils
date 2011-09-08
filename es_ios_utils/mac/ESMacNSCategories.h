#if IS_MAC

#import <Cocoa/Cocoa.h>

@interface ESMacNSCategories : NSObject
@end

@interface NSFont(ESUtils)
  -(NSFont*)fontSizedForAreaSize:(NSSize)size withString:(NSString*)string;
@end

@interface NSWorkspace(ESUtils)
  -(BOOL)openURLWithString:(NSString*)url;
@end

#endif //IS_MAC