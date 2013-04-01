#import "ESBoundDictionary.h"

@implementation ESBoundDictionary

@synthesize dictionary;

-(id)initWithDictionary:(NSDictionary*)d
{
    if(self = [super init])
        self.dictionary = d;
    return self;
}

-(id)dynamicGet:(NSString*)methodName
{
    return dictionary[methodName];
}

-(void)dynamicSet:(NSString*)methodName object:(id)o
{
    if([dictionary isKindOfClass:NSMutableDictionary.class])
    ((NSMutableDictionary*)dictionary)[methodName] = o;
}

@end
