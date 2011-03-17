//
//  ESUICategories.m
//  es_ios_utils
//
//  Created by Peter DeWeese on 3/16/11.
//  Copyright 2011 Eye Street Research, LLC. All rights reserved.
//

#import "ESUICategories.h"


@implementation ESUICategories

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


@end


@implementation UITextField (ESUtils)

// Perhaps a private ivar, but at least one dev has had luck getting it through Apple: http://stackoverflow.com/questions/1340224/iphone-uitextfield-change-placeholder-text-color

- (UIColor*)placeholderColor
{
    return [self valueForKey:@"_placeholderLabel.textColor"];
}

- (void)setPlaceholderColor:(UIColor*)color
{
    [self setValue:color forKeyPath:@"_placeholderLabel.textColor"];
}

@end


@implementation UITableView (ESUtils)

// Returns YES if there are no rows in any section.
- (BOOL)empty
{    
    for(int s=0; s<self.numberOfSections; s++)
        if([self numberOfRowsInSection:s])
            return NO;
    
    return YES;
}

- (UITableViewCell*)cellForRow:(int)r inSection:(int)s
{
    return [self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:r inSection:s]];
}

// Defaults to the first section
- (UITableViewCell*)cellForRow:(int)r
{
    return [self cellForRow:r inSection:0];
}

- (void)doForEachCellInSection:(int)s action:(void(^)(UITableViewCell *c))action
{
    for(int r=0; r<[self numberOfRowsInSection:s]; r++)
        action([self cellForRow:r inSection:s]);
}

@end