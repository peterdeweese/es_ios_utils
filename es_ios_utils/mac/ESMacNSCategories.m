#if IS_MAC

#import "ESNSCategories.h"

@implementation ESMacNSCategories
@end

@implementation NSFont(ESUtils)

-(NSFont*)fontSizedForAreaSize:(NSSize)size withString:(NSString*)string
{
    NSFont* sampleFont = [NSFont fontWithDescriptor:self.fontDescriptor size:12.];//use standard size to prevent error accrual
    CGSize sampleSize = [string sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:sampleFont, NSFontAttributeName, nil]];
    float scale = [CG scaleToAspectFit:sampleSize into:size padding:0.02];
    return [NSFont fontWithDescriptor:self.fontDescriptor size:scale * sampleFont.pointSize];
}

@end

@implementation NSWindowController(ESUtils)
  -(NSString *)windowNibName { return self.className; }
@end

@implementation NSWorkspace(ESUtils)

-(BOOL)openURLWithString:(NSString*)url
{
    return [self openURL:[NSURL URLWithString:url]];
}

@end

#endif //IS_MAC