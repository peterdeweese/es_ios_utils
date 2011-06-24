#define USE_APPLICATION_UNIT_TEST 1

#import <SenTestingKit/SenTestingKit.h>


@interface ESApplicationDelegateTest : SenTestCase { }

#if USE_APPLICATION_UNIT_TEST
-(void)testAppDelegate;       // simple test on application
-(void)testIsProduction;
-(void)testConfigFile;

#else
#endif

@end
