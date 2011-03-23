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
    @property(readonly) id   firstObject;
    @property(readonly) BOOL isEmpty;
    @property(readonly) BOOL isNotEmpty;
@end

@interface NSDictionary(ESUtils)
    @property(readonly) BOOL isEmpty;
    @property(readonly) BOOL isNotEmpty;
@end

@interface NSError(ESUtils)
    -(void)log;
    -(void)logWithMessage:(NSString*)message;
@end

@interface NSFetchedResultsController(ESUtils)
    // Create and save a new instance of the entity managed by the fetched results controller.
    -(NSManagedObject*)createManagedObject;
@end

//  Created by Scott Means on 1/5/11.
//  http://smeans.com/2011/01/07/exporting-from-core-data-on-ios/
//  Released into the public domain without warranty.
@interface NSManagedObject(ESUtils)
    @property (nonatomic, readonly) NSString *xmlString;
@end

@interface NSManagedObjectContext(ESUtils)
    -(NSManagedObject*)createManagedObjectNamed:(NSString*)name;
    -(BOOL)saveAndDoOnError:(ErrorBlock)doOnError;
@end

// To enqueue or push, use addObject:
@interface NSMutableArray(ESUtils)
    // Removes and returns object from the beginning of the array, or nil if empty
    -(id)dequeue;

    // Removes and returns object from the end of the array, or nil if empty
    -(id)pop;
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
