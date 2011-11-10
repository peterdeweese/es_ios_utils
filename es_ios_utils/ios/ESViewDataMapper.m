#if IS_IOS

#import "ESUtils.h"
#import "ESViewDataMapper.h"

@interface ESViewDataMap:NSObject{
    UIView   *view;
    id        object;
    NSString *keyPath;
}

@property(nonatomic, retain) UIView*          view;
@property(nonatomic, retain) NSManagedObject* object;
@property(nonatomic, retain) NSString*        keyPath;

@property(nonatomic, assign) id        objectValue;
-(void)updateView;
-(void)updateObject;

@end


@interface ESViewDataMapper()
    @property(nonatomic, retain) NSMutableArray      *maps;
    @property(nonatomic, retain) NSMutableDictionary *mapByView;
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
        ESViewDataMap *m = [[[ESViewDataMap alloc] init] autorelease];
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
    NSLog(@"Saving values from views.");
    
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

-(void)dealloc
{
    self.maps = nil;
    self.mapByView = nil;
    
    [super dealloc];
}

@end


@implementation ESViewDataMap

@synthesize view, object, keyPath;

-(void)dealloc
{
    self.view = nil;
    self.object = nil;
    self.keyPath = nil;
    [super dealloc];
}

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
    NSLog(@"Updating view: %@=%@", self.keyPath, value);
    
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
                NSLog(@"Updating object: %@=%@", self.keyPath, value);
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