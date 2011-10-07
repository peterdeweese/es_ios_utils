#import "ESNSCategories.h"
#import <objc/runtime.h>

@implementation ESNSCategories
@end


@implementation NSDate(ESUtils)

-(NSString*)asStringWithShortFormat
{
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    
    formatter.timeStyle = NSDateFormatterShortStyle;
    formatter.dateStyle = NSDateFormatterShortStyle;
    
    return [formatter stringFromDate:self];
}

-(NSString*)asRelativeString
{
    NSDateFormatter *f = [[[NSDateFormatter alloc] init] autorelease];
    f.timeStyle = NSDateFormatterNoStyle;
    f.dateStyle = NSDateFormatterMediumStyle;
    f.locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease];
    f.doesRelativeDateFormatting=YES;
    
    return [f stringForObjectValue:self];
}

-(BOOL)isAfter:(NSDate*)d
{
    return [self compare:d] == NSOrderedDescending;
}

-(BOOL)isBefore:(NSDate*)d
{
    return [self compare:d] == NSOrderedAscending;
}

-(BOOL)isPast
{
    return [self isBefore:NSDate.date];
}

-(BOOL)isFuture
{
    return [self isAfter:NSDate.date];
}

-(NSDate*)dateByAddingDays:(int)d
{
    return [self dateByAddingTimeInterval:d * 24 * 60 * 60];
}

-(NSDate*)dateByAddingHours:(int)h
{
    return [self dateByAddingTimeInterval:h * 60 * 60];
}

-(NSDate*)dateByAddingMinutes:(int)m
{
    return [self dateByAddingTimeInterval:m * 60];
}

-(NSDate*)dateByAddingSeconds:(int)s
{
    return [self dateByAddingTimeInterval:s];
}

-(NSInteger)hour
{
    return [[NSCalendar currentCalendar] components:kCFCalendarUnitHour fromDate:self].hour;
}

-(NSInteger)minute
{
    return [[NSCalendar currentCalendar] components:kCFCalendarUnitMinute fromDate:self].minute;
}

-(NSInteger)second
{
    return [[NSCalendar currentCalendar] components:kCFCalendarUnitSecond fromDate:self].second;
}

@end


@implementation NSDecimalNumber(ESUtils)

-(BOOL)isNotANumber
{
    return [[NSDecimalNumber notANumber] isEqualToNumber:self];
}

@end


@implementation NSError(ESUtils)

#if CORE_DATA_AVAILABLE

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

#endif //CORE_DATA_AVAILABLE

-(void)log
{
    NSLog(@"%@", self.localizedDescription);
}

-(void)logWithMessage:(NSString*)message
{
    NSLog(@"%@ - %@", message, self);
}

@end

#if CORE_DATA_AVAILABLE

@implementation NSFetchRequest(ESUtils)

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

@implementation NSFetchedResultsController(ESUtils)

+(NSFetchedResultsController*)fetchedResultsControllerWithRequest:(NSFetchRequest*)request managedObjectContext:(NSManagedObjectContext*)context sectionNameKeyPath:(NSString*)sectionNameKeyPath cacheName:(NSString*)cacheName
{
    return [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:sectionNameKeyPath cacheName:cacheName] ;
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


@implementation NSManagedObject(ESUtils)

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

//  Created by Scott Means on 1/5/11.
//  http://smeans.com/2011/01/07/exporting-from-core-data-on-ios/
//  Released into the public domain without warranty.
//  TODO: a libxml or nsxml implementation may be more appropriate.
//  Modified to include one-to-one relationships and to prevent inverses causing circular references.
- (NSString *)xmlString:(NSMutableSet*)referenced
{
    if([referenced containsObject:self])
        return [NSString string];
    else
        [referenced addObject:self];
    
    NSEntityDescription *ed = self.entity;
    NSURL *uri = self.objectID.URIRepresentation;
    NSMutableString *x = [NSMutableString stringWithFormat:@"<%@ id=\"/%@%@\"",
                          ed.name.lowercaseString, uri.host, uri.path];
    
    for (NSString *a in ed.attributesByName.allKeys)
    {
        id value = [self valueForKey:a];
        
        if (value)
        {
            if ([value isKindOfClass:NSString.class])
                [x appendFormat:@" %@=\"%@\"", a, value];
            else
            {
                if (![value respondsToSelector:@selector(stringValue)])
                    NSLog(@"no stringValue");

                [x appendFormat:@" %@=\"%@\"", a, [value stringValue]];
            }
        }
    }
    
    bool hasChildren = ed.relationshipsByName.isNotEmpty;

    [x appendString:hasChildren ? @">" : @"/>"];
    
    for (NSString *r in ed.relationshipsByName)
    {
        NSRelationshipDescription *rd = [ed.relationshipsByName objectForKey:r];

        if(rd.isToMany)
        {
            hasChildren = YES;
            [x appendFormat:@"<%@>", r];
            
            for (NSManagedObject *c in [self valueForKey:r])
                [x appendString:[c xmlString:referenced]];
            
            [x appendFormat:@"", r];
        }
        else
        {
            hasChildren = YES;
            NSManagedObject *c = [self valueForKey:r];
            [x appendString:[c xmlString:referenced]];
        }
    }
    
    if (hasChildren)
        [x appendFormat:@"</%@>", ed.name.lowercaseString];
    
    return x;
}

//Prevents circular dependencies.
-(NSString*)xmlString
{
    return [self xmlString:[[[NSMutableSet alloc] init] autorelease]];
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
                many = [self valueForKey:$format(@"ordered%@",relationship.capitalizedString)];
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


@implementation NSManagedObjectContext(ESUtils)

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

@implementation NSObject(ESUtils)

-(NSString*)className
{
    return [NSString stringWithClassName:self.class];
}

@end


@implementation NSRegularExpression(ESUtils)

-(BOOL)matches:(NSString*)string
{
    return [self rangeOfFirstMatchInString:string options:0 range:NSMakeRange(0, string.length)].location != NSNotFound;
}

@end


@implementation NSString(ESUtils)

-(NSMutableString*)asMutableString
{
    return [self.mutableCopy autorelease];
}

//REFACTOR: consider pulling up into a math util library
float logx(float value, float base);
float logx(float value, float base) 
{
    return log10f(value) / log10f(base);
}

+(NSString*)stringWithFormattedFileSize:(unsigned long long)byteLength
{
    if(byteLength == 0)
        return @"0 B";
    //REFACTOR: consider storing for reuse
    NSArray *labels = $array(@"B", @"KB", @"MB", @"GB", @"TB");
    
    int power = MIN(labels.count-1, floor(logx(byteLength, 1024)));
    float size = (float)byteLength/powf(1024, power);
    
    return $format(@"%@ %@",
                   power?$format(@"%1.1f",size):$format(@"%i",byteLength),
                   [labels objectAtIndex:power]);
}

+(NSString*)stringWithClassName:(Class)c
{
    return [NSString stringWithUTF8String:class_getName(c)];
}

+(NSString*)stringWithUUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return [(NSString *)string autorelease];
}

-(NSData*)dataWithUTF8
{
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}

-(NSString*)strip
{
    return [self stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
}

-(BOOL)containsString:(NSString*)substring
{
    return [self rangeOfString:substring].location != NSNotFound;
}

-(BOOL)isEmpty
{
    return self.length == 0;
}

-(BOOL)isNotEmpty
{
    return self.length > 0;
}

-(BOOL)isBlank
{
    // Shortcuts object creation by testing before trimming.
    return self.isEmpty || self.strip.isEmpty;
}

-(BOOL)isPresent
{
    return !self.isEmpty && !self.strip.isEmpty;
}

//credit: http://stackoverflow.com/questions/1918972/camelcase-to-underscores-and-back-in-objective-c
-(NSString*)asCamelCaseFromUnderscore
{
    NSMutableString *output = [NSMutableString string];
    BOOL makeNextCharacterUpperCase = NO;
    for (NSInteger idx = 0; idx < [self length]; idx += 1) {
        unichar c = [self characterAtIndex:idx];
        if (c == '_') {
            makeNextCharacterUpperCase = YES;
        } else if (makeNextCharacterUpperCase) {
            [output appendString:[[NSString stringWithCharacters:&c length:1] uppercaseString]];
            makeNextCharacterUpperCase = NO;
        } else {
            [output appendFormat:@"%C", c];
        }
    }
    return output;
}

-(NSString*)asUnderscoreFromCamelCase
{
    NSMutableString *output = [NSMutableString string];
    NSCharacterSet *uppercase = [NSCharacterSet uppercaseLetterCharacterSet];
    for (NSInteger idx = 0; idx < [self length]; idx += 1) {
        unichar c = [self characterAtIndex:idx];
        if ([uppercase characterIsMember:c]) {
            [output appendFormat:@"_%@", [[NSString stringWithCharacters:&c length:1] lowercaseString]];
        } else {
            [output appendFormat:@"%C", c];
        }
    }
    return output;
}

@end


@implementation NSThread(ESUtils)

+(void)detachNewThreadBlockImplementation:(ESEmptyBlock)block
{
    NSAutoreleasePool *p = [[NSAutoreleasePool alloc] init];
    block();
    Block_release(block);
    [p release];
}

+(void)detachNewThreadBlock:(ESEmptyBlock)block
{
    [NSThread detachNewThreadSelector:@selector(detachNewThreadBlockImplementation:) toTarget:self withObject:Block_copy(block)];
}

@end
