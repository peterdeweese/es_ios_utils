#ifdef IS_IOS

#import <UIKit/UIKit.h>

// Lays out from left to right like text, wrapping whenever the width is met.
// Resizes vertically automatically to match content.
@interface ESFlowLayoutView : UIView

+(ESFlowLayoutView*)flowLayoutViewWithSubviews:(NSArray*)subviews;

@property(nonatomic, assign) double padding;

@end

#endif //IS_IOS