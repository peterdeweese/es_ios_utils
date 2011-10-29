#if IS_IOS

#import "ESBarButtonItem.h"

@interface ESBarButtonItem()
@property(nonatomic, retain) UIPopoverController* popoverController;
@property(nonatomic, retain) id  userTarget;
@property(nonatomic, assign) SEL userAction;
@end


@implementation ESBarButtonItem

+(ESBarButtonItem*)barButtonItemWithTitle:(NSString*)title action:(void(^)(void))blockAction

{
    ESBarButtonItem* result = [[[ESBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
    result.blockAction = blockAction;
    return result;
}

+(ESBarButtonItem*)barButtonItemToEditTable:(__block UITableView*)t
{
    __block ESBarButtonItem* item;
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
        if(userTarget && userAction && [userTarget respondsToSelector:userAction])
            [userTarget performSelector:userAction];
        
        [self presentPopover];
        
        if(blockAction) blockAction();
    }
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


#pragma mark - Cleanup

-(void)dealloc
{
    self.blockAction                    = nil;
    self.viewControllerForPopover       = nil;
    self.popoverController.delegate     = nil;
    self.popoverController              = nil;
    self.userTarget                     = nil;
    self.userAction                     = nil;
    self.createViewControllerForPopover = nil;
    [super dealloc];
}

@end

#endif /*IS_IOS*/