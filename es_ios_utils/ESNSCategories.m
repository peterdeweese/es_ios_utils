#import "ESNSCategories.h"
#import <objc/runtime.h>

@implementation ESNSCategories

@end


@implementation NSDate(ESUtils)

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

-(NSString*)relativeString
{
    NSDateFormatter *f = [[[NSDateFormatter alloc] init] autorelease];
    f.timeStyle = NSDateFormatterNoStyle;
    f.dateStyle = NSDateFormatterMediumStyle;
    f.locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease];
    f.doesRelativeDateFormatting=YES;
    
    return [f stringForObjectValue:self];
}

@end


@implementation NSError(ESUtils)

-(NSArray*)detailedErrors
{
    return [self.userInfo objectForKey:NSDetailedErrorsKey];
}

-(void)logDetailedErrors
{
    for(NSError *e in self.detailedErrors)
        [e logWithMessage:@"Detailed Error"];
}

-(void)log
{
    NSLog(@"%@", self.localizedDescription);
}

-(void)logWithMessage:(NSString*)message
{
    NSLog(@"%@ - %@", message, self);
}

@end


@implementation NSFetchedResultsController(ESUtils)

-(NSManagedObject*)createManagedObject
{
    return (NSManagedObject*)[self.managedObjectContext createManagedObjectNamed:self.fetchRequest.entity.name];
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
- (NSString*)xmlString
{
    return [self xmlString:[[[NSMutableSet alloc] init] autorelease]];
}

@end


@implementation NSManagedObjectContext(ESUtils)

-(NSManagedObject*)createManagedObjectNamed:(NSString*)name
{
    // Create a new instance of the entity managed by the fetched results controller.
    return [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:self];
}

-(NSManagedObject*)createManagedObjectNamed:(NSString*)name withDictionary:(NSDictionary*)dictionary
{
    // Create a new instance of the entity managed by the fetched results controller.
    NSManagedObject *o = [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:self];
    [o quietlySetValuesForKeysWithDictionary:dictionary];
    return o;
}

-(NSManagedObject*)createManagedObjectOfClass:(Class)c
{
    return [self createManagedObjectNamed:[NSString stringWithClassName:c]];
}

-(NSManagedObject*)createManagedObjectOfClass:(Class)c withDictionary:(NSDictionary*)dictionary
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

-(BOOL)hasAny:(Class)type
{
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass(type)
                                              inManagedObjectContext:self];
    fetchRequest.entity = entity;
    fetchRequest.fetchLimit = 1;
    
    NSError *error = nil;

    NSArray *results = [self executeFetchRequest:fetchRequest error:&error];
    if (error)
        [error log];
    
    return results.isNotEmpty;
}

//TODO: shouldn't this be a set?
-(NSArray*)all:(Class)type
{
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass(type)
                                              inManagedObjectContext:self];
    fetchRequest.entity = entity;
    
    NSError *error = nil;
    
    NSArray *results = [self executeFetchRequest:fetchRequest error:&error];
    if (error)
        [error log];
    
    return results;
}

@end


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

//REFACTOR: consider pulling up into a math util library
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

-(NSData*)dataWithUTF8
{
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}

-(NSString*)strip
{
    return [self stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
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