#import "ESUtils.h"
#import "ESUtilsTest.h"

@implementation ESUtilsTest

- (void)testMacros
{
    NSArray *array = $array(@"item1", @"item2", nil);
    STAssertTrue(array.count==2, @"Array macro should produce count.");
    
    NSSet *set = $set(@"item1", @"item2", nil);
    STAssertTrue(set.count==2, @"Set macro should produce count.");
    
    STAssertEqualObjects(@"prefix postfix", 
                         $format(@"%@ %@", @"prefix", @"postfix"),
                         @"$format macro should work.");
}

@end
