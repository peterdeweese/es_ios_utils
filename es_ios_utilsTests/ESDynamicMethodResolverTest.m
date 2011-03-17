//
//  ESDynamicMethodResolverTest.m
//  es_ios_utils
//
//  Created by Peter DeWeese on 3/17/11.
//  Copyright 2011 Eye Street Research, LLC. All rights reserved.
//

#import "ESDynamicMethodResolverTest.h"
#import "ESDynamicMethodResolver.h"

@interface TestDynamic:ESDynamicMethodResolver
{
    NSString *_data;
}
@property (assign) NSString *data;
@end

@implementation ESDynamicMethodResolverTest

-(void)testDynamicMethodResolver
{
    TestDynamic *d = [TestDynamic alloc];
    NSString *data = @"theDataValue";
    
    STAssertNoThrow(d.data = data, @"Property should set with no error");
    STAssertEquals(data, d.data, @"Property value should match what we set.");
    STAssertNotNil(d.data, @"Property should not be nil.");
    
    [d release];
}

@end


@implementation TestDynamic

@dynamic data;
                    
-(id)dynamicGet:(NSString*)methodName
{
    return [@"data" isEqualToString:methodName] ? _data : nil;
}

-(void)dynamicSet:(NSString*)methodName object:(id)o
{
    if([@"data" isEqualToString:methodName])
        _data = o;
}

@end
