//
//  ESViewDataMapper.m
//  es_ios_utils
//
//  Created by Peter DeWeese on 3/21/11.
//  Copyright 2011 Eye Street Research, LLC. All rights reserved.
//

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
    @property(nonatomic, retain) NSMutableArray *maps;
@end


@implementation ESViewDataMapper

@synthesize /*private*/ maps;

-(void)addView:(UIView*)view object:(id)object keyPath:(NSString*)keyPath
{
    if(!maps)
        self.maps = [[[NSMutableArray alloc] init] autorelease];
            
    if(view)
    {
        ESViewDataMap *m = [[ESViewDataMap alloc] autorelease];
        [self.maps addObject:m];
        
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
        else if([m.view isKindOfClass:UIButton.class])
            [(UIButton*)m.view setTitle:value forState:UIControlStateNormal];
        else
            NSLog(@"Warning: Value not set from keyPath '%@' because the view is not of a supported type. %@", m.keyPath, m.view.class);
    }
}

-(void)updateObjects
{
    for(ESViewDataMap *m in maps)
    {
        NSString *value = nil;
        
        if([m.view isKindOfClass:UITextField.class])
            value = ((UITextField*)m.view).text;
        else if([m.view isKindOfClass:UITextView.class])
            value = ((UITextView*)m.view).text;
        else if([m.view isKindOfClass:UIButton.class])
            value = [(UIButton*)m.view titleForState:UIControlStateNormal];
        else
            NSLog(@"Warning: Value not set from keyPath '%@' because the view is not of a supported type. %@", m.keyPath, m.view.class);
        
        NSLog(@"Saving from view: %@=%@", m.keyPath, value);

        if(value && ![value isKindOfClass:NSString.class])
            NSLog(@"Warning: Value not set from keyPath '%@' because the value was not an NSString. %@", m.keyPath, value.class);
        else
            [m.object setValue:value forKeyPath:m.keyPath];
    }
}

-(void)dealloc
{
    self.maps = nil;
    
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
