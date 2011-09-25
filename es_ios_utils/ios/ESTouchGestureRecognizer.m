#import "ESTouchGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@implementation ESTouchGestureRecognizer

+(ESTouchGestureRecognizer*)touchGestureRecognizerWithTarget:(id)t action:(SEL)a
{
    return [[[ESTouchGestureRecognizer alloc] initWithTarget:t action:a] autorelease];  
}

-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)e
{  
    [super touchesBegan:touches withEvent:e];  
    self.state = UIGestureRecognizerStateBegan;  
}

-(void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)e
{
    [super touchesMoved:touches withEvent:e];  
    self.state = UIGestureRecognizerStateChanged;  
}

-(void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)e
{  
    [super touchesEnded:touches withEvent:e];  
    self.state = UIGestureRecognizerStateEnded;
}

@end
