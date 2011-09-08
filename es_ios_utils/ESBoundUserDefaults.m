#import "ESBoundUserDefaults.h"

@implementation ESBoundUserDefaults

-(id)dynamicGet:(NSString*)methodName
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:methodName];
}

-(void)dynamicSet:(NSString*)methodName object:(id)o
{
    [[NSUserDefaults standardUserDefaults] setObject:o forKey:methodName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
