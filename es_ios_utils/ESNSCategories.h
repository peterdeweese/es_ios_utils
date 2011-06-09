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
    // Each argument is added to the new array. If an argument is a collection, each item from the collection is added
    // to the array.
    +(NSArray*)arrayByCoalescing:(id)firstObject, ... NS_REQUIRES_NIL_TERMINATION;
    -(NSArray*)arrayByRemovingObject:(id)anObject;

    // Analog of ruby's: ["one", "two"].map { |str| "(#{str})" }
    // [array arrayMappedWithFormat:@"(%@)"]
    // @returns an array of formatted NSStrings.
    -(NSArray*)arrayMappedWithFormat:(NSString*)format;
    -(NSArray*)arrayMappedWith:(id(^)(id))mapper;

    @property(readonly) id         firstObject;
    @property(readonly) BOOL       isEmpty;
    @property(readonly) BOOL       isNotEmpty;
    @property(readonly) NSUInteger lastIndex;

    //Returns an array containing only the elements in set.  Ordering and duplication are preserved.
    -(NSArray*)filteredArrayUsingSet:(NSSet*)set;
    -(NSArray*)arrayOfChildrenWithKeyPath:(NSString*)keyPath;
    @property(readonly) NSSet *asSet;
@end

@interface NSDate(ESUtils)
    -(NSDate*)dateByAddingDays:(int)d;
    -(NSDate*)dateByAddingHours:(int)h;
    -(NSDate*)dateByAddingMinutes:(int)m;
    -(NSDate*)dateByAddingSeconds:(int)s;
    -(NSString*)relativeString;
@end

@interface NSDictionary(ESUtils)
    @property(readonly) BOOL          isEmpty;
    @property(readonly) BOOL          isNotEmpty;
    @property(readonly) NSDictionary *asCamelCaseKeysFromUnderscore;
    @property(readonly) NSDictionary *asUnderscoreKeysFromCamelCase;

    // Iterates through dictionary, sub-arrays, and sub-dictionaries, performing a deep copy.
    // Makes copies of arrays and dictionaries, not other objects.
    @property(readonly) NSDictionary *asDeepCopy;

    // Adds keys to new dictionaries using keyFilter. If keyFilter generates duplicate non-unique keys, objects will be overwritten.
    -(NSDictionary*)asDeepCopyWithKeyFilter:(NSString*(^)(NSString*))keyFilter;


    //Wraps key object in an NSValue.
    -(id)objectForKeyObject:(id)key;
@end

@interface NSError(ESUtils)
    @property(nonatomic, readonly) NSArray *detailedErrors;
    -(void)log;
    -(void)logDetailedErrors;
    -(void)logWithMessage:(NSString*)message;
@end

@interface NSFetchedResultsController(ESUtils)
    // Create and save a new instance of the entity managed by the fetched results controller.
    -(NSManagedObject*)createManagedObject;

    -(BOOL)performFetchAndDoOnError:(ErrorBlock)doOnError;
@end

@interface NSManagedObject(ESUtils)
    -(void)delete;
    
    //Creates a new managed object and performs a shallow copy, ignoring all relationships
    @property(nonatomic, readonly) id        copyWithAttributes;

    @property(nonatomic, readonly) NSString *xmlString;
@end

@interface NSManagedObjectContext(ESUtils)
    -(NSManagedObject*)createManagedObjectNamed:(NSString*)name;
    -(NSManagedObject*)createManagedObjectNamed:(NSString*)name withDictionary:(NSDictionary*)dictionary;
    -(NSManagedObject*)createManagedObjectOfClass:(Class)c;
    -(NSManagedObject*)createManagedObjectOfClass:(Class)c withDictionary:(NSDictionary*)dictionary;
    
    // Creates object from ajson style dictionary, that is, the top level dictionary contains a key with the type name mapped to a dictionary with attributes.  Underscore delimited names are converted to camel-case.  To customize key mapping for a specific managed object, override -(void)quietlySetValuesForKeysWithDictionary:(NSDictionary *)keyedValues;
    -(NSManagedObject*)createManagedObjectWithJSONDictionary:(NSDictionary*)dictionary;

    -(BOOL)saveAndDoOnError:(ErrorBlock)doOnError;
    -(BOOL)hasAny:(Class)type;
    -(NSArray*)all:(Class)type;
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
    
    //Changes keys using keyFilter. If keyFilter generates duplicate non-unique keys, objects will be overwritten.
    -(void)addEntriesFromDictionary:(NSDictionary*)d withKeyFilter:(NSString*(^)(NSString*))keyFilter;
@end

@interface NSNull(ESUtils)
    @property(readonly) BOOL isEmpty;
    @property(readonly) BOOL isNotEmpty;
@end

@interface NSObject(ESUtils)
    @property(readonly) NSString *className;
@end

@interface NSRegularExpression(ESUtils)
    -(BOOL)matches:(NSString*)string;
@end

@interface NSSet(ESUtils)
    @property(readonly) BOOL isEmpty;
    @property(readonly) BOOL isNotEmpty;
    @property(readonly) NSArray *asArray;
    -(NSArray*)sortedArrayByKey:(NSString*)key ascending:(BOOL)ascending;
@end

@interface NSString(ESUtils)
    //Formats like 576B, 5.6MB
    +(NSString*)stringWithFormattedFileSize:(unsigned long long)byteLength;
    +(NSString*)stringWithClassName:(Class)c;

    @property(nonatomic, readonly) NSData   *dataWithUTF8;
    @property(nonatomic, readonly) NSString *strip;

    //Returns true if the string exists and contains only whitespace.
    @property(nonatomic, readonly) BOOL      isBlank;
    //Checks if a string exists and is not blank.  Preferred over isBlank because existance doesn't need to be checked.
    @property(nonatomic, readonly) BOOL      isPresent;

    @property(nonatomic, readonly) BOOL      isEmpty;
    @property(nonatomic, readonly) BOOL      isNotEmpty;

    @property(nonatomic, readonly) NSString *asCamelCaseFromUnderscore;
    @property(nonatomic, readonly) NSString *asUnderscoreFromCamelCase;
@end

@interface NSThread(ESUtils)
    +(void)detachNewThreadBlock:(ESEmptyBlock)block;
@end