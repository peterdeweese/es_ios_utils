#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ESUtils.h"

#if CORE_DATA_AVAILABLE

// The class is here to force the linker to load categories
@interface ESCDCategories : NSObject
@end

@interface NSError(ESCDCategories)
  @property(nonatomic, readonly) NSArray *detailedErrors;
  -(void)logDetailedErrors;
@end

@interface NSFetchRequest(ESCDCategories)
  +(NSFetchRequest*)fetchRequest;
  +(NSFetchRequest*)fetchRequestWithEntity:(NSEntityDescription*)entity;
  +(NSFetchRequest*)fetchRequestForClass:(Class)c inManagedObjectContext:(NSManagedObjectContext*)context;
@end

#if IS_IOS

@interface NSFetchedResultsController(ESCDCategories)
  +(NSFetchedResultsController*)fetchedResultsControllerWithRequest:(NSFetchRequest*)request managedObjectContext:(NSManagedObjectContext*)context sectionNameKeyPath:(NSString*)sectionNameKeyPath cacheName:(NSString*)cacheName;
  +(NSFetchedResultsController*)fetchedResultsControllerWithRequest:(NSFetchRequest*)request managedObjectContext:(NSManagedObjectContext*)context sectionNameKeyPath:(NSString*)sectionNameKeyPath;

  // Create and save a new instance of the entity managed by the fetched results controller.
  -(id)createManagedObject;
  -(BOOL)performFetchAndDoOnError:(ErrorBlock)doOnError;
@end

#endif //IS_IOS

@interface NSManagedObject(ESCDCategories)
  -(void)delete;
  //Creates a new managed object and performs a shallow copy, ignoring all relationships
  @property(nonatomic, readonly) id        copyWithAttributes;

  //Coerces all attributes into string values.  If a relationship has a method in the form of ordered<Relationship>, that key will be used.  To-many relationships represented as NSArrays.  Circular dependencies prevented by only representing each NSManagedObject once. The first node to be processed wins, and this produces a tree.
  @property(nonatomic, readonly) NSDictionary *toDictionary;

  //Use this when overriding toDictionary to prevent references from being added.
  -(NSDictionary*)toDictionaryIgnoringObjects:(NSSet*)objectsToIgnore;

  //Rails uses <relationship>_attributes and underscores
  -(NSDictionary*)toDictionaryForRailsIgnoringObjects:(NSSet *)objectsToIgnore;
  -(NSDictionary*)toDictionaryForRails;
@end

@interface NSManagedObjectContext(ESCDCategories)
  -(id)createUninsertedManagedObjectOfClass:(Class)c;
  -(id)createManagedObjectNamed:(NSString*)name;
  -(id)createManagedObjectNamed:(NSString*)name withDictionary:(NSDictionary*)dictionary;
  -(id)createManagedObjectOfClass:(Class)c;
  -(id)createManagedObjectOfClass:(Class)c withDictionary:(NSDictionary*)dictionary;

  -(BOOL)saveAndDoOnError:(ErrorBlock)doOnError;
  -(NSArray*)fetch:(NSFetchRequest*)request;
  -(NSArray*)fetch:(Class)type predicate:(NSPredicate*)predicate;
  -(NSArray*)fetch:(Class)type predicateWithFormat:(NSString*)predicate arg:(id)arg;
  -(BOOL)hasAny:(Class)type;
  -(NSArray*)all:(Class)type;
  -(NSArray*)all:(Class)type sortedByKey:(NSString*)key;
@end

#endif //CORE_DATA_AVAILABLE
