#import "ESCircleView.h"
#import <QuartzCore/QuartzCore.h>

@implementation ESCircleView

+(ESCircleView*)createWithDiameter:(float)diameter
{
    ESCircleView* cv = [[[ESCircleView alloc] init] autorelease];
    cv.diameter = diameter;
    return cv;
}

-(void)layoutSubviews
{
    float size = MIN(self.width, self.height);
    self.size = CGSizeMake(size, size);
    self.layer.cornerRadius = size/2.;
}

-(float)diameter { return self.width; }
-(void)setDiameter:(float)diameter
{
    self.size = CGSizeMake(diameter, diameter);
}

@end
