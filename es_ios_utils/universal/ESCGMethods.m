#import "ESCGMethods.h"

@implementation CG

+(float)scaleToAspectFit:(CGSize)source into:(CGSize)into
{
    return MIN(into.width/source.width, into.height/source.height);
}

//padding is a ratio, not in pixels. Good for imprecise font rendering.
+(float)scaleToAspectFit:(CGSize)source into:(CGSize)into padding:(float)padding
{
    return [self scaleToAspectFit:source into:$size(into.width*(1-padding), into.height*(1-padding))];
}

+(float)scaleToAspectFill:(CGSize)source into:(CGSize)into
{
    return MAX(into.width/source.width, into.height/source.height);
}

+(CGSize)multiplySize:(CGSize)s by:(float)multiple
{
    return CGSizeMake(s.width * multiple, s.height * multiple);
}

+(CGPoint)pointFromSize:(CGSize)s
{
    return CGPointMake(s.width, s.height);
}

+(CGPoint)centerOfSize:(CGSize)s
{
    return [CG pointFromSize:[CG multiplySize:s by:0.5]];
}

+(CGPoint)subtractPoint:(CGPoint)p from:(CGPoint)from
{
    return CGPointMake(from.x - p.x, from.y - p.y);
}

+(float)distanceFromOriginToPoint:(CGPoint)p
{
    return sqrtf(p.x*p.x + p.y*p.y);
}

@end
