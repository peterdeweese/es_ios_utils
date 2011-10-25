#import "ESBoundDictionary.h"

@implementation ESBoundDictionary

@synthesize dictionary;

-(id)initWithDictionary:(NSDictionary*)d
{
    if(self = [super init])
        dictionary = [d retain];
    return self;
}

-(id)dynamicGet:(NSString*)methodName
{
    return [dictionary objectForKey:methodName];
}

-(void)dynamicSet:(NSString*)methodName object:(id)o
{
    if([dictionary isKindOfClass:NSMutableDictionary.class])
    [((NSMutableDictionary*)dictionary) setObject:o forKey:methodName];
}

-(void)dealloc
{
    [dictionary release], dictionary = nil;
    [super dealloc];
}
@end
