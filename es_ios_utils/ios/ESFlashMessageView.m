#if IS_IOS

#import "ESFlashMessageView.h"

#import <QuartzCore/QuartzCore.h>

@interface ESFlashMessageView()
    @property(nonatomic, retain) NSMutableArray* queue;
    @property(nonatomic, retain) NSTimer*        timer;
@end


@implementation ESFlashMessageView

@synthesize fadeDuration, maxAlpha;
@synthesize /* private */ queue, timer;

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.queue = [NSMutableArray arrayWithCapacity:20];
        self.fadeDuration = 0.5;
        self.maxAlpha = 0.8;
        
        self.cornerRadius = 15;
        self.textAlignment = UITextAlignmentCenter;
        self.alpha = 0.0;
        self.backgroundColor = UIColor.darkGrayColor;
        self.textColor = UIColor.whiteColor;
        self.autoresizingMask = ( UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin );
        self.numberOfLines = 0;
    }
    
    return self;
}

- (void)dealloc
{
    self.queue = nil;
    self.timer = nil;
    
    [super dealloc];
}

-(void)addMessage:(NSString*)message
{
    @synchronized(queue)
    {            
        [queue addObject:message];
    }
}

-(void)displayNextMessage:(NSTimer*)t
{
    @synchronized(queue)
    {
        __block NSString *message = queue.dequeue;
        
        if(message)
        {
            NSLog(@"Setting flash message: %@", message);
            if(self.alpha == 0.0)
                self.text = message;
            __block typeof(self) bself = self;
            [UIView animateWithDuration:fadeDuration
                             animations:^{
                                 bself.text = message;
                                 bself.alpha = bself.maxAlpha;
                             }];
        }
        else if(self.alpha >= maxAlpha)
        {
            __block typeof(self) bself = self;
            [UIView animateWithDuration:fadeDuration
                             animations:^{
                                 bself.alpha = 0.0;
                             }];
        }
    }
}

-(void)start
{
    if(!self.timer)
    {
        self.timer = [NSTimer timerWithTimeInterval:self.fadeDuration * 4.0
                                             target:self
                                           selector:@selector(displayNextMessage:)
                                           userInfo:nil
                                            repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer: self.timer forMode: NSDefaultRunLoopMode];
    }
}

-(void)stop
{
    [self.timer invalidate];
    self.timer = nil;
}

@end

#endif //IS_IOS