#import "ESBoundUserDefaults.h"
#import <objc/runtime.h>

@implementation ESBoundUserDefaults

-(id)dynamicGet:(NSString*)methodName
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:methodName];
}

-(void)dynamicSet:(NSString*)methodName object:(id)o
{
    //NSLog(@"attribute: %@", [ES isPropertyADouble:methodName inClass:self.class] ? @"Y" : @"N");
    
    //Some kind of constant for a switch would be better than checking for each type
    [[NSUserDefaults standardUserDefaults] setObject:o forKey:methodName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(double)dynamicGetDouble:(NSString*)methodName
{
    return [[NSUserDefaults standardUserDefaults] doubleForKey:methodName];
}

-(void)dynamicSet:(NSString*)methodName double:(double)d
{    
    //Some kind of constant for a switch would be better than checking for each type
    [[NSUserDefaults standardUserDefaults] setDouble:d forKey:methodName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
