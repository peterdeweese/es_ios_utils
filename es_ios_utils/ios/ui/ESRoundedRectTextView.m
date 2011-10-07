#if IS_IOS
#import "ESRoundedRectTextView.h"

@implementation ESRoundedRectTextView

-(id)init
{
    self = [super init];
    [self styleAsRoundedRect];
    return self;
}

-(id)initWithCoder:(NSCoder*)aDecoder
{
    self = [super initWithCoder:aDecoder];
    [self styleAsRoundedRect];
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self styleAsRoundedRect];
    return self;
}

@end

#endif