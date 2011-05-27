//
//  ESViewDataMapper.m
//  es_ios_utils
//
//  Created by Peter DeWeese on 3/21/11.
//  Copyright 2011 Eye Street Research, LLC. All rights reserved.
//

#import "ESUtils.h"
#import "ESViewDataMapper.h"

@interface ESViewDataMap:NSObject{
    UIView   *view;
    id        object;
    NSString *keyPath;
}

@property(nonatomic, retain) UIView   *view;
@property(nonatomic, retain) id        object;
@property(nonatomic, retain) NSString *keyPath;

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
        self.maps = [[[NSMutableArray alloc] init] autorelease];
        self.mapByView = [[[NSMutableDictionary alloc] init] autorelease];
    }
    
    if(view)
    {
        ESViewDataMap *m = [[ESViewDataMap alloc] autorelease];
        [maps addObject:m];
        [mapByView setObject:m forKeyObject:view];
        
        m.view = view;
        m.object = object;
        m.keyPath = keyPath;
        
    }
    else
        NSLog(@"Warning: View not added to data map because it is nil.");
}

-(void)updateViews
{
    for(ESViewDataMap *m in maps)
    {
        NSString *value = [m.object valueForKeyPath:m.keyPath];
        NSLog(@"Updating view: %@=%@", m.keyPath, value);
        
        if(value && ![value isKindOfClass:NSString.class])
            NSLog(@"Warning: Value not set from keyPath '%@' because the value was not an NSString. %@", m.keyPath, value.class);
        if([m.view isKindOfClass:UITextField.class])
            ((UITextField*)m.view).text = value;
        else if([m.view isKindOfClass:UITextView.class])
            ((UITextView*)m.view).text = value;
        else if([m.view isKindOfClass:UILabel.class])
            ((UILabel*)m.view).text = value;
        else if([m.view isKindOfClass:UIButton.class])
            [(UIButton*)m.view setTitle:value forState:UIControlStateNormal];
        else
            NSLog(@"Warning: Value not set from keyPath '%@' because the view is not of a supported type. %@", m.keyPath, m.view.class);
    }
}

-(void)updateObjectForMap:(ESViewDataMap*)m
{
    NSString *value = nil;
    
    if([m.view isKindOfClass:UITextField.class])
        value = ((UITextField*)m.view).text;
    else if([m.view isKindOfClass:UITextView.class])
        value = ((UITextView*)m.view).text;
    else if([m.view isKindOfClass:UILabel.class])
        value = ((UILabel*)m.view).text;
    else if([m.view isKindOfClass:UIButton.class])
        value = [(UIButton*)m.view titleForState:UIControlStateNormal];
    else
        NSLog(@"Warning: Value not set from keyPath '%@' because the view is not of a supported type. %@", m.keyPath, m.view.class);
        
    if(value && ![value isKindOfClass:NSString.class])
        NSLog(@"Warning: Value not set from keyPath '%@' because the value was not an NSString. %@", m.keyPath, value.class);
    else
    {
        @try
        {
            NSLog(@"Updating object: %@=%@", m.keyPath, value);
            [m.object setValue:value forKeyPath:m.keyPath];
        }
        @catch (NSException *e)
        {
            if ([e.name isEqual:@"NSUnknownKeyException"])
                NSLog(@"Value not set: no setter found for %@.", m.keyPath);
            else @throw(e);
        }
    }
}

-(void)updateObjectForView:(UIView*)view
{
    [self updateObjectForMap:[mapByView objectForKeyObject:view]];
}

-(void)updateObjects
{
    NSLog(@"Saving values from views.");

    for(ESViewDataMap *m in maps)
        [self updateObjectForMap:m];
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

@end
