#import "ESCircleView.h"
#import <QuartzCore/QuartzCore.h>

@implementation ESCircleView

-(void)layoutSubviews
{
    float size = MIN(self.width, self.height);
    self.size = CGSizeMake(size, size);
    self.layer.cornerRadius = size/2.;
}

@end
