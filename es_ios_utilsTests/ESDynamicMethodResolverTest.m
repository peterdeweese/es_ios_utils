#import "ESDynamicMethodResolverTest.h"
#import "ESDynamicMethodResolver.h"

@interface TestDynamic:ESDynamicMethodResolver
{
    NSString *_data;
    double    _doubleData;
}
@property (assign) NSString *data;
@property (assign) double    doubleData;
@end

@implementation ESDynamicMethodResolverTest

-(void)testDynamicMethodResolver
{
    TestDynamic *d = [TestDynamic alloc];
    NSString *data = @"theDataValue";
    
    STAssertNoThrow(d.data = data, @"Property should set with no error");
    STAssertEquals(data, d.data, @"Property value should match what we set.");
    STAssertNotNil(d.data, @"Property should not be nil.");
    
    //Test with double
    double myDouble = 123.456;
    STAssertNoThrow(d.doubleData = myDouble, @"Property should set with no error");
    STAssertEquals(myDouble, d.doubleData, @"Property value should match what we set.");
    
    [d release];
}

@end


@implementation TestDynamic

@dynamic data, doubleData;

-(id)dynamicGet:(NSString*)methodName
{
    return [@"data" isEqualToString:methodName] ? _data : nil;
}

-(void)dynamicSet:(NSString*)methodName object:(id)o
{
    if([@"data" isEqualToString:methodName])
        _data = o;
}


-(double)dynamicGetDouble:(NSString*)methodName
{
    if([@"doubleData" isEqualToString:methodName])
        return _doubleData;
    return NAN;
}

-(void)dynamicSet:(NSString*)methodName double:(double)d
{
    if([@"doubleData" isEqualToString:methodName])
        _doubleData = d;
}

@end

