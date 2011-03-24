//
//  ESDynamicMethodResolver.h
//  es_ios_utils
//
//  Use @dynamic to bind ivars to dynamic funcationality, such as in ESBoundUserDefaults.
//
//  Created by Peter DeWeese on 3/4/11.
//  Copyright 2011 Eye Street Research, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ESDynamicMethodResolver : NSObject{

}

-(id)dynamicGet:(NSString*)methodName;
-(void)dynamicSet:(NSString*)methodName object:(id)o;

@end
