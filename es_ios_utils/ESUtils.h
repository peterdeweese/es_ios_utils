#import "ESCollectionCategories.h"
#import "ESCGMethods.h"
#import "TargetConditionals.h"

#if  TARGET_OS_MAC && !TARGET_OS_IPHONE
  #define IS_MAC 1
  #define IS_IOS 0
#elif TARGET_OS_IPHONE
  #define IS_MAC 0
  #define IS_IOS 1
#endif

#if IS_IOS
  #import <Foundation/Foundation.h>

  #import "ESNSCategories.h"
  #import "ESUICategories.h"
  #import "ESMKCategories.h"
#endif

#if IS_MAC
  #import "ESMacNSCategories.h"
#endif

#define $array(objs...) [NSArray arrayWithObjects: objs, nil] 
#define $set(objs...) [NSSet setWithObjects: objs, nil] 
#define $format(format, objs...) [NSString stringWithFormat: format, objs]

#define $must_override [NSException raise:NSInternalInconsistencyException format:@"You must override %@", NSStringFromSelector(_cmd)];

@interface ESUtils : NSObject { }

@end
