#import "ESBoundUserDefaults.h"

//
//  ESBoundUserDefaults.m
//  es_ios_utils
//
//  Created by Peter DeWeese on 3/4/11.
//  Copyright 2011 Eye Street Research, LLC. All rights reserved.
//
@implementation ESBoundUserDefaults


-(id)dynamicGet:(NSString*)methodName
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:methodName];
}

-(void)dynamicSet:(NSString*)methodName object:(id)o
{
    [[NSUserDefaults standardUserDefaults] setObject:o forKey:methodName];
}

@end
