//
//  ESBlockActionSheet.m
//  es_ios_utils
//
//  Created by Peter DeWeese on 4/19/11.
//  Copyright 2011 Eye Street Research, LLC. All rights reserved.
//

#import "ESBlockActionSheet.h"

@implementation ESBlockActionSheet

+ (ESBlockActionSheet*)blockActionSheetWithTitle:(NSString*)title
{
    ESBlockActionSheet* sheet = [[[ESBlockActionSheet alloc] init] autorelease];
    sheet.title = title;
    
    return sheet;
}

+ (ESBlockActionSheet*)blockActionSheetWithTitle:(NSString*)title
                                   cancelTitle:(NSString*)cancelTitle
                                    doOnCancel:(void (^)(void))doOnCancel
{
    ESBlockActionSheet* sheet = [self blockActionSheetWithTitle:title];
    sheet.cancelTitle = cancelTitle;
    sheet.doOnCancel = doOnCancel;
    
    return sheet;
}

+ (ESBlockActionSheet*)blockActionSheetWithTitle:(NSString*)title
                                   cancelTitle:(NSString*)cancelTitle
                                    doOnCancel:(void(^)(void))doOnCancel
                                   destroyTitle:(NSString*)destroyTitle
                                    doOnDestroy:(void(^)(void))doOnDestroy
{
    ESBlockActionSheet* sheet = [self blockActionSheetWithTitle:title cancelTitle:cancelTitle doOnCancel:doOnCancel];
    sheet.destroyTitle = destroyTitle;
    sheet.doOnDestroy = doOnDestroy;
    
    return sheet;
}

- (id)init
{
    doOnPresses  = [[[NSMutableArray alloc] init] retain];
    buttonTitles = [[[NSMutableArray alloc] init] retain];
    
    return self;
}

- (void)dealloc
{
    [sheet release];
    [doOnCancel release];
    [doOnDestroy release];
    [doOnPresses release];
    [buttonTitles release];
    
    [super dealloc];
}

#pragma mark Properties
@synthesize sheet, title, cancelTitle, destroyTitle, doOnCancel, doOnDestroy;

-(void)addButtonWithTitle:(NSString*)buttonTitle doOnPress:(void(^)(void))doOnPress
{
    if(sheet)
        return;
    [buttonTitles addObject:buttonTitle];
    [doOnPresses addObject:doOnPress?(id)Block_copy(doOnPress):NSNull.null];
}

#pragma mark Control

//Once this is called, the action sheet becomes static.
-(IBAction)presentIn:(UIViewController*)_controller
{
    if(!sheet)
    {
        sheet = [[UIActionSheet alloc] init];
        sheet.title = title;
        sheet.delegate = self;
        
        if(destroyTitle)
        {
            [sheet addButtonWithTitle:destroyTitle];
            sheet.destructiveButtonIndex = sheet.numberOfButtons-1;
            [doOnPresses insertObject:doOnDestroy?(id)doOnDestroy:NSNull.null atIndex:0];
        }
        
        if(buttonTitles)
            for(NSString *buttonTitle in buttonTitles)
                [sheet addButtonWithTitle:buttonTitle];
        
        if(cancelTitle)
        {
            [sheet addButtonWithTitle:cancelTitle];
            sheet.cancelButtonIndex = sheet.numberOfButtons-1;
            [doOnPresses addObject:doOnCancel?(id)doOnCancel:NSNull.null];
        }
    }
    
    controller = _controller;
    [sheet showInView:controller.view];
}

#pragma mark Action Sheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    void(^actionBlock)(void) = [doOnPresses objectAtIndex:buttonIndex];
    if(actionBlock && (id)actionBlock != NSNull.null)
        actionBlock();
}

@end
