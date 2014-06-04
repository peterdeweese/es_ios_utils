#import "ESUtils.h"
#import "ESDynamicMethodResolver.h"
#import <objc/runtime.h>

@implementation ESDynamicMethodResolver

#pragma mark Dynamic Methods

-(void)dynamicSet:(NSString*)methodName object:(id)o{ $must_override; }
-(id)dynamicGet:(NSString*)methodName
{
    $must_override;
    return nil; 
}

-(void)dynamicSet:(NSString*)methodName double:(double)d { }
-(double)dynamicGetDouble:(NSString*)methodName { return NAN; }

//TODO: there should be a better way to get from a setter name to a property
+(NSString*)stripSet:(NSString*)s //remove ^set
{
    NSString *method = [s substringFromIndex:3];
    method = [method substringToIndex:method.length - 1]; //remove :$
    method = [method stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[method substringToIndex:1].lowercaseString];
    return method;
}

id getIMP(ESDynamicMethodResolver *self, SEL cmd);
id getIMP(ESDynamicMethodResolver *self, SEL cmd)
{
    return [self dynamicGet:NSStringFromSelector(cmd)];
}

//TODO pass property name instead of calculating it again
void setIMP(ESDynamicMethodResolver *self, SEL cmd, id obj);
void setIMP(ESDynamicMethodResolver *self, SEL cmd, id obj)
{    
    [self dynamicSet:[ESDynamicMethodResolver stripSet:NSStringFromSelector(cmd)] object:obj];
}

double getDoubleIMP(ESDynamicMethodResolver *self, SEL cmd);
double getDoubleIMP(ESDynamicMethodResolver *self, SEL cmd)
{
    return [self dynamicGetDouble:NSStringFromSelector(cmd)];;
}

void setDoubleIMP(ESDynamicMethodResolver *self, SEL cmd, double d);
void setDoubleIMP(ESDynamicMethodResolver *self, SEL cmd, double d)
{    
    [self dynamicSet:[ESDynamicMethodResolver stripSet:NSStringFromSelector(cmd)] double:d];
}


+ (BOOL)resolveInstanceMethod:(SEL)aSEL
{
    NSString *property = NSStringFromSelector(aSEL);
    BOOL isSet = [property hasPrefix:@"set"];
    if(isSet) property = [self stripSet:property];
    //TODO: this could be generisized for all primitives
    BOOL isDouble = [@"Td" isEqualToString:[ES typeNameStringForProperty:property inClass:self.class]];
    
    IMP imp;
    const char* types;
    
    
    if(isSet)
    {
        imp = isDouble ? (IMP)setDoubleIMP : (IMP)setIMP;
        types = "v@:"; //TODO: use @encode() instead
    }
    else
    {
        imp = isDouble ? (IMP)getDoubleIMP : (IMP)getIMP;
        types = isDouble ? "d@:@" : "@@:@"; //TODO: use @encode() instead
    }
    
    class_addMethod(self.class, aSEL, imp, types);
    
    return YES;
}

-(id)valueForKey:(NSString*)key
{
    return [self dynamicGet:key];
}

@end
