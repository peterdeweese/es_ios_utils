
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ESUtils.h"

// The class is here to force the linker to load categories
@interface ESNSCategories:NSObject
@end

typedef void(^ESEmptyBlock)();
typedef void(^ErrorBlock)(NSError*);

@interface NSDate(ESUtils)
  @property(nonatomic, readonly) NSString* asStringWithShortFormat;
  @property(nonatomic, readonly) NSString* asRelativeString;

  -(BOOL)isBefore:(NSDate*)d;
  -(BOOL)isAfter:(NSDate*)d;
  @property(nonatomic, readonly) BOOL      isPast;
  @property(nonatomic, readonly) BOOL      isFuture;

  -(NSDate*)dateByAddingDays:(int)d;
  -(NSDate*)dateByAddingHours:(int)h;
  -(NSDate*)dateByAddingMinutes:(int)m;
  -(NSDate*)dateByAddingSeconds:(int)s;

  @property(nonatomic, readonly) NSInteger hour;
  @property(nonatomic, readonly) NSInteger minute;
  @property(nonatomic, readonly) NSInteger second;
@end

@interface NSDecimalNumber(ESUtils)
  @property(nonatomic, readonly) BOOL isNotANumber;
@end

@interface NSError(ESUtils)
    @property(nonatomic, readonly) NSArray *detailedErrors;
    -(void)log;
    -(void)logDetailedErrors;
    -(void)logWithMessage:(NSString*)message;
@end

@interface NSFetchRequest(ESUtils)
  +(NSFetchRequest*)fetchRequest;
  +(NSFetchRequest*)fetchRequestWithEntity:(NSEntityDescription*)entity;
  +(NSFetchRequest*)fetchRequestForClass:(Class)c inManagedObjectContext:(NSManagedObjectContext*)context;
@end

#if IS_IOS

@interface NSFetchedResultsController(ESUtils)
    +(NSFetchedResultsController*)fetchedResultsControllerWithRequest:(NSFetchRequest*)request managedObjectContext:(NSManagedObjectContext*)context sectionNameKeyPath:(NSString*)sectionNameKeyPath cacheName:(NSString*)cacheName;
    +(NSFetchedResultsController*)fetchedResultsControllerWithRequest:(NSFetchRequest*)request managedObjectContext:(NSManagedObjectContext*)context sectionNameKeyPath:(NSString*)sectionNameKeyPath;

    // Create and save a new instance of the entity managed by the fetched results controller.
    -(NSManagedObject*)createManagedObject;

    -(BOOL)performFetchAndDoOnError:(ErrorBlock)doOnError;
@end

#endif //IS_IOS

@interface NSManagedObject(ESUtils)
    -(void)delete;
    
    //Creates a new managed object and performs a shallow copy, ignoring all relationships
    @property(nonatomic, readonly) id        copyWithAttributes;

    @property(nonatomic, readonly) NSString     *xmlString;

    //Coerces all attributes into string values.  If a relationship has a method in the form of ordered<Relationship>, that key will be used.  To-many relationships represented as NSArrays.  Circular dependencies prevented by only representing each NSManagedObject once. The first node to be processed wins, and this produces a tree.
    @property(nonatomic, readonly) NSDictionary *toDictionary;

    //Use this when overriding toDictionary to prevent references from being added.
    -(NSDictionary*)toDictionaryIgnoringObjects:(NSSet*)objectsToIgnore;

    //Rails uses <relationship>_attributes and underscores
    -(NSDictionary*)toDictionaryForRailsIgnoringObjects:(NSSet *)objectsToIgnore;
    -(NSDictionary*)toDictionaryForRails;
@end

@interface NSManagedObjectContext(ESUtils)
    -(NSManagedObject*)createManagedObjectNamed:(NSString*)name;
    -(NSManagedObject*)createManagedObjectNamed:(NSString*)name withDictionary:(NSDictionary*)dictionary;
    -(NSManagedObject*)createManagedObjectOfClass:(Class)c;
    -(NSManagedObject*)createManagedObjectOfClass:(Class)c withDictionary:(NSDictionary*)dictionary;

    -(BOOL)saveAndDoOnError:(ErrorBlock)doOnError;
    -(NSArray*)fetch:(NSFetchRequest*)request;
    -(NSArray*)fetch:(Class)type predicate:(NSPredicate*)predicate;
    -(NSArray*)fetch:(Class)type predicateWithFormat:(NSString*)predicate arg:(id)arg;
    -(BOOL)hasAny:(Class)type;
    -(NSArray*)all:(Class)type;
    -(NSArray*)all:(Class)type sortedByKey:(NSString*)key;
@end

@interface NSObject(ESUtils)
    @property(readonly) NSString *className;
@end

@interface NSRegularExpression(ESUtils)
    -(BOOL)matches:(NSString*)string;
@end

@interface NSString(ESUtils)
    //Formats like 576B, 5.6MB
    +(NSString*)stringWithFormattedFileSize:(unsigned long long)byteLength;
    +(NSString*)stringWithClassName:(Class)c;
    +(NSString*)stringWithUUID;

    @property(nonatomic, readonly) NSData   *dataWithUTF8;
    @property(nonatomic, readonly) NSString *strip;
    -(BOOL)containsString:(NSString*)substring;

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
