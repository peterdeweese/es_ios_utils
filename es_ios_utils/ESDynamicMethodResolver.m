//
//  ESDynamicMethodResolver.m
//  NVSL Scorer
//
//  Created by Peter DeWeese on 3/4/11.
//  Copyright 2011 Eye Street Research, LLC. All rights reserved.
//

#import "ESDynamicMethodResolver.h"
#include <objc/runtime.h>


@implementation ESDynamicMethodResolver

#pragma mark Dynamic Methods

-(id)dynamicGet:(NSString*)methodName
{
    [NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass of ESDynamicMethodResolver", NSStringFromSelector(_cmd)];
    return nil;
}

-(void)dynamicSet:(NSString*)methodName object:(id)o
{
    [NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass of ESDynamicMethodResolver", NSStringFromSelector(_cmd)];
}

id getIMP(ESDynamicMethodResolver *self, SEL cmd)
{
    return [self dynamicGet:NSStringFromSelector(cmd)];;
}

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
