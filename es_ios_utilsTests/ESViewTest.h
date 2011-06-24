#define USE_APPLICATION_UNIT_TEST 1

@interface ESViewTest : SenTestCase { }

#if USE_APPLICATION_UNIT_TEST
    - (void)testESVerticalLayout;
#endif

@end
