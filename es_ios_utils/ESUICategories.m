//
//  ESUICategories.m
//  es_ios_utils
//
//  Created by Peter DeWeese on 3/16/11.
//  Copyright 2011 Eye Street Research, LLC. All rights reserved.
//

#import "ESUICategories.h"


@implementation UIView (ESUtils)

- (float)width { return self.frame.size.width; }
- (void)setWidth:(float)width
{
    CGRect bounds = self.bounds;
    bounds.size.width = width;
    self.bounds = bounds;
}

- (float)height { return self.frame.size.height; }
- (void)setHeight:(float)height
{
    CGRect bounds = self.bounds;
    bounds.size.height = height;
    self.bounds = bounds;
}

- (float)x { return self.frame.origin.x; }
- (void)setX:(float)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (float)y { return self.frame.origin.y; }
- (void)setY:(float)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGSize)size { return self.frame.size; }
- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}


@end


@implementation UITextField (ESUtils)

// Uses a private ivar, but Apple reviews allow it in Veporter and other apps:
//     http://stackoverflow.com/questions/1340224/iphone-uitextfield-change-placeholder-text-color
- (UIColor*)placeholderColor
{
    return [self valueForKey:@"_placeholderLabel.textColor"];
}

- (void)setPlaceholderColor:(UIColor*)color
{
    [self setValue:color forKeyPath:@"_placeholderLabel.textColor"];
}

@end


@implementation UITableView(ESUtils)

// Returns YES if there are no rows in any section.
-(BOOL)isEmpty
{    
    for(int s=0; s<self.numberOfSections; s++)
        if([self numberOfRowsInSection:s] > 0)
            return NO;
    
    return YES;
}

-(BOOL)isNotEmpty
{    
    for(int s=0; s<self.numberOfSections; s++)
        if([self numberOfRowsInSection:s] > 0)
            return YES;
    
    return NO;
}

-(UITableViewCell*)cellForRow:(int)r inSection:(int)s
{
    return [self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:r inSection:s]];
}

// Defaults to the first section
-(UITableViewCell*)cellForRow:(int)r
{
    return [self cellForRow:r inSection:0];
}

-(void)doForEachCellInSection:(int)s action:(ESUICellBlock)action
{
    for(int r=0; r<[self numberOfRowsInSection:s]; r++)
        action([self cellForRow:r inSection:s]);
}

-(void)insertRowAtIndexPath:(NSIndexPath*)indexPath withRowAnimation:(UITableViewRowAnimation)animation
{
    [self insertRowsAtIndexPaths:$array(indexPath, nil) withRowAnimation:animation];
}

-(void)insertRow:(int)r inSection:(int)s withRowAnimation:(UITableViewRowAnimation)animation
{
    [self insertRowAtIndexPath:[NSIndexPath indexPathForRow:r inSection:s] withRowAnimation:animation];
}

-(void)insertRow:(int)r withRowAnimation:(UITableViewRowAnimation)animation
{
    [self insertRow:r inSection:0 withRowAnimation:animation];
}

@end