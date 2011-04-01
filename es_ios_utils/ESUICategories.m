//
//  ESUICategories.m
//  es_ios_utils
//
//  Created by Peter DeWeese on 3/16/11.
//  Copyright 2011 Eye Street Research, LLC. All rights reserved.
//

#import "ESUICategories.h"
#import "ESUtils.h"

@implementation UILabel(ESUtils)

+(UILabel*)labelWithText:(NSString*)text
{
    UILabel *l = [[UILabel alloc] init];
    l.text = text;
    [l sizeToFit];
    return l;
}

+(UILabel*)labelWithBoldText:(NSString*)text
{
    UILabel *l = [self labelWithText:text];
    l.font = [UIFont boldSystemFontOfSize:l.font.pointSize];
    [l sizeToFit];
    return l;
}

@end


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

-(void)scrollToRow:(int)r inSection:(int)s atScrollPosition:(UITableViewScrollPosition)p animated:(BOOL)a
{
    [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:r inSection:s] atScrollPosition:p animated:a];
}

-(void)scrollToRow:(int)r atScrollPosition:(UITableViewScrollPosition)p animated:(BOOL)a
{
    [self scrollToRow:r inSection:0 atScrollPosition:p animated:a];
}

-(void)deleteRowAtIndexPath:(NSIndexPath*)i withRowAnimation:(UITableViewRowAnimation)a
{
    [self deleteRowsAtIndexPaths:$array(i, nil) withRowAnimation:a];
}

-(void)deleteRow:(int)r inSection:(int)s withRowAnimation:(UITableViewRowAnimation)a
{
    [self deleteRowAtIndexPath:[NSIndexPath indexPathForRow:r inSection:s] withRowAnimation:a];
}

-(void)deleteRow:(int)r withRowAnimation:(UITableViewRowAnimation)a
{
    [self deleteRow:r inSection:0 withRowAnimation:a];
}

@end