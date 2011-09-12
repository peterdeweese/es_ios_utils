#if IS_IOS

#import "ESBlockActionSheet.h"

@interface ESBlockActionSheet()
  @property(nonatomic, retain) NSMutableArray* buttonTitles;
  @property(nonatomic, retain) NSMutableArray* doOnPresses;
@end

@implementation ESBlockActionSheet

+(ESBlockActionSheet*)blockActionSheetWithTitle:(NSString*)title
{
    ESBlockActionSheet* sheet = [[[ESBlockActionSheet alloc] init] autorelease];
    sheet.title = title;
    
    return sheet;
}

+(ESBlockActionSheet*)blockActionSheetWithTitle:(NSString*)title
                                   cancelTitle:(NSString*)cancelTitle
                                    doOnCancel:(void (^)(void))doOnCancel
{
    ESBlockActionSheet* sheet = [self blockActionSheetWithTitle:title];
    sheet.cancelTitle = cancelTitle;
    sheet.doOnCancel = doOnCancel;
    
    return sheet;
}

+(ESBlockActionSheet*)blockActionSheetWithTitle:(NSString*)title
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

+(ESBlockActionSheet*)blockActionSheetWithTitle:(NSString*)title
                                   destroyTitle:(NSString*)destroyTitle
                                    doOnDestroy:(void(^)(void))doOnDestroy
{
    return [self blockActionSheetWithTitle:title cancelTitle:nil doOnCancel:nil destroyTitle:destroyTitle doOnDestroy:doOnDestroy];
}

- (id)init
{
    self.doOnPresses  = [NSMutableArray arrayWithCapacity:10];
    self.buttonTitles = [NSMutableArray arrayWithCapacity:10];
    
    return self;
}

#pragma mark Properties
@synthesize sheet, title, cancelTitle, destroyTitle, doOnCancel, doOnDestroy, buttonTitles, doOnPresses;

-(void)addButtonWithTitle:(NSString*)buttonTitle doOnPress:(void(^)(void))doOnPress
{
    if(sheet)
        return;
    [buttonTitles addObject:buttonTitle];
    [doOnPresses addObject:doOnPress?(id)[doOnPress copy]:NSNull.null];
}

#pragma mark Control

//Once this is called, the action sheet becomes static.
-(IBAction)buildSheet
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
}

-(IBAction)presentIn:(UIViewController*)controller
{
    [self buildSheet];
    [sheet showInView:controller.view];
}

-(IBAction)presentIn:(UIView*)view fromRect:(CGRect)from
{
    [self buildSheet];
    [sheet showFromRect:from inView:view animated:YES];
}

-(IBAction)presentFromBarButtonItem:(UIBarButtonItem*)item
{
    [self buildSheet];
    [sheet showFromBarButtonItem:item animated:YES];
}

#pragma mark Action Sheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    void(^actionBlock)(void) = [doOnPresses objectAtIndex:buttonIndex];
    if(actionBlock && (id)actionBlock != NSNull.null)
        actionBlock();
}

- (void)dealloc
{
    self.sheet = nil;
    self.doOnCancel = nil;
    self.doOnDestroy = nil;
    for(id b in self.doOnPresses) //each block was copied before adding
        [b release];
    self.doOnPresses = nil;
    self.buttonTitles = nil;
    
    [super dealloc];
}

@end

#endif /*IS_IOS*/