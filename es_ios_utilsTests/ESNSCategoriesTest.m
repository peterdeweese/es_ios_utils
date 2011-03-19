//
//  NSCategoriesTest.m
//  es_ios_utils
//
//  Created by Peter DeWeese on 3/16/11.
//  Copyright 2011 Eye Street Research, LLC. All rights reserved.
//

#import "ESNSCategoriesTest.h"

@implementation NSCategoriesTest

-(void)testIsEmpty
{
    NSArray *emptyArray = NSArray.array;
    NSArray *array = $array(@"first", @"second", @"third", nil);
    STAssertFalse(array.isEmpty, @"Array should not be empty.");
    STAssertTrue(emptyArray.isEmpty, @"Array should be empty.");
    STAssertTrue(array.isNotEmpty, @"Array should not be empty");
    STAssertFalse(emptyArray.isNotEmpty, @"Array should be empty");
    
    STAssertTrue(@"".isEmpty, @"String should be empty.");
    STAssertFalse(@"  ".isEmpty, @"String with whitespace should not be empty.");
    STAssertFalse(@"".isNotEmpty, @"String should be empty.");
    STAssertTrue(@"  ".isNotEmpty, @"String with whitespace should not be empty.");
    
    NSSet *set = $set(@"item1", @"item2");
    NSSet *emptySet = NSSet.set;
    STAssertFalse(set.isEmpty, @"Set should not be empty.");
    STAssertTrue(emptySet.isEmpty, @"Set should be empty.");
    STAssertTrue(set.isNotEmpty, @"Set should not be empty.");
    STAssertFalse(emptySet.isNotEmpty, @"Set should be empty.");
    
    STAssertTrue([NSNull null].isEmpty, @"NSNull should be empty.");
    STAssertFalse([NSNull null].isNotEmpty, @"NSNull should be empty.");
    
    NSArray *nilArray = nil;
    STAssertFalse(nilArray.isEmpty, @"I wish that nil empty should be considered true, but alas it will not.");
    STAssertFalse(nilArray.isNotEmpty, @"Nil should not be not empty.");
}

-(void)testNSArrayCategory
{
    NSString *first = @"first";
    NSArray *array = $array(first, @"second", @"third", nil);
    
    STAssertEqualObjects(array.firstObject, first, @"Should return first element.");
}

-(void)testNSErrorCategory
{
    NSError *error = [NSError errorWithDomain:@"test" code:0 userInfo:nil];
    
    STAssertNoThrow([error log], @"Should not throw error.");
    STAssertNoThrow([error logWithMessage:@"prefix"], @"Should not throw error.");
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

-(void)testNSSetCategory
{
    // see testEmpty
}

-(void)testNSStringCategory
{
    STAssertEqualObjects(@"strip", @"\t strip\n  ".strip, @"Strip should remove whitespace.");
    STAssertTrue(@"   \t\n".isBlank, @"String should be considered blank.");
    STAssertTrue(@"".isBlank, @"String should be considered blank.");
    STAssertFalse(@" qwer ".isBlank, @"String should not be considered blank.");
}

@end
