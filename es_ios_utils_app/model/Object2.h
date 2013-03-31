#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Object1;

@interface Object2 : NSManagedObject { }

@property (nonatomic, strong) NSString *attribute2;
@property (nonatomic, strong) Object1  *parent;

@end
