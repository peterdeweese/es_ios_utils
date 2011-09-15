#if IS_IOS

#import <UIKit/UIKit.h>

@interface ESFlashMessageView : UILabel

//default color: lightGrayColor

@property(nonatomic, assign) float fadeDuration; //default 0.5
@property(nonatomic, assign) float maxAlpha;  //default 0.8

-(void)addMessage:(NSString*)message;

-(void)start;
-(void)stop;

@end

#endif //IS_IOS