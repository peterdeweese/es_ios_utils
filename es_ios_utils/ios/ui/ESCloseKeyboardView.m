#import "ESCloseKeyboardView.h"

@implementation ESCloseKeyboardView

-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    [self.findFirstResponder resignFirstResponder];
}

@end
