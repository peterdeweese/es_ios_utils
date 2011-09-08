#if IS_IOS

//
//  To bind a view to a model, use -addView:object:keyPath:.  Values from a view such as a UITextField will be copied as
//  an NSString to the target.  If you are saving data using some other mechanism but need it to display you can specify
//  a synthetic read-only property to produce the text.
//

#import <Foundation/Foundation.h>


@interface ESViewDataMapper : NSObject

/*
 * Having seperate save and load methods causes dual configuration and potential differences, so this class allows for the mapping to be configured once.
 * Supports UITextField and UITextView.  Object and keyPath together must refer to an NSString.
 */
-(void)addView:(UIView*)view object:(id)object keyPath:(NSString*)keyPath;

-(void)updateObjects;
-(void)updateViews;

-(void)updateObjectForView:(UIView*)view;
-(void)updateView:(UIView*)view;

-(id)objectValueForView:(UIView*)view;

@end

#endif //IS_IOS