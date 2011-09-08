#ifdef IS_IOS

#import <UIKit/UIKit.h>

@interface ESCircleView : UIView

+(ESCircleView*)createWithDiameter:(float)diameter;

@property(nonatomic, assign) float diameter;

@end

#endif /*IS_IOS*/