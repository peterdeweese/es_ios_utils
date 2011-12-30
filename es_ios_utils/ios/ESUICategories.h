#if IS_IOS

#import <UIKit/UIKit.h>

// The class is here to force the linker to load categories
@interface ESUICategories : NSObject
@end

typedef void(^ESUICellBlock)(UITableViewCell*);
typedef void(^ESUIIndexPathBlock)(NSIndexPath*);

@interface NSNotification(ESUtils)
  //For UIKeyboard* notifications, otherwise an exception is raised.
  @property(readonly) CGSize keyboardSize;
  -(CGSize)keyboardSizeRotatedForView:(UIView*)view;
@end


@interface UIActionSheet(ESUtils)
  -(void)cancel:(BOOL)animated;
  -(void)cancel;
@end


@interface UIAlertView(ESUtils)
    +(UIAlertView*)createAndShowWithTitle:(NSString*)title message:(NSString*)message buttonTitle:(NSString*)button;
@end


@interface UIBarButtonItem(ESUtils)
    +(UIBarButtonItem*)barButtonItemWithCustomView:(UIView*)v;
    +(UIBarButtonItem*)barButtonItemWithTitle:(NSString*)title style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action;
    +(UIBarButtonItem*)barButtonItemWithBarButtonSystemItem:(UIBarButtonSystemItem)item target:(id)target action:(SEL)action;
@end


@interface UIButton(ESUtils)
  @property(nonatomic, assign) NSString* title;
@end


@interface UIDevice(ESUtils)
    +(BOOL)isPad;
    +(BOOL)isPhone;
    +(BOOL)isInLandscape;
    +(BOOL)isInPortrait;
@end


@interface UILabel(ESUtils)
    +(UILabel*)labelWithText:(NSString*)text;
    +(UILabel*)labelWithBoldText:(NSString*)text;
@end


@interface UINavigationController(ESUtils)
  +(UINavigationController*)navigationControllerWithRootViewController:(UIViewController*)vc;

  -(void)popViewController;
@end


@interface UINavigationItem(ESUtils)
    -(void)configureWithTitle:(NSString*)title leftItem:(UIBarButtonItem*)left rightItem:(UIBarButtonItem*)right;
    -(void)setRightBarButtonItems:(NSArray*)items;
@end


@interface UIPickerView(ESUtils)
  +(UIPickerView*)pickerView;
  +(UIPickerView*)pickerViewWithDelegate:(id<UIPickerViewDelegate>)delegate dataSource:(id<UIPickerViewDataSource>)dataSource;
  +(UIPickerView*)pickerViewWithDelegateAndDataSource:(id<UIPickerViewDataSource, UIPickerViewDelegate>)delegate;
  -(id)initWithDelegate:(id<UIPickerViewDelegate>)delegate dataSource:(id<UIPickerViewDataSource>)dataSource;
  -(id)initWithDelegateAndDataSource:(id<UIPickerViewDataSource, UIPickerViewDelegate>)delegate;
@end


@interface UIPopoverController(ESUtils)
  +(UIPopoverController*)popoverControllerWithContentViewController:(UIViewController *)viewController;
  +(UIPopoverController*)popoverControllerWithNavigationAndContentViewController:(UIViewController*)viewController;

  -(void)pointToBarButtonItem:(UIBarButtonItem*)b;
  -(void)dismiss;
@end


@interface UITableViewCell(ESUtils)
    +(UITableViewCell*)cellWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier;
@end

@interface UIToolbar(ESUtils)
  +(UIToolbar*)toolbarWithItems:(NSArray*)items;
  -(void)removeItem:(UIBarButtonItem*)i;
  -(void)removeLastItem;
  -(void)addItem:(UIBarButtonItem*)i;

@end

@interface UIView(ESUtils)
  +(UIView*)viewWithFrame:(CGRect)frame;
  +(void)animate:(void(^)(void))animations;

  // These sizing convenience methods manipulate the frame.
  @property(assign) float    width;
  @property(assign) float    height;
  @property(assign) float    x;
  @property(assign) float    y;
  @property(assign) CGSize   size;
  @property(assign) CGPoint  origin;
  @property(assign) UIColor* borderColor;
  @property(assign) float    borderWidth;
  @property(assign) float    cornerRadius;

  @property(nonatomic, readonly) BOOL         isInPopover;
  @property(nonatomic, readonly) UIResponder* findFirstResponder;

  -(void)replaceInSuperviewWith:(UIView*)v;
  -(void)centerInSuperview;

  -(void)resizeSuperviewAndSetHeight:(float)dynamicHeight;
  -(void)resizeSuperviewAndSetHeight:(float)dynamicHeight animated:(BOOL)animate;
@end

@interface UIViewController(ESUtils)
  //Passed Apple's review. Prefixed with a $ to indicate undocumented api and to prevent conflict with key.
  @property(nonatomic, readonly) UIPopoverController *$popoverController;
    
  // Forces without using a private api.
  -(void)forcePortrait;

  -(void)forcePopoverSize;

  -(void)popOrDismiss;

  //You must retain this popover while it is open (releasing upon popoverControllerDidDismissPopover), or retain the view controller passed in. Retaining one popover in the parent view controller can be a convenient way to insure that only one is open.
  -(UIPopoverController*)popoverIn:(UIViewController*)vc fromRect:(CGRect)r delegate:(id<UIPopoverControllerDelegate>)delegate;
  -(UIPopoverController*)popoverFromBarButtonItem:(UIBarButtonItem *)button delegate:(id<UIPopoverControllerDelegate>)delegate;
  -(UIPopoverController*)popoverFromBarButtonItem:(UIBarButtonItem*)button;
  @property(nonatomic, readonly) UIWindow* window;

  -(void)observeKeyboardEvents;
  -(void)stopObservingKeyboardEvents;
  //These methods will only be called after observeKeyboardEvents is called.
  -(void)keyboardWillShow:(NSNotification*)n;
  -(void)keyboardDidShow:(NSNotification*)n;
  -(void)keyboardWillHide:(NSNotification*)n;
  -(void)keyboardDidHide:(NSNotification*)n;
@end

@interface UIScrollView(ESUtils)
  -(void)scrollViewToVisibleForKeyboard:(UIView*)v;
  -(void)scrollViewToVisibleForKeyboard:(UIView*)v animated:(BOOL)animated;
  -(void)scrollFirstResponderToVisibleForKeyboard;
@end

@interface UITextField (ESUtils)
  +(UITextField*)textFieldWithFrame:(CGRect)frame;

  // Passed Apple's review.
  @property(assign) UIColor *placeholderColor;

  // Call in viewWillAppear to vertially center.
  // Reset in textFieldShouldClear: and shouldChangeCharactersInRange to prevent resetting.
  @property(assign) UIFont  *placeholderFont;
@end

@interface UITextView(ESUtils)
  -(void)styleAsRoundedRect;
@end

@interface UITableView(ESUtils)
  +(UITableView*)tableViewWithFrame:(CGRect)bounds style:(UITableViewStyle)style;
  @property(readonly) BOOL isEmpty;
  @property(readonly) BOOL isNotEmpty;
  -(UITableViewCell*)cellForRow:(int)r inSection:(int)s;
  -(UITableViewCell*)cellForRow:(int)r;
  -(void)doForEachCellInSection:(int)s action:(ESUICellBlock)action;
  -(void)doForEachIndexPathInSection:(int)s action:(ESUIIndexPathBlock)action;
  -(void)insertRowAtIndexPath:(NSIndexPath*)indexPath withRowAnimation:(UITableViewRowAnimation)animation;
  -(void)insertRow:(int)r inSection:(int)s withRowAnimation:(UITableViewRowAnimation)animation;
  -(void)insertRow:(int)r withRowAnimation:(UITableViewRowAnimation)animation;
  -(void)insertSection:(int)s withRowAnimation:(UITableViewRowAnimation)a;
  -(void)scrollToRow:(int)r inSection:(int)s atScrollPosition:(UITableViewScrollPosition)p animated:(BOOL)a;
  -(void)scrollToRow:(int)r atScrollPosition:(UITableViewScrollPosition)p animated:(BOOL)a;
  -(void)deleteRowAtIndexPath:(NSIndexPath*)i withRowAnimation:(UITableViewRowAnimation)a;
  -(void)deleteRow:(int)r inSection:(int)s withRowAnimation:(UITableViewRowAnimation)a;
  -(void)deleteRow:(int)r withRowAnimation:(UITableViewRowAnimation)a;
  -(void)deleteSection:(int)s withRowAnimation:(UITableViewRowAnimation)a;
  -(void)deselectAll;
@end

@interface UIImage(ESUtils)
  +(UIImage*)imageFromLayer:(CALayer*)layer;
@end

@interface UIImageView(ESUtils)
  +(UIImageView*)imageViewWithImage:(UIImage*)i;
@end

@interface UIWindow(ESUtils)
  @property(nonatomic, readonly) BOOL isDisplayingAlert;
@end

#endif /*IS_IOS*/