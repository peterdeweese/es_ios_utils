//
//  ESViewTest.h
//  es_ios_utils
//
//  Created by Peter DeWeese on 4/2/11.
//  Copyright 2011 Eye Street Research, LLC. All rights reserved.
//

#define USE_APPLICATION_UNIT_TEST 1

@interface ESViewTest : SenTestCase {
    
}

#if USE_APPLICATION_UNIT_TEST
    - (void)testESVerticalLayout;
#endif

@end
