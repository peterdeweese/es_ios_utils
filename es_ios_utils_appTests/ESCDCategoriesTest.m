#import "ESCDCategoriesTest.h"

#import "ESUtils.h"
#import "ESNSCategoriesTest.h"
#import "ESApplicationDelegate.h"
#import "Object1.h"
#import "Object2.h"
#import "Object3.h"

@implementation ESCDCategoriesTest

-(void)testNSManagedObjectToDictionary
{
    NSManagedObjectContext *context = ESApplicationDelegate.instance.managedObjectContext;
    
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
    
    
    result = object1.toDictionaryForRails;
    NSLog(@"%@", result);
    STAssertEqualObjects([result valueForKeyPath:@"attribute1"], @"attribute1.value", nil);
    STAssertEqualObjects([result valueForKeyPath:@"object2_attributes.attribute2"], @"attribute2.value", nil);
    object3s = [result valueForKey:@"object3s_attributes"];
    object3D = object3s.firstObject;
    STAssertNotNil(object3D, nil);
    STAssertEqualObjects([object3D valueForKey:@"attribute3"], @"attribute3.value", nil);
}

-(void)testNSManagedObjectContextCategory
{
    NSManagedObjectContext *context = ESApplicationDelegate.instance.managedObjectContext;
    
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
    //STAssertTrue(a.count == 2, @" The count was %i.", a.count);
}

@end
