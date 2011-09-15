#if IS_IOS

#import <UIKit/UIKit.h>

// Lays out in one column with left alignment.
// Resizes vertically automatically to match content.
@interface ESVerticalLayoutView : UIView {
    double padding;
}

@property(nonatomic, assign) double padding;

@end

#endif //IS_IOS