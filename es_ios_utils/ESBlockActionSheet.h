//
//  ESBlockActionSheet.h
//  es_ios_utils
//
//  Created by Peter DeWeese on 4/19/11.
//  Copyright 2011 Eye Street Research, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ESBlockActionSheet : NSObject<UIActionSheetDelegate>
{
    UIActionSheet  *sheet;

    NSString *title;
    NSString *cancelTitle;
    NSString *destroyTitle;
    
    void(^doOnCancel)(UIViewController*);
    void(^doOnDestroy)(UIViewController*);
    
    NSMutableArray *buttonTitles;
    NSMutableArray *doOnPresses;
    
    UIViewController *controller;
}

@property (nonatomic, readonly, retain) UIActionSheet *sheet;
@property (nonatomic, retain)           NSString      *title;
@property (nonatomic, retain)           NSString      *cancelTitle;
@property (nonatomic, retain)           NSString      *destroyTitle;

@property (nonatomic, assign) void(^doOnCancel)(UIViewController*);
@property (nonatomic, assign) void(^doOnDestroy)(UIViewController*);

+ (ESBlockActionSheet*)blockActionSheetWithTitle:(NSString*)title;

+ (ESBlockActionSheet*)blockActionSheetWithTitle:(NSString*)title
                                   cancelTitle:(NSString*)cancelTitle
                                    doOnCancel:(void (^)(UIViewController *controller))doOnCancel;

+ (ESBlockActionSheet*)blockActionSheetWithTitle:(NSString*)title
                                   cancelTitle:(NSString*)cancelTitle
                                    doOnCancel:(void (^)(UIViewController *controller))doOnCancel
                                  destroyTitle:(NSString*)destroyTitle
                                   doOnDestroy:(void (^)(UIViewController *controller))doOnDestroy;

-(void)addButtonWithTitle:(NSString*)title doOnPress:(void (^)(UIViewController*))doOnPress;

-(IBAction)presentIn:(UIViewController*)controller;

@end
