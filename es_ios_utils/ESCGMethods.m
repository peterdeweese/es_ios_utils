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

@end
