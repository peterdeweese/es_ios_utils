#import <UIKit/UIKit.h>

// Lays out from left to right like text, wrapping whenever the width is met.
// Resizes vertically automatically to match content.
@interface ESFlowLayoutView : UIView {
    double padding;
}

@property (nonatomic, assign) double padding;

@end
