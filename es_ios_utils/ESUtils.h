#import "ESCollectionCategories.h"
#import "ESCGMethods.h"
#import "TargetConditionals.h"

#if USE_APPLICATION_UNIT_TEST
  #define IS_MAC 0
  #define IS_IOS 1
#elif  TARGET_OS_MAC && !TARGET_OS_IPHONE
  #define IS_MAC 1
  #define IS_IOS 0
  #ifdef _COREDATADEFINES_H
    #define CORE_DATA_AVAILABLE 1
  #endif
#elif TARGET_OS_IPHONE
  #define IS_MAC 0
  #define IS_IOS 1
#ifdef _COREDATADEFINES_H
    #define CORE_DATA_AVAILABLE 1
  #endif
#endif

#if IS_IOS
  #import <Foundation/Foundation.h>

  #import "ESUICategories.h"
#endif

#if IS_MAC
  #import "ESMacNSCategories.h"
#endif

#import "ESNSCategories.h"
#import "ESCollectionCategories.h"

#define $array(objs...) [NSArray arrayWithObjects: objs, nil] 
#define $set(objs...) [NSSet setWithObjects: objs, nil] 
#define $format(format, objs...) [NSString stringWithFormat: format, objs]
#define $bself __block typeof(self) bself = self

#define $must_override [NSException raise:NSInternalInconsistencyException format:@"You must override %@", NSStringFromSelector(_cmd)];

@interface ES : NSObject
  +(NSString*)typeNameStringForProperty:(NSString*)propertyName inClass:(Class)c;
  +(BOOL)isPropertyADouble:(NSString*)propertyName inClass:(Class)c;
@end
