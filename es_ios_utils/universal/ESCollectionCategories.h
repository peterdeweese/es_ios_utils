#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ESUtils.h"

// The class is here to force the linker to load categories
@interface ESCollectionCategories:NSObject
@end

typedef NSObject<NSFastEnumeration> ESCollection;

//TODO: How can I externilize these block type definitions?
typedef void(^EmptyBlock)();
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
    -(NSArray*)filteredArrayWhereKeyPath:(NSString*)keyPath equals:(id)object;
    -(NSArray*)filteredArrayWhereKeyPath:(NSString*)keyPath contains:(id)object;
    -(BOOL)isIndexInRange:(NSInteger)i;

    @property(readonly) NSArray*   arrayByRemovingLastObject;
    @property(readonly) NSArray*   reversed;
    @property(readonly) id         firstObject;
    @property(readonly) BOOL       isEmpty;
    @property(readonly) BOOL       isNotEmpty;
    @property(readonly) NSUInteger lastIndex;

    //Returns an array containing only the elements in set.  Ordering and duplication are preserved.
    -(NSArray*)filteredArrayUsingSet:(NSSet*)set;
    -(NSArray*)arrayOfChildrenWithKeyPath:(NSString*)keyPath;
    @property(readonly) NSSet*          asSet;
    @property(readonly) NSMutableSet*   asMutableSet;
    @property(readonly) NSMutableArray* asMutableArray;
@end

@interface NSDictionary(ESUtils)
+(NSDictionary*)dictionaryWithObjects:(ESCollection*)objects keyPathForKeys:(NSString*)keyPath;
+(NSDictionary*)dictionaryWithObjects:(ESCollection*)objects keyPathForKeys:(NSString*)keyPath keyPathForValues:(NSString*)valuePath;

    @property(readonly) BOOL          isEmpty;
    @property(readonly) BOOL          isNotEmpty;

    -(BOOL)containsValueForKey:(NSString*)key;

    @property(readonly) NSDictionary *asCamelCaseKeysFromUnderscore;
    @property(readonly) NSDictionary *asUnderscoreKeysFromCamelCase;

    @property(readonly) NSMutableDictionary *asMutableDictionary;

    // Iterates through dictionary, sub-arrays, and sub-dictionaries, performing a deep copy.
    // Makes copies of arrays and dictionaries, not other objects.
    @property(readonly) NSDictionary *asDeepCopy;

    // Adds keys to new dictionaries using keyFilter. If keyFilter generates duplicate non-unique keys, objects will be overwritten.
    -(NSDictionary*)asDeepCopyWithKeyFilter:(NSString*(^)(NSString*))keyFilter;


    //Wraps key object in an NSValue.
    -(id)objectForKeyObject:(id)key;
@end

// To enqueue or push, use addObject:
@interface NSMutableArray(ESUtils)
  @property(readonly) NSArray* asArray;

  // Removes and returns object from the beginning of the array, or nil if empty
  -(id)dequeue;

  // Removes and returns object from the end of the array, or nil if empty
  -(id)pop;

  -(void)replaceObject:(id)o withObject:(id)newO;
@end

@interface NSMutableDictionary(ESUtils)
  // Wraps key in +NSValue valueWithNonretainedObject:
  // Only use for keys that are not supported by setValue:forKey:
  -(void)setObject:(id)value forKeyObject:(id)key;
  -(void)setObjects:(ESCollection*)objects keyPathForKeys:(NSString*)keyPath;
  -(void)setObjects:(ESCollection*)objects keyPathForKeys:(NSString*)keyPath keyPathForValues:(NSString*)valuePath;

  //Changes keys using keyFilter. If keyFilter generates duplicate non-unique keys, objects will be overwritten.
  -(void)addEntriesFromDictionary:(NSDictionary*)d withKeyFilter:(NSString*(^)(NSString*))keyFilter;
  -(void)renameKey:(NSString*)key to:(NSString*)to;
@end

@interface NSMutableSet(ESUtils)
    -(void)removeObjects:(ESCollection*)objects;
@end

@interface NSNull(ESUtils)
    @property(readonly) BOOL isEmpty;
    @property(readonly) BOOL isNotEmpty;
@end

@interface NSSet(ESUtils)
    @property(readonly) BOOL          isEmpty;
    @property(readonly) BOOL          isNotEmpty;
    @property(readonly) NSArray*      asArray;
    @property(readonly) NSMutableSet* asMutableSet; //autoreleases, unlike mutableCopy

    -(NSArray*)sortedArrayByKey:(NSString*)key ascending:(BOOL)ascending;
@end