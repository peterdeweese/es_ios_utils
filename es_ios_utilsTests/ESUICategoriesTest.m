//
//  ESUICategoriesTest.m
//  es_ios_utils
//
//  Created by Peter DeWeese on 3/16/11.
//  Copyright 2011 Eye Street Research, LLC. All rights reserved.
//

#import "ESUICategoriesTest.h"

@implementation ESUICategoriesTest

-(void)testUIViewCategory
{
    CGRect rect = CGRectMake(11,13,17,19);
    
    UIView *view = [[UIView alloc] initWithFrame:rect];
    STAssertTrue(rect.origin.x==view.x && rect.origin.y==view.y && rect.size.width==view.width && rect.size.height==view.height, @"Frame should match input rect.");
}

-(void)testUITextFieldCategory
{
    //Not much to test for, except that the getter and setter do not throw errors.
    /*
    FIXME: requires application test
    UITextField *textField = [[UITextField alloc] init];
    
    UIColor *color = UIColor.redColor;
    STAssertNoThrow(textField.placeholderColor = color, @"Placeholder setter should not cause an error.");
    STAssertEqualObjects(color, textField.placeholderColor, @"Placeholder color should be red.");
    */
}

//FIXME: Requires application test
/*
@interface UITableView (ESUtils)
@property(readonly) BOOL empty;
- (UITableViewCell*)cellForRow:(int)r inSection:(int)s;
- (UITableViewCell*)cellForRow:(int)r;
- (void)doForEachCellInSection:(int)s action:(void(^)(UITableViewCell *c))action;
@end
*/
@end
