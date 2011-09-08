#if IS_IOS

#import <Foundation/Foundation.h>

// TODO: a downside of this implementation is that it must be retained or the block call will return an error. Perhaps we should extend ActionSheet instead.
@interface ESBlockActionSheet : NSObject<UIActionSheetDelegate>
{
    UIActionSheet  *sheet;

    NSString *title;
    NSString *cancelTitle;
    NSString *destroyTitle;
    
    void(^doOnCancel)(void);
    void(^doOnDestroy)(void);
    
    NSMutableArray *buttonTitles;
    NSMutableArray *doOnPresses;
    
    UIViewController *controller;
}

@property (nonatomic, readonly, retain) UIActionSheet *sheet;
@property (nonatomic, retain)           NSString      *title;
@property (nonatomic, retain)           NSString      *cancelTitle;
@property (nonatomic, retain)           NSString      *destroyTitle;

@property (nonatomic, copy) void(^doOnCancel)(void);
@property (nonatomic, copy) void(^doOnDestroy)(void);

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

@end

#endif /*IS_IOS*/