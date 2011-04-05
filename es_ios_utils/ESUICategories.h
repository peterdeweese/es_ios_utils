//
//  ESUICategories.h
//  es_ios_utils
//
//  Created by Peter DeWeese on 3/16/11.
//  Copyright 2011 Eye Street Research, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

// The class is here to force the linker to load categories
@interface ESUICategories : NSObject
{    
}

@end

typedef void(^ESUICellBlock)(UITableViewCell*);

@interface NSNotification(ESUtils)
    //For UIKeyboard* notifications, otherwise an exception is raised.
    //Use convertRect:fromView: or convertRect:fromWindow: to rotate to current orientation
    @property(readonly) CGSize keyboardSize;
@end


@interface UIAlertView(ESUtils)
    +(UIAlertView*)createAndShowWithTitle:(NSString*)title message:(NSString*)message buttonTitle:(NSString*)button;
@end


@interface UILabel(ESUtils)
    +(UILabel*)labelWithText:(NSString*)text;
    +(UILabel*)labelWithBoldText:(NSString*)text;
@end


@interface UIView(ESUtils)
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

@interface UITableView(ESUtils)
@property(readonly) BOOL isEmpty;
@property(readonly) BOOL isNotEmpty;
    -(UITableViewCell*)cellForRow:(int)r inSection:(int)s;
    -(UITableViewCell*)cellForRow:(int)r;
    -(void)doForEachCellInSection:(int)s action:(ESUICellBlock)action;
    -(void)insertRowAtIndexPath:(NSIndexPath*)indexPath withRowAnimation:(UITableViewRowAnimation)animation;
    -(void)insertRow:(int)r inSection:(int)s withRowAnimation:(UITableViewRowAnimation)animation;
    -(void)insertRow:(int)r withRowAnimation:(UITableViewRowAnimation)animation;
    -(void)scrollToRow:(int)r inSection:(int)s atScrollPosition:(UITableViewScrollPosition)p animated:(BOOL)a;
    -(void)scrollToRow:(int)r atScrollPosition:(UITableViewScrollPosition)p animated:(BOOL)a;
    -(void)deleteRowAtIndexPath:(NSIndexPath*)i withRowAnimation:(UITableViewRowAnimation)a;
    -(void)deleteRow:(int)r inSection:(int)s withRowAnimation:(UITableViewRowAnimation)a;
    -(void)deleteRow:(int)r withRowAnimation:(UITableViewRowAnimation)a;
@end