#import "ESDynamicMethodResolverTest.h"
#import "ESDynamicMethodResolver.h"

@interface TestDynamic:ESDynamicMethodResolver
  @property(assign) NSString* data;
  @property(assign) double    doubleData;
@end

@implementation ESDynamicMethodResolverTest

-(void)testDynamicMethodResolver
{
    TestDynamic *d = [TestDynamic alloc];
    NSString *data = @"theDataValue";
    
    STAssertNoThrow(d.data = data, @"Property should set with no error");
    STAssertEquals(data, d.data, @"Property value should match what we set.");
    STAssertNotNil(d.data, @"Property should not be nil.");
    
    [d release];
}

@end


@implementation TestDynamic

@dynamic data, doubleData;
                    
-(id)dynamicGet:(NSString*)methodName
{
    return [@"data" isEqualToString:methodName] ? self.data : nil;
}

-(void)dynamicSet:(NSString*)methodName object:(id)o
{
    if([@"data" isEqualToString:methodName])
        self.data = o;
}

-(double)dynamicGetDouble:(NSString*)methodName
{
    return [@"data" isEqualToString:methodName] ? (double)self.doubleData : (double)NAN;
}

-(void)dynamicSet:(NSString*)methodName double:(double)d
{
    if([@"data" isEqualToString:methodName])
        self.doubleData = d;
}

@end
