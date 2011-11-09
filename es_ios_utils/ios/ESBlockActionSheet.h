#if IS_IOS

#import "ESUtils.h"

#import <Foundation/Foundation.h>

// TODO: a downside of this implementation is that it must be retained or the block call will return an error. Perhaps we should extend ActionSheet instead.
@interface ESBlockActionSheet : NSObject<UIActionSheetDelegate>

@property(nonatomic, retain) UIActionSheet*  sheet;

@property(nonatomic, retain)           NSString      *title;
@property(nonatomic, retain)           NSString      *cancelTitle;
@property(nonatomic, retain)           NSString      *destroyTitle;

@property(nonatomic, copy) void(^doOnCancel)(void);
@property(nonatomic, copy) void(^doOnClose)(void);
@property(nonatomic, copy) void(^doOnDestroy)(void);

+ (ESBlockActionSheet*)blockActionSheetWithTitle:(NSString*)title;

+ (ESBlockActionSheet*)blockActionSheetWithTitle:(NSString*)title
                                   cancelTitle:(NSString*)cancelTitle
                                    doOnCancel:(void(^)(void))doOnCancel;

+ (ESBlockActionSheet*)blockActionSheetWithTitle:(NSString*)title
                                   cancelTitle:(NSString*)cancelTitle
                                    doOnCancel:(void(^)(void))doOnCancel
                                  destroyTitle:(NSString*)destroyTitle
                                   doOnDestroy:(void(^)(void))doOnDestroy;

+(ESBlockActionSheet*)blockActionSheetWithTitle:(NSString*)title
                                   destroyTitle:(NSString*)destroyTitle
                                    doOnDestroy:(void(^)(void))doOnDestroy;

-(void)addButtonWithTitle:(NSString*)title doOnPress:(void(^)(void))doOnPress;

-(IBAction)presentIn:(UIViewController*)controller;
-(IBAction)presentIn:(UIView*)view fromRect:(CGRect)from;
-(IBAction)presentFromBarButtonItem:(UIBarButtonItem*)item;
-(IBAction)dismissWithAnimation:(BOOL)animate;
-(IBAction)dismiss;

@end

#endif /*IS_IOS*/