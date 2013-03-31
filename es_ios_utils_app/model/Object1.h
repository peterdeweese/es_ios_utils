#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Object2.h"

@class Object3;

@interface Object1 : NSManagedObject { }

@property (nonatomic, strong) NSString *attribute1;
@property (nonatomic, strong) Object2  *object2;
@property (nonatomic, strong) NSSet    *object3s;

@end
