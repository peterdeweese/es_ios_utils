#if IS_IOS

#import "ESTextField.h"

@implementation ESTextField

@synthesize nextEditor;

-(void)initialize
{
    [self addTarget:self action:@selector(useCustomNextResponder:) forControlEvents:UIControlEventEditingDidEndOnExit];
}

-(id)init
{
    if(self = [super init])
        [self initialize];
    return self;
}

-(id)initWithCoder:(NSCoder*)c
{
    if(self = [super initWithCoder:c])
        [self initialize];
    return self;
}

-(id)initWithFrame:(CGRect)f
{
    if(self = [super initWithFrame:f])
        [self initialize];
    return self;
}

-(void)useCustomNextResponder:(NSNotification*)n
{
    [nextEditor becomeFirstResponder];
}

@end

#endif /*IS_IOS*/