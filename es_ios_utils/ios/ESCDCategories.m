#import "ESCDCategories.h"

#if CORE_DATA_AVAILABLE

@implementation ESCDCategories
@end


@implementation NSError(ESCDCategories)

-(NSArray*)detailedErrors
{
    return [self.userInfo objectForKey:NSDetailedErrorsKey];
}

-(void)logDetailedErrors
{
    for(NSError *e in self.detailedErrors)
        [e logWithMessage:@"Detailed Error"];
    NSLog(@"User Info: %@", self.userInfo);
}

@end


@implementation NSFetchRequest(ESCDCategories)

+(NSFetchRequest*)fetchRequest { return [[[NSFetchRequest alloc] init] autorelease]; }

+(NSFetchRequest*)fetchRequestWithEntity:(NSEntityDescription*)entity
{
    NSFetchRequest* request = [self fetchRequest];
    request.entity = entity;
    return request;
}

+(NSFetchRequest*)fetchRequestForClass:(Class)c inManagedObjectContext:(NSManagedObjectContext*)context
{
    return [NSFetchRequest fetchRequestWithEntity:[NSEntityDescription entityForName:[NSString stringWithClassName:c] inManagedObjectContext:context]];
}

@end


#if IS_IOS

@implementation NSFetchedResultsController(ESCDCategories)

+(NSFetchedResultsController*)fetchedResultsControllerWithRequest:(NSFetchRequest*)request managedObjectContext:(NSManagedObjectContext*)context sectionNameKeyPath:(NSString*)sectionNameKeyPath cacheName:(NSString*)cacheName
{
    return [[[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:sectionNameKeyPath cacheName:cacheName] autorelease];
}

+(NSFetchedResultsController*)fetchedResultsControllerWithRequest:(NSFetchRequest*)request managedObjectContext:(NSManagedObjectContext*)context sectionNameKeyPath:(NSString*)sectionNameKeyPath
{
    return [self fetchedResultsControllerWithRequest:request managedObjectContext:context sectionNameKeyPath:sectionNameKeyPath cacheName:nil];
}

-(id)createManagedObject
{
    return [self.managedObjectContext createManagedObjectNamed:self.fetchRequest.entity.name];
}

-(BOOL)performFetchAndDoOnError:(ErrorBlock)doOnError
{
    NSError *error;
    BOOL result = [self performFetch:&error];
    
    if (!result)
        doOnError(error);
    
    return result;
}

@end

#endif //IS_IOS


@implementation NSManagedObject(ESCDCategories)

-(void)delete
{
    [self.managedObjectContext deleteObject:self];
}

-(id)copyWithAttributes
{
	id copied = [[self.class alloc] initWithEntity:self.entity
                    insertIntoManagedObjectContext:self.managedObjectContext];
    
	for(NSString *key in self.entity.attributesByName.allKeys)
		[copied setValue:[self valueForKey:key] forKey:key];
    
	return copied;
}

// Ignores missing keys in the target.  Skips relationships.
- (void)quietlySetValuesForKeysWithDictionary:(NSDictionary *)keyedValues
{
    for(NSString *key in keyedValues.allKeys)
    {
        @try
        {
            NSRelationshipDescription *rd = [self.entity.relationshipsByName objectForKey:key];
            NSString *value = [keyedValues objectForKey:key];
            if(value && ![value isKindOfClass:NSNull.class] && !rd)
                [self setValue:value forKey:key];
            else
                NSLog(@"Invalid key(%@) sent to object of type %@.", key, self.className);
        }
        @catch (NSException *e)
        {
            if(![e.name isEqualToString:@"NSUnknownKeyException"] && ![e.name isEqualToString:@"NSInvalidArgumentException"])
                @throw e;
            else
                NSLog(@"Invalid key(%@) sent to object of type %@.", key, self.className);
        }
    }
}

-(NSDictionary*)toDictionaryIgnoringReferencedObjects:(NSMutableSet*)objectsToIgnore relationshipFormat:(NSString*)relationshipFormat
{
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:10];
    
    [objectsToIgnore addObject:self];
    
    for (NSString *attribute in self.entity.attributesByName.allKeys)
    {
        id value = [self valueForKey:attribute];
        NSString *resultValue = nil;
        
        if(value)
        {
            if ([value isKindOfClass:NSString.class])
                resultValue = value;
            else if ([value respondsToSelector:@selector(stringValue)])
                resultValue = [value stringValue];
            else
                resultValue = $format(@"%@", value);
        }
        
        if(resultValue)
            [result setValue:resultValue forKey:attribute];
    }
    
    NSLog(@"%@", self);
    //Iterate through relationships.  Uses ordered<relationshipName> when available.
    for (NSString *relationship in self.entity.relationshipsByName)
    {
        NSRelationshipDescription *rd = [self.entity.relationshipsByName objectForKey:relationship];
        
        NSString *target = relationshipFormat ? $format(relationshipFormat, relationship) : relationship;
        
        if(rd.isToMany)
        {
            id<NSFastEnumeration> many = nil;
            @try
            {
                many = [self valueForKey:$format(@"ordered%@",relationship.asCapitalizedFirstLetter)];
                NSLog(@"Using ordered %@", relationship);
            }
            @catch (NSException *e)
            {
                if([e.name isEqualToString:@"NSUnknownKeyException"])
                {
                    many = [self valueForKey:relationship];
                    NSLog(@"Using unordered %@", relationship);
                }
                else
                    @throw e;
            }
            
            NSMutableArray *manyDictionaries = [NSMutableArray arrayWithCapacity:[((id)many) count]];
            for(NSManagedObject *o in many)
                if(![objectsToIgnore containsObject:o])
                    [manyDictionaries addObject:[o toDictionaryIgnoringReferencedObjects:objectsToIgnore relationshipFormat:relationshipFormat]];
            [result setValue:manyDictionaries forKey:target];
        }
        else
        {
            NSManagedObject *o = [self valueForKey:relationship];
            if(![objectsToIgnore containsObject:o])
                [result setValue:[o toDictionaryIgnoringReferencedObjects:objectsToIgnore relationshipFormat:relationshipFormat] forKey:target];
        }
    }
    
    return result;
}

-(NSDictionary*)toDictionaryIgnoringObjects:(NSSet*)objectsToIgnore
{
    NSMutableSet *references = objectsToIgnore ? objectsToIgnore.asMutableSet : [NSMutableSet setWithCapacity:10];
    return [self toDictionaryIgnoringReferencedObjects:references relationshipFormat:nil];
}

//Prevents circular dependencies.
-(NSDictionary*)toDictionary
{    
    return [self toDictionaryIgnoringObjects:nil];
}

-(NSDictionary*)toDictionaryForRailsIgnoringObjects:(NSSet*)objectsToIgnore
{
    NSMutableSet *references = objectsToIgnore ? objectsToIgnore.asMutableSet : [NSMutableSet setWithCapacity:10];
    return [self toDictionaryIgnoringReferencedObjects:references relationshipFormat:@"%@_attributes"].asUnderscoreKeysFromCamelCase;
}

-(NSDictionary*)toDictionaryForRails
{
    return [self toDictionaryForRailsIgnoringObjects:nil];
}

@end


@implementation NSManagedObjectContext(ESCDCategories)

-(id)createUninsertedManagedObjectOfClass:(Class)c
{
    return [[[c alloc] initWithEntity:[NSEntityDescription entityForName:[NSString stringWithClassName:c] inManagedObjectContext:self] insertIntoManagedObjectContext:nil] autorelease];
}

-(id)createManagedObjectNamed:(NSString*)name
{
    // Create a new instance of the entity managed by the fetched results controller.
    return [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:self];
}

-(id)createManagedObjectNamed:(NSString*)name withDictionary:(NSDictionary*)dictionary
{
    // Create a new instance of the entity managed by the fetched results controller.
    NSManagedObject *o = [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:self];
    [o quietlySetValuesForKeysWithDictionary:dictionary];
    return o;
}

-(id)createManagedObjectOfClass:(Class)c
{
    return [self createManagedObjectNamed:[NSString stringWithClassName:c]];
}

-(id)createManagedObjectOfClass:(Class)c withDictionary:(NSDictionary*)dictionary
{
    return [self createManagedObjectNamed:[NSString stringWithClassName:c] withDictionary:dictionary];
}

-(BOOL)saveAndDoOnError:(ErrorBlock)doOnError
{
    NSError *error;
    BOOL result = [self save:&error];
    
    if (!result)
        doOnError(error);
    
    return result;
}

-(NSArray*)fetch:(NSFetchRequest*)request
{
    NSError *error = nil;
    
    NSArray *results = [self executeFetchRequest:request error:&error];
    if (error)
        [error log];
    
    return results;      
}

-(NSArray*)fetch:(Class)type predicate:(NSPredicate*)predicate
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestForClass:type inManagedObjectContext:self];
    if(predicate)
        request.predicate = predicate;
    
    return [self fetch:request];     
}

//TODO: add varargs or array for predicate
//TODO: shouldn't this be a set?
-(NSArray*)fetch:(Class)type predicateWithFormat:(NSString*)predicate arg:(id)arg
{
    return [self fetch:type predicate:predicate ? [NSPredicate predicateWithFormat:predicate, arg] : nil];   
}

-(BOOL)hasAny:(Class)type
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestForClass:type inManagedObjectContext:self];
    request.fetchLimit = 1;
    
    return [self fetch:request].isNotEmpty;
}

//REFACTOR: rename to fetchAll or fetch
-(NSArray*)all:(Class)type
{
    return [self fetch:type predicateWithFormat:nil arg:nil];
}

-(NSArray*)all:(Class)type sortedByKey:(NSString*)key
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestForClass:type inManagedObjectContext:self];
    request.sortDescriptors = $array([NSSortDescriptor sortDescriptorWithKey:key ascending:YES]);
    
    return [self fetch:request];
}

@end

#endif //CORE_DATA_AVAILABLE
