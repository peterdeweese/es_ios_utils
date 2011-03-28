//
//  ESUICategories.h
//  es_ios_utils
//
//  Created by Peter DeWeese on 3/16/11.
//  Copyright 2011 Eye Street Research, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

// The class is here to force the linker to load categories
@interface ESUICategories : NSObject
{    
}

@end

typedef void(^ESUICellBlock)(UITableViewCell*);

@interface UIApplication(ESUtils)
    +(NSManagedObjectContext*)managedObjectContext;
@end


@interface UIView (ESUtils)
    // These sizing convenience methods manipulate the frame.
    @property(assign) float width;
    @property(assign) float height;
    @property(assign) float x;
    @property(assign) float y;
    @property(assign) CGSize size;
@end

@interface UITextField (ESUtils)
    // Passed Apple's review.
    @property(assign) UIColor *placeholderColor;
@end

@interface UITableView (ESUtils)
    @property(readonly) BOOL empty;
    - (UITableViewCell*)cellForRow:(int)r inSection:(int)s;
    - (UITableViewCell*)cellForRow:(int)r;
    - (void)doForEachCellInSection:(int)s action:(ESUICellBlock)action;
@end