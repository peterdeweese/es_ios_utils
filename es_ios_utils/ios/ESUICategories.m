#if IS_IOS

#import "ESUICategories.h"
#import "ESUtils.h"
#import <QuartzCore/QuartzCore.h>

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

-(CGSize)keyboardSizeRotatedForView:(UIView*)view
{
    CGSize s = self.keyboardSize;
    return [view.window convertRect:$rect(0,0,s.width,s.height) toView:view].size;
}

@end


@implementation UIActionSheet(ESUtils)

-(void)cancel:(BOOL)animated
{
    [self dismissWithClickedButtonIndex:self.cancelButtonIndex animated:animated];
}

-(void)cancel
{
    [self cancel:YES];
}

@end


@implementation UIAlertView(ESUtils)

+(UIAlertView*)createAndShowWithTitle:(NSString*)title message:(NSString*)message buttonTitle:(NSString*)button
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                     message:message
                                                    delegate:nil
                                           cancelButtonTitle:nil
                                           otherButtonTitles:button, nil];
    [alert show];
    return alert;
}

@end


@implementation UIBarButtonItem(ESUtils)

+(UIBarButtonItem*)barButtonItemWithCustomView:(UIView*)v
{
    return [[UIBarButtonItem alloc] initWithCustomView:v];
}

+(UIBarButtonItem*)barButtonItemWithTitle:(NSString*)title style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action
{
    return [[UIBarButtonItem alloc] initWithTitle:title style:style target:target action:action];
}

+(UIBarButtonItem*)barButtonItemWithBarButtonSystemItem:(UIBarButtonSystemItem)item target:(id)target action:(SEL)action
{
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:item target:target action:action];
}

@end


@implementation UIButton(ESUtils)

-(NSString*)title { return [self titleForState:UIControlStateNormal]; }
-(void)setTitle:(NSString *)title
{
    [self setTitle:title forState:UIControlStateNormal];
}

@end



@implementation UIDevice(ESUtils)

+(BOOL)isPad
{
    return UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad;
}

+(BOOL)isPhone
{
    return UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone;
}

+(BOOL)isInLandscape
{
    return UIDeviceOrientationIsLandscape(UIApplication.sharedApplication.statusBarOrientation);
}

+(BOOL)isInPortrait
{
    return UIDeviceOrientationIsPortrait(UIDevice.currentDevice.orientation);
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


@implementation UINavigationController(ESUtils)

+(UINavigationController*)navigationControllerWithRootViewController:(UIViewController*)vc
{
    return [[UINavigationController alloc] initWithRootViewController:vc];
}

-(void)popViewController { [self popViewControllerAnimated:YES]; }

@end


@implementation UINavigationItem(ESUtils)

-(void)configureWithTitle:(NSString*)title leftItem:(UIBarButtonItem*)left rightItem:(UIBarButtonItem*)right
{
    self.title = title;
    self.leftBarButtonItem = left;
    self.rightBarButtonItem = right;
}

-(void)setRightBarButtonItems:(NSArray*)items
{
    self.rightBarButtonItem = [UIBarButtonItem barButtonItemWithCustomView:[UIToolbar toolbarWithItems:items]];
}

@end


@implementation UIPickerView(ESUtils)

+(UIPickerView*)pickerView
{
    return [[UIPickerView alloc] init];
}

+(UIPickerView*)pickerViewWithDelegate:(id<UIPickerViewDelegate>)delegate dataSource:(id<UIPickerViewDataSource>)dataSource
{
    return [[self alloc] initWithDelegate:delegate dataSource:dataSource];
}

+(UIPickerView*)pickerViewWithDelegateAndDataSource:(id<UIPickerViewDataSource, UIPickerViewDelegate>)delegate
{
    return [self pickerViewWithDelegate:delegate dataSource:delegate];
}

-(id)initWithDelegate:(id<UIPickerViewDelegate>)delegate dataSource:(id<UIPickerViewDataSource>)dataSource
{
    if(self = [super init])
    {
        self.delegate = delegate;
        self.dataSource = dataSource;
    }
    return self;
}

-(id)initWithDelegateAndDataSource:(id<UIPickerViewDataSource, UIPickerViewDelegate>)delegate
{
    return self = [self initWithDelegate:delegate dataSource:delegate];
}

@end


@implementation UIPopoverController(ESUtils)

+(UIPopoverController*)popoverControllerWithContentViewController:(UIViewController*)viewController
{
    return [[UIPopoverController alloc] initWithContentViewController:viewController];
}

+(UIPopoverController*)popoverControllerWithNavigationAndContentViewController:(UIViewController*)viewController
{
    UINavigationController *nav = [UINavigationController navigationControllerWithRootViewController:viewController];
    return [UIPopoverController popoverControllerWithContentViewController:nav];
}

-(void)pointToBarButtonItem:(UIBarButtonItem*)b
{
    [self presentPopoverFromBarButtonItem:b permittedArrowDirections:self.popoverArrowDirection animated:YES];
}

-(void)dismiss { [self dismissPopoverAnimated:YES]; }

@end


@implementation UITableViewCell(ESUtils)

+(UITableViewCell*)cellWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier
{
    return [[UITableViewCell alloc] initWithStyle:style reuseIdentifier:identifier];
}

@end


@implementation UIToolbar(ESUtils)

+(UIToolbar*)toolbarWithItems:(NSArray*)items
{    
    UIToolbar* bar = [[UIToolbar alloc] initWithFrame:$rect(0, 0, 0, 44.)];
    bar.items = items;
    
    UIView* v = bar.subviews.lastObject;
    bar.width = v.x + v.width;
    
    return bar;
}

-(void)removeItem:(UIBarButtonItem*)i
{
    self.items = [self.items arrayByRemovingObject:i];
}

-(void)removeLastItem
{
    self.items = [self.items arrayByRemovingLastObject];
}

-(void)addItem:(UIBarButtonItem*)i
{
    self.items = [self.items arrayByAddingObject:i];
}

@end


@implementation UIView(ESUtils)

+(UIView*)viewWithFrame:(CGRect)frame
{
    return [[UIView alloc] initWithFrame:frame];
}

+(void)animate:(void(^)(void))animations
{
    [self animateWithDuration:0.5 animations:animations];
}

-(float)width { return self.frame.size.width; }
-(void)setWidth:(float)width
{
    self.frame = $rect(self.x, self.y, width, self.height);
}

-(float)height { return self.frame.size.height; }
-(void)setHeight:(float)height
{
    self.frame = $rect(self.x, self.y, self.width, height);
}

-(float)x { return self.frame.origin.x; }
-(void)setX:(float)x
{
    self.frame = $rect(x, self.y, self.width, self.height);
}

-(float)y { return self.frame.origin.y; }
-(void)setY:(float)y
{
    self.frame = $rect(self.x, y, self.width, self.height);
}

-(float)bottomY { return self.y + self.height; }

-(CGSize)size { return self.frame.size; }
-(void)setSize:(CGSize)size
{
    self.frame = $rect(self.x, self.y, size.width, size.height);
}

-(CGPoint)origin { return self.frame.origin; }
-(void)setOrigin:(CGPoint)origin
{
    self.frame = $rect(origin.x, origin.y, self.width, self.height);
}

-(UIColor*)borderColor { return [UIColor colorWithCGColor:self.layer.borderColor]; }
-(void)setBorderColor:(UIColor*)c { self.layer.borderColor = c.CGColor; }

-(float)borderWidth { return self.layer.borderWidth; }
-(void)setBorderWidth:(float)w { self.layer.borderWidth = w; }

-(float)cornerRadius { return self.layer.cornerRadius; }
-(void)setCornerRadius:(float)r { self.layer.cornerRadius = r; }

-(BOOL)containsSubviewWithKindOfClass:(__unsafe_unretained Class)c
{
    for(UIView* v in self.subviews)
        if([v isKindOfClass:c] || [v containsSubviewWithKindOfClass:c])
            return YES;
    return NO;
}

-(void)replaceInSuperviewWith:(UIView*)v
{
    v.autoresizingMask = self.autoresizingMask;
    v.frame = self.frame;
    [self.superview addSubview:v];
    [self removeFromSuperview];
}

-(BOOL)isInPopover
{
    UIView *v = self;        
    for (;v.superview != nil; v=v.superview)
        if ([v.className hasSuffix:@"UIPopoverView"])
            return YES;
    return NO;
}

-(UIResponder*)findFirstResponder
{
    if (self.isFirstResponder)
        return self;
    
    UIResponder* result;
    for (UIView* v in self.subviews)
        if((result = v.findFirstResponder))
            return result;
    
    return nil;
}

//Only works when view has a superview and a window, as orientation is also considered
-(void)centerInSuperview
{
    if(self.superview && self.window)
    {
        CGPoint center = [CG centerOfSize:self.superview.size];
        //TODO: This should be handled with a translate, as this will only work in certain circumstances as is.
        if(UIDevice.isInLandscape)
            center = CGPointMake(center.y, center.x);
        self.center = center;
    }
}

-(void)resizeSuperviewAndSetHeight:(float)dynamicHeight animated:(BOOL)animate
{
    __block CGRect oldFrame = self.frame;
    self.height = dynamicHeight;
    
    // Grow or shrink parent.  Find all sibling elements below this element and change their y.
    if(oldFrame.size.height != self.height)
    {
        __block float diff = self.height - oldFrame.size.height;
        __block typeof(self) bself = self;
        
        void(^resizeBlock)(void) = ^{
            if([bself.superview respondsToSelector:@selector(shouldResizeDynamically)])
            {
                [bself.superview resizeSuperviewAndSetHeight:bself.superview.height + diff];
            }
            else if([bself.superview isKindOfClass:[UIScrollView class]])
            {
                CGSize content = ((UIScrollView *)bself.superview).contentSize;
                content.height += diff;
                ((UIScrollView *)bself.superview).contentSize = content;
            }
            else
            {
                bself.superview.height += diff;
            }
            
            for(UIView *v in bself.superview.subviews)
                if(v.y >= bself.y + oldFrame.size.height)
                    v.y = v.y + diff;
        };
        
        if(animate)
        {
            [UIView animateWithDuration:0.5 animations:resizeBlock];
        }
        else
        {
            resizeBlock();
        }
    }
    
    //On the device these values are somehow garbled.  It works without this section on the simulator.
    self.width = oldFrame.size.width;
    self.origin = oldFrame.origin;
}

-(void)resizeSuperviewAndSetHeight:(float)dynamicHeight
{
    [self resizeSuperviewAndSetHeight:dynamicHeight animated:NO];
}


@end


@implementation UIViewController(ESUtils)

-(NSArray*)loadNibNamed:(NSString*)nib
{
    return [NSBundle.mainBundle loadNibNamed:nib owner:self options:nil];
}

-(UIPopoverController*)$popoverController
{
    return [self valueForKey:@"popoverController"];
}

-(UIPopoverController*)popoverIn:(UIViewController*)vc fromRect:(CGRect)r delegate:(id<UIPopoverControllerDelegate>)delegate
{
    UIPopoverController* pc = [UIPopoverController popoverControllerWithNavigationAndContentViewController:vc];
    pc.delegate = delegate;
    [pc presentPopoverFromRect:r inView:vc.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    return pc;
}

-(UIPopoverController*)popoverFromBarButtonItem:(UIBarButtonItem*)button delegate:(id<UIPopoverControllerDelegate>)delegate
{
    UIPopoverController* pc = [UIPopoverController popoverControllerWithNavigationAndContentViewController:self];
    pc.delegate = delegate;
    [pc presentPopoverFromBarButtonItem:button permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    return pc;
}

-(UIPopoverController*)popoverFromBarButtonItem:(UIBarButtonItem *)button
{
    return [self popoverFromBarButtonItem:button delegate:nil];
}

-(void)popOrDismiss
{
    if(self.view.isInPopover)
        [self.$popoverController dismiss];
    else
        [self.navigationController popViewController];
}

-(void)forcePortrait
{
    //force portrait orientation without private methods.
    UIViewController *c = [[UIViewController alloc]init];
    [self presentModalViewController:c animated:NO];
    [self dismissModalViewControllerAnimated:NO];
}

-(void)forcePopoverSize
{
    CGSize currentSetSizeForPopover = self.contentSizeForViewInPopover;
    CGSize fakeMomentarySize = CGSizeMake(currentSetSizeForPopover.width - 1.0f, currentSetSizeForPopover.height - 1.0f);
    self.contentSizeForViewInPopover = fakeMomentarySize;
    self.contentSizeForViewInPopover = currentSetSizeForPopover;
}

-(UIWindow*)window { return self.view.window; }

-(void)observeKeyboardEvents
{
    //REFACTOR: use selector creation and iteration
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

-(void)stopObservingKeyboardEvents
{
    for(NSString* n in $array(UIKeyboardWillShowNotification, UIKeyboardDidShowNotification, UIKeyboardWillHideNotification, UIKeyboardDidHideNotification))
        [[NSNotificationCenter defaultCenter] removeObserver:self name:n object:nil];
}

-(void)keyboardWillShow:(NSNotification*)n {}
-(void)keyboardDidShow: (NSNotification*)n {}
-(void)keyboardWillHide:(NSNotification*)n {}
-(void)keyboardDidHide: (NSNotification*)n {}

@end


@implementation UIScrollView(ESUtils)

-(void)scrollToTop
{
    [self setContentOffset:CGPointZero animated:YES];
}

//TODO: a useful alternative may be to shrink the scrollview when the keyboard comes up.
-(void)scrollViewToVisibleForKeyboard:(UIView*)v { [self scrollViewToVisibleForKeyboard:v animated:YES]; }
-(void)scrollViewToVisibleForKeyboard:(UIView*)v animated:(BOOL)animated
{
    CGRect aRect = self.frame;
    aRect.size.height -= 352; //TODO: get keyboard height programmatically
    
    CGPoint originInScrollView = [self convertPoint:v.bounds.origin fromView:v];
    CGPoint translatedOrigin = CGPointMake(originInScrollView.x, originInScrollView.y - self.contentOffset.y + v.height);
    if (!CGRectContainsPoint(aRect, translatedOrigin) )
    {
        int padding = 20;
        CGPoint scrollPoint = CGPointMake(0.0, MAX(0, originInScrollView.y - aRect.size.height + v.height + padding));
        [self setContentOffset:scrollPoint animated:YES];
    }
}

-(void)scrollFirstResponderToVisibleForKeyboard
{
    [self scrollViewToVisibleForKeyboard:(UIView*)self.findFirstResponder];
}

@end


@implementation UITextField(ESUtils)

+(UITextField*)textFieldWithFrame:(CGRect)frame
{
    return [[UITextField alloc] initWithFrame:frame];
}

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


@implementation UITextView(ESUtils)

-(void)styleAsRoundedRect
{
    self.borderColor = UIColor.lightGrayColor;
    self.borderWidth = 1.;
    self.cornerRadius = 4.5;
    self.backgroundColor = UIColor.whiteColor;
    self.clipsToBounds = YES;
}

@end


@implementation UITableView(ESUtils)

+(UITableView*)tableViewWithFrame:(CGRect)bounds style:(UITableViewStyle)style
{
    return [[UITableView alloc] initWithFrame:bounds style:style];
}

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

-(UITableViewCell*)cellForSelectedRow
{
    return [self cellForRowAtIndexPath: self.indexPathForSelectedRow];
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

-(void)reloadRowAtIndexPath:(NSIndexPath*)ip withRowAnimation:(UITableViewRowAnimation)a
{
    [self reloadRowsAtIndexPaths:$array(ip) withRowAnimation:a];
}

-(void)reloadRowAtIndexPath:(NSIndexPath*)ip
{
    [self reloadRowAtIndexPath:ip withRowAnimation:UITableViewRowAnimationAutomatic];
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

-(void)deselectAll
{
    [self deselectRowAtIndexPath:self.indexPathForSelectedRow animated:YES];
}

-(void)update:(ESEmptyBlock)update
{
    [self beginUpdates];
    if(update) update();
    [self endUpdates];
}

@end


@implementation UIImage(ESUtils)

+(UIImage*)imageFromLayer:(CALayer*)layer
{
    UIGraphicsBeginImageContextWithOptions(layer.frame.size, layer.opaque, 0.0);

    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return outputImage;
}

@end


@implementation UIImageView(ESUtils)

+(UIImageView*)imageViewWithImage:(UIImage*)i
{
    return [[UIImageView alloc] initWithImage:i];
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

#endif //IS_IOS