#import "ESDynamicMethodResolver.h"

// For read-write, send an NSMutableDictionary to initWithDictionary
@interface ESBoundDictionary : ESDynamicMethodResolver
  -(id)initWithDictionary:(NSDictionary*)d;

  @property(nonatomic, retain) NSDictionary* dictionary;
@end
