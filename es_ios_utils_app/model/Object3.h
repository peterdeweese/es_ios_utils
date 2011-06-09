#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@class Object1;

@interface Object3 : NSManagedObject { }

@property (nonatomic, retain) NSString *attribute3;
@property (nonatomic, retain) Object1  *parent;

@end
