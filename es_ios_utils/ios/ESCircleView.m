#if IS_IOS

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
    self.size = $size(size, size);
    self.cornerRadius = size/2.;
}

-(float)diameter { return self.width; }
-(void)setDiameter:(float)diameter
{
    self.size = $size(diameter, diameter);
}

@end

#endif //IS_IOS