#if IS_IOS

#import "ESUtils.h"
#import "ESViewDataMapper.h"

@interface ESViewDataMap:NSObject{
    UIView   *view;
    id        object;
    NSString *keyPath;
}

@property(nonatomic, strong) UIView*          view;
@property(nonatomic, strong) NSManagedObject* object;
@property(nonatomic, strong) NSString*        keyPath;

@property(nonatomic, unsafe_unretained) id        objectValue;
-(void)updateView;
-(void)updateObject;

@end


@interface ESViewDataMapper()
    @property(nonatomic, strong) NSMutableArray      *maps;
    @property(nonatomic, strong) NSMutableDictionary *mapByView;
@end


@implementation ESViewDataMapper

@synthesize /*private*/ maps, mapByView;

-(void)addView:(UIView*)view object:(id)object keyPath:(NSString*)keyPath
{
    if(!maps)
    {
        self.maps = [NSMutableArray arrayWithCapacity:10];
        self.mapByView = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    
    if(view)
    {
        ESViewDataMap *m = [[ESViewDataMap alloc] init];
        [maps addObject:m];
        [mapByView setObject:m forKeyObject:view];
        
        m.view = view;
        m.object = object;
        m.keyPath = keyPath;
        
    }
    else
        NSLog(@"Warning: View not added to data map because it is nil.");
}

-(ESViewDataMap*)mapForView:(UIView*)view
{
    return [mapByView objectForKeyObject:view];
}

-(void)updateViews
{
    for(ESViewDataMap *m in maps)
        [m updateView];
}

-(void)updateView:(UIView*)view
{
    [[self mapForView:view] updateView];
}

-(void)updateObjects
{
    //#ifdef DEBUG
    //    NSLog(@"Saving values from views.");
    //#endif
    
    for(ESViewDataMap *m in maps)
        [m updateObject];
}

-(void)updateObjectForView:(UIView*)view
{
    [[self mapForView:view] updateObject];
}

-(id)objectValueForView:(UIView*)view
{
    return [self mapForView:view].objectValue;
}

@end


@implementation ESViewDataMap

@synthesize view, object, keyPath;

-(id)objectValue
{
    return [self.object valueForKeyPath:self.keyPath];
}

-(void)setObjectValue:(id)objectValue
{
    if(!self.object.isDeleted && self.object.managedObjectContext)
        [self.object setValue:objectValue forKeyPath:self.keyPath];
}

-(void)updateView
{
    NSObject* value = self.objectValue;
    
    //#ifdef DEBUG
    //    NSLog(@"Updating view: %@=%@", self.keyPath, value);
    //#endif
    
    if([self.view isKindOfClass:UITextField.class])
        ((UITextField*)self.view).text = (NSString*)value;
    else if([self.view isKindOfClass:UITextView.class])
        ((UITextView*)self.view).text = (NSString*)value;
    else if([self.view isKindOfClass:UILabel.class])
        ((UILabel*)self.view).text = (NSString*)value;
    else if([self.view isKindOfClass:UIButton.class])
        ((UIButton*)self.view).title = (NSString*)value;
    else if([self.view isKindOfClass:UIDatePicker.class])
        ((UIDatePicker*)self.view).date = (NSDate*)value ?: NSDate.date;
    else
        NSLog(@"Warning: Value not set from keyPath '%@' because the view is not of a supported type. %@", self.keyPath, [self.view class]);
}

-(void)updateObject
{
    id value = nil;
    
    if([self.view isKindOfClass:UITextField.class])
        value = ((UITextField*)self.view).text;
    else if([self.view isKindOfClass:UITextView.class])
        value = ((UITextView*)self.view).text;
    else if([self.view isKindOfClass:UILabel.class])
        value = ((UILabel*)self.view).text;
    else if([self.view isKindOfClass:UIButton.class])
        value = [(UIButton*)self.view titleForState:UIControlStateNormal];
    else if([self.view isKindOfClass:UIDatePicker.class])
        value = ((UIDatePicker*)self.view).date;
    else
        NSLog(@"Warning: Value not set from keyPath '%@' because the view is not of a supported type. %@", self.keyPath, [self.view class]);
    
    if(value)
    {
        @try
        {
            
            //#ifdef DEBUG
            //                NSLog(@"Updating object: %@=%@", self.keyPath, value);
            //#endif
            
                self.objectValue = value;
        }
        @catch (NSException *e)
        {
            if ([e.name isEqual:@"NSUnknownKeyException"])
                NSLog(@"Value not set: no setter found for %@.", self.keyPath);
            else @throw(e);
        }
    }
}
@end

#endif //IS_IOS