//
//  NSCategories.m
//  es_ios_utils
//
//  Created by Peter DeWeese on 3/16/11.
//  Copyright 2011 Eye Street Research, LLC. All rights reserved.
//

#import "ESNSCategories.h"


@implementation ESNSCategories

@end


@implementation NSArray(ESUtils)

-(id)firstObject
{
    return [self objectAtIndex:0];
}

-(BOOL)empty
{
    return self.count == 0;
}

@end


@implementation NSSet(ESUtils)

-(BOOL)empty
{
    return self.count == 0;
}

@end


@implementation NSMutableArray(ESUtils)

- (id)dequeue
{
    if(self.count == 0)
        return nil;
    
    id object = [self objectAtIndex:0];
    [self removeObjectAtIndex:0];
    return object;
}

- (id)pop
{
    if(self.count == 0)
        return nil;
    
    id object = [self lastObject];
    [self removeLastObject];
    return object;
}

@end


@implementation NSString(ESUtils)

-(NSString*)trimmed
{
    return [self stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceCharacterSet];
}

-(BOOL)empty
{
    return self.trimmed.length == 0;
}

@end
