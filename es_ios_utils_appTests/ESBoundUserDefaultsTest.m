#import "ESBoundUserDefaultsTest.h"
#import "ESBoundUserDefaults.h"

@interface TestDefaults:ESBoundUserDefaults
  @property (assign) NSString* data;
  @property (assign) double    doubleData;
  @property (assign) NSDate*   dateData;
@end

@implementation ESBoundUserDefaultsTest

-(void)testDynamicMethodResolver
{
    TestDefaults *d = [TestDefaults alloc];
    NSString *data = @"theDataValue";
    
    STAssertNoThrow(d.data = data, @"Property should set with no error");
    STAssertEquals(data, d.data, @"Property value should match what we set.");
    STAssertNotNil(d.data, @"Property should not be nil.");
    
    //Test with double
    double myDouble = 123.456;
    STAssertNoThrow(d.doubleData = myDouble, @"Property should set with no error");
    STAssertEquals(myDouble, d.doubleData, @"Property value should match what we set.");
    
    //Test with date
    NSDate* date = NSDate.date;
    STAssertNoThrow(d.dateData = date, @"Property should set with no error");
    STAssertEqualObjects(date, d.dateData, @"Property value should match what we set.");
    
    [d release];
}

@end


@implementation TestDefaults
  @dynamic data, doubleData, dateData;
@end

