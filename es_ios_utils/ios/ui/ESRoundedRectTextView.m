#if IS_IOS
#import "ESRoundedRectTextView.h"

@implementation ESRoundedRectTextView

-(id)init
{
    [super init];
    [self styleAsRoundedRect];
    return self;
}

-(id)initWithCoder:(NSCoder*)aDecoder
{
    [super initWithCoder:aDecoder];
    [self styleAsRoundedRect];
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    [super initWithFrame:frame];
    [self styleAsRoundedRect];
    return self;
}

@end

#endif