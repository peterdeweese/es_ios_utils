#if IS_IOS

#import "ESTextField.h"

@implementation ESTextField

@synthesize customNextResponder;

-(void)initialize
{
    [self addTarget:self action:@selector(useCustomNextResponder:) forControlEvents:UIControlEventEditingDidEndOnExit];
}

-(id)init
{
    [super init];
    [self initialize];
    return self;
}

-(id)initWithCoder:(NSCoder*)c
{
    [super initWithCoder:c];
    [self initialize];
    return self;
}

-(id)initWithFrame:(CGRect)f
{
    [super initWithFrame:f];
    [self initialize];
    return self;
}

-(void)useCustomNextResponder:(NSNotification*)n
{
    [customNextResponder becomeFirstResponder];
}

-(void)dealloc
{
    self.customNextResponder = nil;
    [super dealloc];
}

@end

#endif /*IS_IOS*/