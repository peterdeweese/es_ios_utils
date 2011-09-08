#import "ESUtils.h"
#import "ESDynamicMethodResolver.h"
#include <objc/runtime.h>

@implementation ESDynamicMethodResolver

#pragma mark Dynamic Methods

-(id)dynamicGet:(NSString*)methodName
{
    $must_override;
    return nil;
}

-(void)dynamicSet:(NSString*)methodName object:(id)o
{
    $must_override;
}

id getIMP(ESDynamicMethodResolver *self, SEL cmd);
id getIMP(ESDynamicMethodResolver *self, SEL cmd)
{
    return [self dynamicGet:NSStringFromSelector(cmd)];;
}

void setIMP(ESDynamicMethodResolver *self, SEL cmd, id obj);
void setIMP(ESDynamicMethodResolver *self, SEL cmd, id obj)
{
    NSString *method = [NSStringFromSelector(cmd) substringFromIndex:3]; //remove ^set
    method = [method substringToIndex:method.length - 1]; //remove :$
    method = [method stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[method substringToIndex:1] lowercaseString]];
    
    [self dynamicSet:method object:obj];
}

+ (BOOL)resolveInstanceMethod:(SEL)aSEL
{
    NSString *method = NSStringFromSelector(aSEL);
        
    if([method hasPrefix:@"set"])
        class_addMethod([self class], aSEL, (IMP)setIMP, "v@:");
    else
        class_addMethod([self class], aSEL, (IMP)getIMP, "@@:@");
    
    return YES;
}

@end
