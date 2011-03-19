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

@interface NSError(ESUtils)
    -(void)log;
    -(void)logWithMessage:(NSString*)message;
@end

@interface NSFetchedResultsController(ESUtils)
    // Create and save a new instance of the entity managed by the fetched results controller.
    -(NSManagedObject*)createAndSaveManagedObject:(ESNSManagedObjectBlock)configure doOnError:(ErrorBlock)e;
@end

@interface NSManagedObjectContext(ESUtils)
- (BOOL)saveAndDoOnError:(ErrorBlock)doOnError;
@end

// To enqueue or push, use addObject:
@interface NSMutableArray(ESUtils)
    // Removes and returns object from the beginning of the array, or nil if empty
    - (id)dequeue;

    // Removes and returns object from the end of the array, or nil if empty
    - (id)pop;
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
    @property(readonly) NSString *strip;
    @property(readonly) BOOL      isBlank;
    @property(readonly) BOOL      isEmpty;
    @property(readonly) BOOL      isNotEmpty;
@end
