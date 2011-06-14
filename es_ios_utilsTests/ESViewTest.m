//
//  ESViewTest.m
//  es_ios_utils
//
//  Created by Peter DeWeese on 4/2/11.
//  Copyright 2011 Eye Street Research, LLC. All rights reserved.
//

#import "ESUtils.h"
#import "ESViewTest.h"
#import "appDelegate.h"
#import "ESVerticalLayoutView.h"
#import "ESFlowLayoutView.h"
#import "TestViewController.h"

@implementation ESViewTest

#if USE_APPLICATION_UNIT_TEST     // all code under test is in the iPhone Application

- (void)testESVerticalLayout;
{
    appDelegate *delegate = [[UIApplication sharedApplication] delegate];
    STAssertNotNil(delegate, @"UIApplication failed to find the AppDelegate");

    ESVerticalLayoutView *v = delegate.viewController.verticalLayout;
    STAssertNotNil(v, @"Vertical layout not initialized.");
        
    STAssertTrue(v.height==80., @"Should stack vertically to 80 pixels tall.");
    sleep(1);//To give time for visual examination
}

- (void)testESFlowLayout;
{    
    appDelegate *delegate = [[UIApplication sharedApplication] delegate];
    STAssertNotNil(delegate, @"UIApplication failed to find the AppDelegate");
    
    ESFlowLayoutView *v = delegate.viewController.flowLayout;
    STAssertNotNil(v, @"Flow layout not initialized.");
    
    STAssertTrue(v.height==40., @"Should make two rows.");
    sleep(1);//To give time for visual examination
}

#endif

@end
