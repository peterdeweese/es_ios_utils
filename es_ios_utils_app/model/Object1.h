#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Object2.h"

@class Object3;

@interface Object1 : NSManagedObject { }

@property (nonatomic, retain) NSString *attribute1;
@property (nonatomic, retain) Object2  *child;
@property (nonatomic, retain) NSSet    *children;

@end
