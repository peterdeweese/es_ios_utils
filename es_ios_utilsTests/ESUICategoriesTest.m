#import "ESUtils.h"
#import "ESUICategoriesTest.h"
#import "appDelegate.h"
#import "TestViewController.h"

@implementation ESUICategoriesTest

-(void)testUILabelCategory
{
    UILabel *label = [UILabel labelWithText:@"labelWithText"];
    STAssertNotNil(label, @"Label not created.");
    //FIXME: Add as subview to see results
    
    UILabel *boldLabel = [UILabel labelWithBoldText:@"labelWithBoldText"];
    STAssertNotNil(boldLabel, @"Bold label not created.");
    //FIXME: Add as subview to see results
}

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

-(void)testUIWindowCategory
{
    STAssertFalse(ESApplicationDelegate.instance.isDisplayingAlert, nil);
}

@end
