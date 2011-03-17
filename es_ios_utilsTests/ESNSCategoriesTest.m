//
//  NSCategoriesTest.m
//  es_ios_utils
//
//  Created by Peter DeWeese on 3/16/11.
//  Copyright 2011 Eye Street Research, LLC. All rights reserved.
//

#import "ESNSCategoriesTest.h"

@implementation NSCategoriesTest

-(void)testNSArrayCategory
{
    NSString *first = @"first";
    NSArray *array = $array(first, @"second", @"third", nil);
    NSArray *emptyArray = NSArray.array;
    
    STAssertEqualObjects(array.firstObject, first, @"Should return first element.");
    
    STAssertFalse(array.empty, @"Array should not be empty.");
    STAssertTrue(emptyArray.empty, @"Array should be empty.");
}

-(void)testNSSetCategory
{
    NSSet *set = $set(@"item1", @"item2");
    NSSet *emptySet = NSSet.set;
    
    STAssertFalse(set.empty, @"Set should not be empty.");
    STAssertTrue(emptySet.empty, @"Set should be empty.");
}

-(void)testNSMutableArrayCategory
{
    NSString *first = @"first";
    NSString *last = @"last";
    
    NSArray *array = $array(first, @"second", last, nil);
    NSMutableArray *ma = array.mutableCopy;
    
    STAssertEqualObjects(last, ma.pop, @"Pop should return last element");
    STAssertEqualObjects(first, ma.dequeue, @"Dequeue should return first element");
    STAssertTrue(ma.count==1, @"Array should have 1 element left after a pop and dequeue.");
}

-(void)testNSStringCategory
{
    STAssertEqualObjects(@"trimmed", @"\t trimmed  ".trimmed, @"Trim should remove whitespace.");
    STAssertTrue(@"".empty, @"String should be empty.");
    STAssertTrue(@"  ".empty, @"String with only whitespace should be empty.");
    STAssertFalse(@" dsd ".empty, @"String should not be considered empty.");
}

@end
