#import "ESUICategories.h"
#import "ESUtils.h"

@implementation NSNotification(ESUtils)

-(CGSize)keyboardSize
{
    NSString *key;
    
    if(self.name == UIKeyboardDidShowNotification || self.name == UIKeyboardWillShowNotification)
        key = UIKeyboardFrameEndUserInfoKey;
    else if(self.name == UIKeyboardDidHideNotification || self.name == UIKeyboardWillHideNotification)
        key = UIKeyboardFrameBeginUserInfoKey;
    else
        [NSException raise:NSInternalInconsistencyException format:@"NSNotification(ESUtils).keyboardSize may only be used with keyboard events."];
    
    return [[self.userInfo valueForKey:key] CGRectValue].size;
}

@end


@implementation UIAlertView(ESUtils)

+(UIAlertView*)createAndShowWithTitle:(NSString*)title message:(NSString*)message buttonTitle:(NSString*)button
{
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:title
                                                     message:message
                                                    delegate:nil
                                           cancelButtonTitle:nil
                                           otherButtonTitles:button, nil] autorelease];
    [alert show];
    return alert;
}

@end


@implementation UIBarButtonItem(ESUtils)

+(UIBarButtonItem*)barButtonItemWithCustomView:(UIView*)v
{
    return [[[UIBarButtonItem alloc] initWithCustomView:v] autorelease];
}

+(UIBarButtonItem*)barButtonItemWithTitle:(NSString*)title style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action
{
    return [[[UIBarButtonItem alloc] initWithTitle:title style:style target:target action:action] autorelease];
}

+(UIBarButtonItem*)barButtonItemWithBarButtonSystemItem:(UIBarButtonSystemItem)item target:(id)target action:(SEL)action
{
    return [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:item target:target action:action] autorelease];
}

@end


@implementation UIDevice(ESUtils)

+(BOOL)isPad
{
    return [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad;
}

+(BOOL)isPhone
{
    return [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone;
}

@end


@implementation UILabel(ESUtils)

+(UILabel*)labelWithText:(NSString*)text
{
    UILabel *l = [[UILabel alloc] init];
    l.text = text;
    [l sizeToFit];
    return l;
}

+(UILabel*)labelWithBoldText:(NSString*)text
{
    UILabel *l = [self labelWithText:text];
    l.font = [UIFont boldSystemFontOfSize:l.font.pointSize];
    [l sizeToFit];
    return l;
}

@end


@implementation UINavigationItem(ESUtils)

-(void)configureWithTitle:(NSString*)title leftItem:(UIBarButtonItem*)left rightItem:(UIBarButtonItem*)right
{
    self.title = title;
    self.leftBarButtonItem = left;
    self.rightBarButtonItem = right;
}

@end


@implementation UIPopoverController(ESUtils)

+(UIPopoverController*)popoverControllerWithContentViewController:(UIViewController*)viewController
{
    return [[[UIPopoverController alloc] initWithContentViewController:viewController] autorelease];
}

@end


@implementation UITableViewCell(ESUtils)

+(UITableViewCell*)cellWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier
{
    return [[[UITableViewCell alloc] initWithStyle:style reuseIdentifier:identifier] autorelease];
}

@end


@implementation UIView(ESUtils)

- (float)width { return self.frame.size.width; }
- (void)setWidth:(float)width
{
    self.frame = CGRectMake(self.x, self.y, width, self.height);

}

- (float)height { return self.frame.size.height; }
- (void)setHeight:(float)height
{
    self.frame = CGRectMake(self.x, self.y, self.width, height);
}

- (float)x { return self.frame.origin.x; }
- (void)setX:(float)x
{
    self.frame = CGRectMake(x, self.y, self.width, self.height);
}

- (float)y { return self.frame.origin.y; }
- (void)setY:(float)y
{
    self.frame = CGRectMake(self.x, y, self.width, self.height);
}

- (CGSize)size { return self.frame.size; }
- (void)setSize:(CGSize)size
{
    self.frame = CGRectMake(self.x, self.y, size.width, size.height);
}

- (CGPoint)origin { return self.frame.origin; }
- (void)setOrigin:(CGPoint)origin
{
    self.frame = CGRectMake(origin.x, origin.y, self.width, self.height);
}

@end


@implementation UIViewController(ESUtils)

-(UIPopoverController*)$popoverController
{
    return [self valueForKey:@"popoverController"];
}

-(void)pushOrPopoverInViewController:(UIViewController*)parent fromBarButtonItem:(UIBarButtonItem*)button
{
    if(UIDevice.isPad)
    {
        UINavigationController *nav = [[[UINavigationController alloc] initWithRootViewController:self] autorelease];

        UIPopoverController *pc = [[UIPopoverController alloc] initWithContentViewController:nav];
        // To set the size of the popover view, set the property self.contentSizeForViewInPopover before
        // calling this.  A good place would be in [self viewDidLoad] 
        [pc presentPopoverFromBarButtonItem:button
                   permittedArrowDirections:UIPopoverArrowDirectionAny
                                   animated:YES];
        if(self.modalInPopover)
            pc.passthroughViews = NSArray.array;

    }
    else
        [parent.navigationController pushViewController:self animated:YES];
}

-(void)pushOrPopoverInViewController:(UIViewController*)parent from:(CGRect)r
{
    if(UIDevice.isPad)
    {
        [self.view layoutIfNeeded];
        UINavigationController *nav = [[[UINavigationController alloc] initWithRootViewController:self] autorelease];
        UIPopoverController *pc = [[UIPopoverController alloc] initWithContentViewController:nav];
        // To set the size of the popover view, set the property self.contentSizeForViewInPopover before
        // calling this.  A good place would be in [self viewDidLoad] 
        [pc presentPopoverFromRect:r
                            inView:parent.view
          permittedArrowDirections:UIPopoverArrowDirectionAny
                          animated:YES];
    }
    else
        [parent.navigationController pushViewController:self animated:YES];
}

-(void)popOrDismiss
{
    if(UIDevice.isPad)
        [self.$popoverController dismissPopoverAnimated:YES];
    else
        [self.navigationController popViewControllerAnimated:YES];
}

-(void)forcePortrait
{
    //force portrait orientation without private methods.
    UIViewController *c = [[UIViewController alloc]init];
    [self presentModalViewController:c animated:NO];
    [self dismissModalViewControllerAnimated:NO];
    [c release];
}

@end


@implementation UITextField(ESUtils)

// Uses a private ivar, but Apple reviews allow it in Veporter and other apps:
//     http://stackoverflow.com/questions/1340224/iphone-uitextfield-change-placeholder-text-color
- (UIColor*)placeholderColor
{
    return [self valueForKey:@"_placeholderLabel.textColor"];
}

- (void)setPlaceholderColor:(UIColor*)color
{
    [self setValue:color forKeyPath:@"_placeholderLabel.textColor"];
}

-(UIFont*)placeholderFont
{
    return [self valueForKey:@"_placeholderLabel.font"];
}

-(void)setPlaceholderFont:(UIFont*)font
{
    [self setValue:font forKeyPath:@"_placeholderLabel.font"];
}

@end


@implementation UITableView(ESUtils)

// Returns YES if there are no rows in any section.
-(BOOL)isEmpty
{    
    for(int s=0; s<self.numberOfSections; s++)
        if([self numberOfRowsInSection:s] > 0)
            return NO;
    
    return YES;
}

-(BOOL)isNotEmpty
{    
    for(int s=0; s<self.numberOfSections; s++)
        if([self numberOfRowsInSection:s] > 0)
            return YES;
    
    return NO;
}

-(UITableViewCell*)cellForRow:(int)r inSection:(int)s
{
    return [self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:r inSection:s]];
}

// Defaults to the first section
-(UITableViewCell*)cellForRow:(int)r
{
    return [self cellForRow:r inSection:0];
}

-(void)doForEachCellInSection:(int)s action:(ESUICellBlock)action
{
    for(int r=0; r<[self numberOfRowsInSection:s]; r++)
        action([self cellForRow:r inSection:s]);
}

-(void)doForEachIndexPathInSection:(int)s action:(ESUIIndexPathBlock)action
{
    for(int r=0; r<[self numberOfRowsInSection:s]; r++)
        action([NSIndexPath indexPathForRow:r inSection:s]);
}

-(void)insertRowAtIndexPath:(NSIndexPath*)indexPath withRowAnimation:(UITableViewRowAnimation)animation
{
    [self insertRowsAtIndexPaths:$array(indexPath) withRowAnimation:animation];
}

-(void)insertRow:(int)r inSection:(int)s withRowAnimation:(UITableViewRowAnimation)a
{
    [self insertRowAtIndexPath:[NSIndexPath indexPathForRow:r inSection:s] withRowAnimation:a];
}

-(void)insertRow:(int)r withRowAnimation:(UITableViewRowAnimation)a
{
    [self insertRow:r inSection:0 withRowAnimation:a];
}

-(void)insertSection:(int)s withRowAnimation:(UITableViewRowAnimation)a
{
    [self insertSections:[NSIndexSet indexSetWithIndex:s] withRowAnimation:a];
}

-(void)scrollToRow:(int)r inSection:(int)s atScrollPosition:(UITableViewScrollPosition)p animated:(BOOL)a
{
    [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:r inSection:s] atScrollPosition:p animated:a];
}

-(void)scrollToRow:(int)r atScrollPosition:(UITableViewScrollPosition)p animated:(BOOL)a
{
    [self scrollToRow:r inSection:0 atScrollPosition:p animated:a];
}

-(void)deleteRowAtIndexPath:(NSIndexPath*)i withRowAnimation:(UITableViewRowAnimation)a
{
    [self deleteRowsAtIndexPaths:$array(i) withRowAnimation:a];
}

-(void)deleteRow:(int)r inSection:(int)s withRowAnimation:(UITableViewRowAnimation)a
{
    [self deleteRowAtIndexPath:[NSIndexPath indexPathForRow:r inSection:s] withRowAnimation:a];
}

-(void)deleteRow:(int)r withRowAnimation:(UITableViewRowAnimation)a
{
    [self deleteRow:r inSection:0 withRowAnimation:a];
}

-(void)deleteSection:(int)s withRowAnimation:(UITableViewRowAnimation)a
{
    [self deleteSections:[NSIndexSet indexSetWithIndex:s] withRowAnimation:a];
}

@end


@implementation UIWindow(ESUtils)

// credit: stackoverflow user aegzorz
// http://stackoverflow.com/questions/6035068/should-not-display-the-alertview-if-already-another-alertview-is-displaying-in-ip
-(BOOL)isDisplayingAlert
{
    for(UIView* subview in self.subviews)
        if([subview isKindOfClass:UIAlertView.class])
            return YES;
    
    return NO;
}

@end