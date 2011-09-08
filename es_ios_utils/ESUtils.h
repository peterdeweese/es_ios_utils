#ifdef TARGET_OS_IPHONE

#import <Foundation/Foundation.h>

#import "ESNSCategories.h"
#import "ESUICategories.h"
#import "ESMKCategories.h"

#endif

#import "ESCollectionCategories.h"

#define $array(objs...) [NSArray arrayWithObjects: objs, nil] 
#define $set(objs...) [NSSet setWithObjects: objs, nil] 
#define $format(format, objs...) [NSString stringWithFormat: format, objs]

#define $must_override [NSException raise:NSInternalInconsistencyException format:@"You must override %@", NSStringFromSelector(_cmd)];

@interface ESUtils : NSObject { }

@end
