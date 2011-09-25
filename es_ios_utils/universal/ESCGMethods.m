#import "ESCGMethods.h"

@implementation CG

+(BOOL)point:(CGPoint)p1 isEqualTo:(CGPoint)p2
{
    return CGPointEqualToPoint(p1, p2);
}

+(BOOL)pointIsZero:(CGPoint)p
{
    return [CG point:p isEqualTo:CGPointZero];
}

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
    return $size(s.width * multiple, s.height * multiple);
}

+(CGPoint)pointFromSize:(CGSize)s
{
    return $point(s.width, s.height);
}

+(CGPoint)centerOfSize:(CGSize)s
{
    return [CG pointFromSize:[CG multiplySize:s by:0.5]];
}

+(CGPoint)subtractPoint:(CGPoint)p from:(CGPoint)from
{
    return $point(from.x - p.x, from.y - p.y);
}

+(float)distanceFromOriginToPoint:(CGPoint)p
{
    return sqrtf(p.x*p.x + p.y*p.y);
}

+(float)distanceFromPoint:(CGPoint)from to:(CGPoint)to
{
    return [CG distanceFromOriginToPoint:[CG subtractPoint:from from:to]];
}


#pragma mark - Drawing Methods

+(CGContextRef)currentContext
{
    return UIGraphicsGetCurrentContext();
}

+(void)beginPathInContext:(CGContextRef)c
{
    CGContextBeginPath(c);
}

+(void)context:(CGContextRef)c drawPath:(CGPathDrawingMode)mode
{
    CGContextDrawPath(c, mode);
}

+(void)context:(CGContextRef)c setLineWidth:(CGFloat)w
{
    CGContextSetLineWidth(c, w);
}

+(void)context:(CGContextRef)c setLineCap:(CGLineCap)cap
{
    CGContextSetLineCap(c, cap);
}

+(void)context:(CGContextRef)c setStrokeColor:(UIColor*)color
{
    CGContextSetStrokeColorWithColor(c, color.CGColor);
}

+(void)context:(CGContextRef)c setFillColor:(UIColor*)color
{
    CGContextSetFillColorWithColor(c, color.CGColor);
}

+(void)context:(CGContextRef)c addElipseInRect:(CGRect)r
{
    CGContextAddEllipseInRect(c, r);
}

+(void)context:(CGContextRef)c addCircleAt:(CGPoint)p radius:(float)r
{
    [CG context:c addElipseInRect:$rect(p.x - r, p.y-r, r*2, r*2)];
}

+(void)context:(CGContextRef)c moveTo:(CGPoint)p
{
    CGContextMoveToPoint(c, p.x, p.y);
}

+(void)context:(CGContextRef)c addLineTo:(CGPoint)p
{
    CGContextAddLineToPoint(c, p.x, p.y);
}

+(void)context:(CGContextRef)c addLineFrom:(CGPoint)f to:(CGPoint)t
{
    [self context:c moveTo:f];
    [self context:c addLineTo:t];
}

+(void)context:(CGContextRef)c addLines:(const CGPoint*)points count:(size_t)count
{
    CGContextAddLines(c, points, count);
}


#pragma mark Use Current Context

+(void)beginPath
{
    [CG beginPathInContext:CG.currentContext];
}

+(void)drawPath:(CGPathDrawingMode)mode
{
    [CG context:CG.currentContext drawPath:mode];
}

+(void)fillPath
{
    [CG drawPath:kCGPathFillStroke];
}

+(void)drawPath
{
    [CG drawPath:kCGPathStroke];
}

+(void)setLineWidth:(CGFloat)w
{
    [CG context:CG.currentContext setLineWidth:w];
}

+(void)setLineCap:(CGLineCap)cap
{
    [CG context:CG.currentContext setLineCap:cap];
}

+(void)setStrokeColor:(UIColor*)color
{
    [CG context:CG.currentContext setStrokeColor:color];
}

+(void)setFillColor:(UIColor*)color
{
    [CG context:CG.currentContext setFillColor:color];
}

+(void)drawElipseInRect:(CGRect)r
{
    [CG context:CG.currentContext addElipseInRect:r];
}

+(void)drawCircleAt:(CGPoint)p radius:(float)r
{
    [CG context:CG.currentContext addCircleAt:p radius:r];
}

+(void)moveTo:(CGPoint)p
{
    [CG context:CG.currentContext moveTo:p];
}

+(void)addLineTo:(CGPoint)p
{
    [CG context:CG.currentContext addLineTo:p];
}

+(void)addLineFrom:(CGPoint)f to:(CGPoint)t
{
    [CG context:CG.currentContext addLineFrom:f to:t];
}

+(void)addLines:(const CGPoint*)points count:(size_t)count
{
    [CG context:CG.currentContext addLines:points count:count];
}

@end
