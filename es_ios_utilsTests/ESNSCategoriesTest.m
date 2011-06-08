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
    NSArray *array = $array(@"first", @"second", @"third");
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
    NSArray *array = $array(first, second, third, fourth);
    
    STAssertEqualObjects(array.firstObject, first, @"Should return first element.");
    STAssertTrue(array.lastIndex == array.count-1, @"Should return length-1");
    array = $array(first, second, third, fourth, second);
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
    
    //wrap with parenthesis to test arrayMappedWithFormat:
    array = $array(first, second);
    array = [array arrayMappedWithFormat:@"(%@)"];
    STAssertEqualObjects([array objectAtIndex:0], @"(first)",  @"element should equal (first)");
    STAssertEqualObjects([array objectAtIndex:1], @"(second)",  @"element should equal (second)");
    
    //unwrap to test arrayMappedWith:
    array = [array arrayMappedWith:^id(id o){
        return [((NSString*)o) stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"()"]];
    }];
    STAssertEqualObjects([array objectAtIndex:0], first,  @"element should equal first");
    STAssertEqualObjects([array objectAtIndex:1], second,  @"element should equal second");
}

-(void)testNSDictionaryCategory
{
    NSDictionary *camelCased = [NSDictionary dictionaryWithObjects:$array(@"o1", @"o2") forKeys:$array(@"myKeyOne", @"myKeyTwo")];
    NSDictionary *underscored = [NSDictionary dictionaryWithObjects:$array(@"o1", @"o2") forKeys:$array(@"my_key_one", @"my_key_two")];
    
    STAssertEqualObjects(camelCased, underscored.asCamelCaseKeysFromUnderscore, @"Should convert to camel case.");
    STAssertEqualObjects(underscored, underscored.asUnderscoreKeysFromCamelCase, @"Should convert to underscore.");
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
    
    NSArray *array = $array(first, @"second", last);
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
    
    d = [NSMutableDictionary dictionaryWithCapacity:2];
    [d setObject:@"object1" forKey:@"key1"];
    [d setObject:@"object2" forKey:@"key2"];
    NSMutableDictionary *d2 = [NSMutableDictionary dictionaryWithCapacity:2];
    [d2 addEntriesFromDictionary:d withKeyFilter:^NSString*(NSString *s){return @"a";}];
    STAssertTrue(d2.count == 1, @"key should be overwritten.");
    STAssertEqualObjects(@"a", d2.allKeys.firstObject, @"Key should be 'a'");
}

-(void)testNSObjectCategory
{
    NSObject *o = [[NSObject alloc] init];
    STAssertEqualObjects(o.className, @"NSObject", @"className should return NSObject");
}

-(void)testNSRegularExpressionCategory
{
    NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:@"postfix$" options:0 error:nil];
    STAssertTrue([re matches:@"String with postfix"], @"RE should match this string.");
    STAssertFalse([re matches:@"String without"], @"RE should not match this string.");
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
    
    STAssertEqualObjects(@"514 B",
                         [NSString stringWithFormattedFileSize:514],
                         @"File size not formatting properly");
    STAssertEqualObjects(@"5.1 KB",
                         [NSString stringWithFormattedFileSize:5.1*1024.],
                         @"File size not formatting properly");
    STAssertEqualObjects(@"2.7 MB",
                         [NSString stringWithFormattedFileSize:2.7*1024.*1024.],
                         @"File size not formatting properly");
    
    STAssertEqualObjects([NSString stringWithClassName:NSObject.class], @"NSObject", @"The class name of an object should be NSObject.");
    
    static NSString *camel = @"myTestString";
    static NSString *underscore = @"my_test_string";
    
    STAssertEqualObjects(camel, underscore.asCamelCaseFromUnderscore, @"Should convert to camel case.");
    STAssertEqualObjects(underscore, camel.asUnderscoreFromCamelCase, @"Should convert to underscores.");
}

@end
