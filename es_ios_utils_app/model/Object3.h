#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@class Object1;

@interface Object3 : NSManagedObject { }

@property (nonatomic, strong) NSString *attribute3;
@property (nonatomic, strong) Object1  *parent;

@end
