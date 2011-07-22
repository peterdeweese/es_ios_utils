#import "ESUtils.h"
#import "ESCollectionCategoriesTest.h"
#import "ESApplicationDelegate.h"
#import "Object1.h"
#import "Object2.h"
#import "Object3.h"

@implementation NSCollectionCategoriesTest

-(void)setUp
{
    [[ESApplicationDelegate delegate] clearAllPersistentStores];
}

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
    
    array = $array(first, second, third, fourth);
    STAssertEqualObjects(array.reversed, $array(fourth, third, second, first), nil);
}

-(void)testNSArrayMappedWith
{
    NSString *first = @"first";
    NSString *second = @"second";
    
    //wrap with parenthesis to test arrayMappedWithFormat:
    NSArray *array = $array(first, second);
    array = [array arrayMappedWithFormat:@"(%@)"];
    STAssertTrue(array.count == 2, nil);
    STAssertEqualObjects([array objectAtIndex:0], @"(first)",  @"element should equal (first)");
    STAssertEqualObjects([array objectAtIndex:1], @"(second)",  @"element should equal (second)");
    
    //unwrap to test arrayMappedWith:
    array = [array arrayMappedWith:^id(id o){
        return [((NSString*)o) stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"()"]];
    }];
    STAssertTrue(array.count == 2, nil);
    STAssertEqualObjects([array objectAtIndex:0], first,  @"element should equal first");
    STAssertEqualObjects([array objectAtIndex:1], second,  @"element should equal second");
    
    //Test single item array (there was an issue with returning two)
    array = $array(first);
    array = [array arrayMappedWithFormat:@"\"%@\""];
    STAssertTrue(array.count == 1, nil);
    STAssertEqualObjects(array.firstObject, @"\"first\"", nil);
}

-(void)testNSArrayFilteredArrayWhereKeyPath
{
    static NSString *fiveLength = @"12345";
    
    NSArray *source = $array(@"1234", fiveLength, @"123", @"12", fiveLength);
    NSArray *result = [source filteredArrayWhereKeyPath:@"length" equals:[NSNumber numberWithInt:5]];
    STAssertNotNil(result, nil);
    STAssertTrue(result.count == 2, @"was %i", result.count);
    STAssertEquals(result.firstObject, fiveLength, nil);
    STAssertEquals(result.lastObject, fiveLength, nil);
}

-(void)testNSDictionaryCategory
{
    static NSString *o1 = @"o1";
    
    NSDictionary *camelCased = [NSDictionary dictionaryWithObjects:$array(o1, @"o2") forKeys:$array(@"myKeyOne", @"myKeyTwo")];
    NSDictionary *underscored = [NSDictionary dictionaryWithObjects:$array(o1, @"o2") forKeys:$array(@"my_key_one", @"my_key_two")];
    
    STAssertEqualObjects(camelCased, underscored.asCamelCaseKeysFromUnderscore, @"Should convert to camel case.");
    STAssertEqualObjects(underscored, camelCased.asUnderscoreKeysFromCamelCase, @"Should convert to underscore.");
    
    STAssertEqualObjects(camelCased, camelCased.asDeepCopy, @"Deep copy should provide identical copy.");

    NSDictionary *deepDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    o1, @"key", //test plain key
                                    camelCased, @"dictionary", //test dictionary
                                    $array(camelCased, underscored),  @"array", //test array of dictionaries
                                    nil];
    NSDictionary *deepCopy = deepDictionary.asDeepCopy;
    STAssertNotNil(deepCopy, nil);
    STAssertEqualObjects(o1, [deepCopy objectForKey:@"key"], @"simple key should copy.");
    STAssertTrue(o1 == [deepCopy objectForKey:@"key"], @"simple key should return original object.");
    
    STAssertEqualObjects(camelCased, [deepCopy objectForKey:@"dictionary"], @"dictionary should copy.");
    STAssertTrue(camelCased != [deepCopy objectForKey:@"dictionary"], @"dictionary should not return original object.");
    
    STAssertEqualObjects(camelCased, ((NSArray*)[deepCopy objectForKey:@"array"]).firstObject, @"array of dictionaries should copy.");
    STAssertTrue(camelCased != ((NSArray*)[deepCopy objectForKey:@"array"]).firstObject, @"array of dictionaries should not return original object.");
}

-(void)testNSMutableArrayQueue
{
    NSString *first = @"first";
    NSString *last = @"last";
    
    NSArray *array = $array(first, @"second", last);
    NSMutableArray *ma = array.mutableCopy;
    
    STAssertEqualObjects(last, ma.pop, @"Pop should return last element");
    STAssertEqualObjects(first, ma.dequeue, @"Dequeue should return first element");
    STAssertTrue(ma.count==1, @"Array should have 1 element left after a pop and dequeue.");
}

-(void)testNSMutableArrayReplaceObject
{
    NSMutableArray *array = [$array(@"one", @"two", @"three") mutableCopy];
    [array replaceObject:@"two" withObject:@"replaced"];
    STAssertEqualObjects($array(@"one", @"replaced", @"three"), array, nil);
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

-(void)testNSSetCategory
{
    // see testEmpty
}

@end
