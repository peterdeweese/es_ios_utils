#import "ESUtils.h"
#import "ESNSCategoriesTest.h"
#import "ESApplicationDelegate.h"
#import "Object1.h"
#import "Object2.h"
#import "Object3.h"

@implementation NSCategoriesTest

-(void)setUp
{
    [[ESApplicationDelegate delegate] clearAllPersistentStores];
}

-(void)testNSDecimalNumberCategory
{
    NSDecimalNumber *n = [NSDecimalNumber decimalNumberWithString:@"asdf"];
    STAssertNotNil(n, nil);
    STAssertTrue(n.isNotANumber, nil);
    
    n = [NSDecimalNumber decimalNumberWithString:@"1.0"];
    STAssertNotNil(n, nil);
    STAssertFalse(n.isNotANumber, nil);
}

-(void)testNSErrorCategory
{
    NSError *error = [NSError errorWithDomain:@"test" code:0 userInfo:nil];
    
    STAssertNoThrow([error log], @"Should not throw error.");
    STAssertNoThrow([error logWithMessage:@"prefix"], @"Should not throw error.");
}

-(void)testNSManagedObjectToDictionary
{
    NSManagedObjectContext *context = ESApplicationDelegate.delegate.managedObjectContext;

    Object1 *object1 = (Object1*)[context createManagedObjectOfClass:Object1.class];
    Object2 *object2 = (Object2*)[context createManagedObjectOfClass:Object2.class];
    Object3 *object3 = (Object3*)[context createManagedObjectOfClass:Object3.class];
    
    object1.attribute1 = @"attribute1.value";
    object2.attribute2 = @"attribute2.value";
    object3.attribute3 = @"attribute3.value";
    
    object2.parent = object1;
    object3.parent = object1;
    
    [context saveAndDoOnError:^(NSError *e){ STAssertNil(e, nil); }];
    
    NSDictionary *result = object1.toDictionary;
    NSLog(@"%@", result);
    STAssertEqualObjects([result valueForKeyPath:@"attribute1"], @"attribute1.value", nil);
    STAssertEqualObjects([result valueForKeyPath:@"object2.attribute2"], @"attribute2.value", nil);
    NSArray *object3s = [result valueForKey:@"object3s"];
    NSDictionary *object3D = object3s.firstObject;
    STAssertNotNil(object3D, nil);
    STAssertEqualObjects([object3D valueForKey:@"attribute3"], @"attribute3.value", nil);
}

-(void)testNSManagedObjectContextCategory
{
    NSManagedObjectContext *context = ESApplicationDelegate.delegate.managedObjectContext;
    
    Object1 *object1 = (Object1*)[context createManagedObjectOfClass:Object1.class];
    STAssertNotNil(object1, nil);
    STAssertTrue([object1 isKindOfClass:Object1.class], nil);
    
    static NSString *value = @"value";
    NSDictionary *d = [NSDictionary dictionaryWithObjectsAndKeys:
                       value, @"attribute1",
                       nil];
    object1 = (Object1*)[context createManagedObjectOfClass:Object1.class withDictionary:d];
    STAssertNotNil(object1, nil);
    STAssertTrue([object1 isKindOfClass:Object1.class], nil);
    STAssertEquals(value, object1.attribute1, nil);
    
    STAssertNoThrow([context saveAndDoOnError:^(NSError *e){
            STAssertNil(e, nil);
        }], nil);
    
    STAssertFalse(![context hasAny:Object1.class], nil);
    
    NSArray *a = [context all:Object1.class];
    STAssertNotNil(a, nil);
    STAssertTrue(a.count == 2, @" The count was %i.", a.count);
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

-(void)testNSStringContainsString
{
    STAssertTrue([@"asdf wer adsf" containsString:@"wer"], nil);
    STAssertFalse([@"asdf wer adsf" containsString:@"ttt"], nil);
}

@end
