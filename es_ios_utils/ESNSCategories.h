//
//  NSCategories.h
//  es_ios_utils
//
//  Created by Peter DeWeese on 3/16/11.
//  Copyright 2011 Eye Street Research, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ESUtils.h"

typedef void(^ESEmptyBlock)();

// The class is here to force the linker to load categories
@interface ESNSCategories:NSObject
{
}
@end

//TODO: How can I externilize these block type definitions?
typedef void(^EmptyBlock)();
typedef void(^ErrorBlock)(NSError*);
typedef void(^ESNSManagedObjectBlock)(NSManagedObject*);

@interface NSArray(ESUtils)
    @property(readonly) id         firstObject;
    @property(readonly) BOOL       isEmpty;
    @property(readonly) BOOL       isNotEmpty;
    @property(readonly) NSUInteger lastIndex;
    //Returns an array containing only the elements in set.  Ordering and duplication are preserved.
    -(NSArray*)filteredArrayUsingSet:(NSSet*)set;
@end

@interface NSDate(ESUtils)
    -(NSDate*)dateByAddingDays:(int)d;
    -(NSDate*)dateByAddingHours:(int)h;
    -(NSDate*)dateByAddingMinutes:(int)m;
    -(NSDate*)dateByAddingSeconds:(int)s;
    -(NSString*)relativeString;
@end

@interface NSDictionary(ESUtils)
    @property(readonly) BOOL isEmpty;
    @property(readonly) BOOL isNotEmpty;

    //Wraps key object in an NSValue.
    -(id)objectForKeyObject:(id)key;
@end

@interface NSError(ESUtils)
    -(void)log;
    -(void)logWithMessage:(NSString*)message;
@end

@interface NSFetchedResultsController(ESUtils)
    // Create and save a new instance of the entity managed by the fetched results controller.
    -(NSManagedObject*)createManagedObject;

    -(BOOL)performFetchAndDoOnError:(ErrorBlock)doOnError;
@end

//  Created by Scott Means on 1/5/11.
//  http://smeans.com/2011/01/07/exporting-from-core-data-on-ios/
//  Released into the public domain without warranty.
@interface NSManagedObject(ESUtils)
    -(void)delete;
    @property (nonatomic, readonly) NSString *xmlString;
@end

@interface NSManagedObjectContext(ESUtils)
    -(NSManagedObject*)createManagedObjectNamed:(NSString*)name;
-(NSManagedObject*)createManagedObjectOfClass:(Class)c;
    -(BOOL)saveAndDoOnError:(ErrorBlock)doOnError;
@end

// To enqueue or push, use addObject:
@interface NSMutableArray(ESUtils)
    // Removes and returns object from the beginning of the array, or nil if empty
    -(id)dequeue;

    // Removes and returns object from the end of the array, or nil if empty
    -(id)pop;
@end

@interface NSMutableDictionary(ESUtils)
    // Wraps key in +NSValue valueWithNonretainedObject:
    // Only use for keys that are not supported by setValue:forKey:
    -(void)setObject:(id)value forKeyObject:(id)key;
@end

@interface NSNull(ESUtils)
    @property(readonly) BOOL isEmpty;
    @property(readonly) BOOL isNotEmpty;
@end

@interface NSSet(ESUtils)
    @property(readonly) BOOL isEmpty;
    @property(readonly) BOOL isNotEmpty;
@end

@interface NSString (ESUtils)
    @property(nonatomic, readonly) NSData   *dataWithUTF8;
    @property(nonatomic, readonly) NSString *strip;
    @property(nonatomic, readonly) BOOL      isBlank;
    @property(nonatomic, readonly) BOOL      isEmpty;
    @property(nonatomic, readonly) BOOL      isNotEmpty;
@end

@interface NSThread(ESUtils)
    +(void)detachNewThreadBlock:(ESEmptyBlock)block;
@end