#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Object1;

@interface Object2 : NSManagedObject { }

@property (nonatomic, retain) NSString *attribute2;
@property (nonatomic, retain) Object1  *parent;

@end
