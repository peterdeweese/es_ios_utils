#import <Foundation/Foundation.h>

#define $size(w, h) CGSizeMake(w, h)
#define $point(x, y) CGPointMake(x, y)
#define $rect(x, y, w, h) CGRectMake(x, y, w, h)

@interface CG : NSObject
  +(float)scaleToAspectFit:(CGSize)source into:(CGSize)into;
  +(float)scaleToAspectFit:(CGSize)source into:(CGSize)into padding:(float)padding;
  +(float)scaleToAspectFill:(CGSize)source into:(CGSize)into;
@end
