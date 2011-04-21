//
//  NSCategoriesTest.m
//  es_ios_utils
//
//  Created by Peter DeWeese on 3/16/11.
//  Copyright 2011 Eye Street Research, LLC. All rights reserved.
//

#import "ESUtils.h"
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
    NSString *second = @"second";
    NSString *third = @"third";
    NSString *fourth = @"fourth";
    NSArray *array = $array(first, second, third, fourth, nil);
    
    STAssertEqualObjects(array.firstObject, first, @"Should return first element.");
    STAssertTrue(array.lastIndex == array.count-1, @"Should return length-1");
    array = $array(first, second, third, fourth, second, nil);
    NSArray *result = [array filteredArrayUsingSet:$set(fourth, second)];
    STAssertTrue(3 == result.count, @"Three elements should remain.");
    STAssertEqualObjects([result objectAtIndex:0], second, @"element should equal second");
    STAssertEqualObjects([result objectAtIndex:1], fourth, @"element should equal fourth");
    STAssertEqualObjects([result objectAtIndex:2], second, @"element should equal second");
    
    array = [NSArray arrayByCoalescing:first, $array(second, third), $set(fourth), nil];
    STAssertEqualObjects([array objectAtIndex:0], first,  @"element should equal first");
    STAssertEqualObjects([array objectAtIndex:1], second, @"element should equal second");
    STAssertEqualObjects([array objectAtIndex:2], third,  @"element should equal third");
    STAssertEqualObjects([array objectAtIndex:3], fourth, @"element should equal fourth");
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

-(void)testNSMutableDictionaryCategory
{
    NSString *value = @"testValue";
    NSObject *key = [[NSObject alloc] init];
    NSMutableDictionary *d = [NSMutableDictionary dictionaryWithCapacity:1];
    
    STAssertNoThrow([d setObject:value forKeyObject:key], @"Dictionary set with object key should not throw an error.");
    STAssertEquals([d objectForKeyObject:key], value, @"value should equal entered value");
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
    
    STAssertFalse(@"   \t\n".isPresent, @"String should not be considered present.");
    STAssertFalse(@"".isPresent, @"String should not be considered present.");
    STAssertTrue(@" qwer ".isPresent, @"String should be considered present.");
}

@end
