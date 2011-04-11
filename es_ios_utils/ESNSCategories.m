//
//  NSCategories.m
//  es_ios_utils
//
//  Created by Peter DeWeese on 3/16/11.
//  Copyright 2011 Eye Street Research, LLC. All rights reserved.
//

#import "ESNSCategories.h"
#import <objc/runtime.h>

@implementation ESNSCategories

@end


@implementation NSArray(ESUtils)

-(id)firstObject
{
    if(self.count > 0)
        return [self objectAtIndex:0];
    return nil;
}

-(BOOL)isEmpty
{
    return self.count == 0;
}

-(BOOL)isNotEmpty
{
    return self.count > 0;
}

-(NSUInteger)lastIndex
{
    return self.count - 1;
}

-(NSArray*)filteredArrayUsingSet:(NSSet*)set
{
    NSMutableArray *a = [[[NSMutableArray alloc] initWithCapacity:set.count] autorelease];
    
    for(id o in self)
        if([set containsObject:o])
            [a addObject:o];
    
    return a.copy;
}

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

@end


@implementation NSDictionary(ESUtils)

-(BOOL)isEmpty
{
    return self.count == 0;
}

-(BOOL)isNotEmpty
{
    return self.count > 0;
}

-(id)objectForKeyObject:(id)key;
{
    return [self objectForKey:[NSValue valueWithNonretainedObject:key]];
}

@end


@implementation NSError(ESUtils)

-(void)log
{
    NSLog(@"%@, %@", self, self.userInfo);
}

-(void)logWithMessage:(NSString*)message
{
    NSLog(@"%@ %@, %@", message, self, self.userInfo);
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

-(NSManagedObject*)createManagedObjectOfClass:(Class)c
{
    return [self createManagedObjectNamed:[NSString stringWithUTF8String:class_getName(c)]];
}

-(BOOL)saveAndDoOnError:(ErrorBlock)doOnError
{
    NSError *error;
    BOOL result = [self save:&error];
    
    if (!result)
        doOnError(error);

    return result;
}

@end


@implementation NSMutableArray(ESUtils)

- (id)dequeue
{
    if(self.count == 0)
        return nil;
    
    id object = [self objectAtIndex:0];
    [self removeObjectAtIndex:0];
    return object;
}

- (id)pop
{
    if(self.count == 0)
        return nil;
    
    id object = [self lastObject];
    [self removeLastObject];
    return object;
}

@end


@implementation NSMutableDictionary(ESUtils)

-(void)setObject:(id)value forKeyObject:(id)key
{
    [self setObject:value forKey:[NSValue valueWithNonretainedObject:key]];
}

@end


@implementation NSNull(ESUtils)

-(BOOL)isEmpty
{
    return YES;
}

-(BOOL)isNotEmpty
{
    return NO;
}

@end


@implementation NSSet(ESUtils)

-(BOOL)isEmpty
{
    return self.count == 0;
}

-(BOOL)isNotEmpty
{
    return self.count > 0;
}

@end


@implementation NSString(ESUtils)

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
    return self.isEmpty || self.strip.isEmpty;
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