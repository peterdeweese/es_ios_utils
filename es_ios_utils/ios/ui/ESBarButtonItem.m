#if IS_IOS

#import "ESBarButtonItem.h"
#import <objc/message.h>

@interface ESBarButtonItem()
@property(nonatomic, strong) UIPopoverController* popoverController;
@property(nonatomic, strong) id  userTarget;
@property(nonatomic, assign) SEL userAction;
@end


@implementation ESBarButtonItem

+(ESBarButtonItem*)barButtonItemWithTitle:(NSString*)title action:(void(^)(void))blockAction

{
    ESBarButtonItem* result = [[ESBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:nil action:nil];
    result.blockAction = blockAction;
    return result;
}

+(ESBarButtonItem*)barButtonItemToEditTable:(UITableView*)table
{
    __unsafe_unretained ESBarButtonItem* item;
    __unsafe_unretained UITableView* t = table;
    item = [ESBarButtonItem barButtonItemWithTitle:@"Edit" action:^{
        [t setEditing:!t.editing animated:YES];
        item.title = t.editing ? @"Done" : @"Edit";
        item.style = t.editing ? UIBarButtonItemStyleDone : UIBarButtonItemStylePlain;
    }];
    return item;
}

@synthesize blockAction, createViewControllerForPopover, viewControllerForPopover, userTarget, userAction;
@synthesize /*private*/ popoverController;

//It's a bit of a hack, but target and action will not return what they are set to. This is how we coopt the press event while still allowing a user to set the target and action.
-(id)target { return self; }
-(void)setTarget:(id)new { self.userTarget = new; }
-(SEL)action { return @selector(pressed:); }
-(void)setAction:(SEL)new { self.userAction = new; }

-(void)pressed:(id)sender
{
    if(popoverController)
        [self dismissPopover];
    else
    {
        //performSelector gets an ARC warning
        if(userTarget && userAction && [userTarget respondsToSelector:userAction])
            objc_msgSend(userTarget, userAction);
        
        [self presentPopover];
        
        if(blockAction) blockAction();
    }
}

-(void)clearActions
{
  self.blockAction                    = nil;
  self.viewControllerForPopover       = nil;
  self.popoverController.delegate     = nil;
  self.popoverController              = nil;
  self.userTarget                     = nil;
  self.userAction                     = nil;
  self.createViewControllerForPopover = nil;
}

#pragma mark - Popovers

-(void)presentPopover
{
    if(!self.popoverController)
    {
        UIViewController* vc = viewControllerForPopover ?: (createViewControllerForPopover!=nil ? createViewControllerForPopover() : nil);
        if(vc)
        {
            self.popoverController = [UIPopoverController popoverControllerWithNavigationAndContentViewController:vc];
            self.popoverController.delegate = self;
            [self.popoverController presentPopoverFromBarButtonItem:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    }
}

-(BOOL)isPopoverVisible
{
  return self.popoverController.isPopoverVisible;
}

-(void)dismissPopover
{
    [self.popoverController dismissPopoverAnimated:YES];
    self.popoverController.delegate = nil;
    self.popoverController = nil;
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController*)pc
{
    self.popoverController.delegate = nil;
    self.popoverController = nil;
}

@end

#endif /*IS_IOS*/