#if IS_IOS
#import "ESRoundedRectTextView.h"

@implementation ESRoundedRectTextView

-(id)init
{
    if(self = [super init])
        [self styleAsRoundedRect];
    return self;
}

-(id)initWithCoder:(NSCoder*)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
        [self styleAsRoundedRect];
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
        [self styleAsRoundedRect];
    return self;
}

@end

#endif