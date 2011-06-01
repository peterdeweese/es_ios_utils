//
//  ESUtils.h
//  es_ios_utils
//
//  Created by Peter DeWeese on 3/16/11.
//  Copyright 2011 Eye Street Research, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ESNSCategories.h"
#import "ESUICategories.h"

#define $array(objs...) [NSArray arrayWithObjects: objs, nil] 
#define $set(objs...) [NSSet setWithObjects: objs, nil] 
#define $format(format, objs...) [NSString stringWithFormat: format, objs]

#define $must_override [NSException raise:NSInternalInconsistencyException format:@"You must override %@", NSStringFromSelector(_cmd)];

@interface ESUtils : NSObject
{    
}

@end
