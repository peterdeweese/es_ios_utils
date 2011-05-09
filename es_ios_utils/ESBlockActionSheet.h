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

-(void)addButtonWithTitle:(NSString*)title doOnPress:(void(^)(void))doOnPress;

-(IBAction)presentIn:(UIViewController*)controller;

@end
