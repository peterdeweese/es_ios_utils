//
//  ESViewDataMapper.h
//  cap
//
//  Created by Peter DeWeese on 3/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ESViewDataMapper : NSObject {
    @private
        NSMutableArray *maps;
}

/*
 * Having seperate save and load methods causes dual configuration and potential differences, so this class allows for the mapping to be configured once.
 * Supports UITextField and UITextView.  Object and keyPath together must refer to an NSString.
 */
-(void)addView:(UIView*)view object:(id)object keyPath:(NSString*)keyPath;

-(void)updateViews;

-(void)updateObjects;

@end
