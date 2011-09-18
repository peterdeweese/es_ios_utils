#import <Foundation/Foundation.h>

@interface ESDynamicMethodResolver : NSObject
-(id)dynamicGet:(NSString*)methodName;
-(void)dynamicSet:(NSString*)methodName object:(id)o;
-(void)dynamicSet:(NSString*)methodName double:(double)d;
-(double)dynamicGetDouble:(NSString*)methodName;
@end
