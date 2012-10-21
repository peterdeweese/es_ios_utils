#import "ESCollectionCategories.h"
#import <objc/runtime.h>

@implementation ESCollectionCategories
@end


@implementation NSArray(ESUtils)

+(NSArray*)arrayByCoalescing:(id)first, ...
{
    NSMutableArray *a = [NSMutableArray arrayWithCapacity:10];
    
    va_list args;
    va_start(args, first);
    for (id arg = first; arg != nil; arg = va_arg(args, id))
    {
        if([arg conformsToProtocol:@protocol(NSFastEnumeration)])
           for(id o in arg)
               [a addObject:o];//REFACTOR: pull up copying the whole of any fast enumerator to another
        else
            [a addObject:arg];
    }
    va_end(args);
    
    return a.copy;
}

-(NSArray*)arrayByRemovingLastObject
{
    return [self subarrayWithRange:NSMakeRange(0, self.count-1)];
}

-(NSArray*)arrayByRemovingObject:(id)anObject
{
    NSMutableArray *a = self.asMutableArray;
    [a removeObject:anObject];
    return a.asArray;
}

-(NSArray*)arrayByRemovingObjectAtIndex:(int)index
{
    NSMutableArray* a = self.asMutableArray;
    [a removeObjectAtIndex:index];
    return a.asArray;
}

-(NSArray*)arrayOfChildrenWithKeyPath:(NSString*)keyPath
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.count];
    for(NSObject *o in self)
    {
        id v = [o valueForKeyPath:keyPath];
        [result addObject:(v ? v : NSNull.null)];
    }
    return result;
}

-(NSArray*)arrayMappedWithFormat:(NSString*)f
{
    NSString* format = f;
    return [self arrayMappedWith:^id(id o) {
        return [NSString stringWithFormat:format, ((NSObject*)o).description];
    }];
}

-(NSArray*)arrayMappedWith:(id(^)(id))mapper
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.count];
        
    for(NSObject *o in self)
    {
        id r = mapper(o);
        if(r)
            [result addObject:r];
        else
            NSLog(@"arrayMappedWith: returned nil for %@.", o);
    }
    
    return result;
}

-(NSArray*)subarrayFrom:(int)loc length:(int)len
{
    return [self subarrayWithRange:$range(loc, len)];
}

-(NSArray*)subarrayTo:(int)loc
{
    return [self subarrayFrom:0 length:loc+1];
}

-(NSArray*)filteredArrayUsingPredecateFormat:(NSString*)format, ...
{
    va_list args;
    va_start(args, format);
    NSPredicate *pred = [NSPredicate predicateWithFormat:format arguments:args];
    return [self filteredArrayUsingPredicate:pred];
}

-(NSArray*)filteredArrayWhereKeyPath:(NSString*)keyPath contains:(id)object
{
    return [self filteredArrayUsingPredecateFormat: $format(@"%@ CONTAINS %%@", keyPath), object];
}

-(NSArray*)filteredArrayWhereKeyPath:(NSString*)keyPath containsIgnoreCase:(id)object
{
    return [self filteredArrayUsingPredecateFormat: $format(@"%@ CONTAINS[c] %%@", keyPath), object];
}

-(NSArray*)filteredArrayWhereKeyPath:(NSString*)keyPath equals:(id)object
{
    return [self filteredArrayUsingPredecateFormat: $format(@"%@ == %%@", keyPath), object];
}

-(NSArray*)filteredArrayWhereKeyPath:(NSString*)keyPath equalsInt:(int)i
{
    return [self filteredArrayUsingPredecateFormat: $format(@"%@ == %%d", keyPath), i];
}

-(NSArray*)filteredArrayWhereKeyPath:(NSString*)keyPath in:(id)object
{
    return [self filteredArrayUsingPredecateFormat: $format(@"%%@ IN %@", keyPath), object];
}

-(BOOL)isIndexInRange:(NSInteger)i
{
    return i >= 0 && i < self.count;
}

-(NSArray*)reversed
{
    return self.reverseObjectEnumerator.allObjects;
}

#pragma mark - Object Accessors

-(id)at:(int)index
{
    return [self objectAtIndex:index];
}

-(id)first
{
    if(self.count > 0)
        return [self objectAtIndex:0];
    return nil;
}

-(id)firstObject
{
    NSLog(@"deprecated: `Array.firstObject`. Use `Array.first`."); // 1-10-2012
    return self.first;
}

-(id)last
{
    return self.lastObject;
}

#pragma mark -

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

#pragma mark - Calculations

-(int)sumAsInt
{
    int result = 0;
    for(NSNumber* n in self)
        if([n isKindOfClass:NSNumber.class])
            result += n.intValue;
    return result;
}

#pragma mark -

-(NSArray*)filteredArrayUsingSet:(NSSet*)set
{
    NSMutableArray *a = [NSMutableArray arrayWithCapacity:set.count];
    
    for(id o in self)
        if([set containsObject:o])
            [a addObject:o];
    
    return a.copy;
}

-(NSSet*)asSet
{
    return [NSSet setWithArray:self];
}

-(NSMutableSet*)asMutableSet
{
    return self.asSet.asMutableSet;
}

-(NSMutableArray*)asMutableArray
{
    return self.mutableCopy;
}

-(NSDictionary*)asDictionaryUsingKey:(NSString*)key
{
    NSMutableDictionary* result = [NSMutableDictionary dictionaryWithCapacity:self.count];
    for(id o in self)
        [result setObject:o forKey:[o valueForKey:key]];
    return result;
}

-(NSInteger)firstIndexWhereKeyPath:(id)kp isEqual:(id)o2
{
    return [self indexOfObjectPassingTest:^BOOL(id o, NSUInteger i, BOOL *stop)
            {
                id v = [o valueForKeyPath:kp];
                return (!o2 && !v) || (o2 && [o2 isEqual:v]);
            }];
}

-(int)countObjectsWhereKeyPath:(id)kp isEqual:(id)o2
{
    int count = 0;
    for(id o in self)
    {
        id v = [o valueForKeyPath:kp];
        if((!o2 && !v) || (o2 && [o2 isEqual:v]))
            count++;
    }
    
    return count;
}

@end


@interface NSDictionary(ESUtilsPrivate)
    -(NSArray*)deepCopyArray:(NSArray*)a withKeyFilter:(NSString*(^)(NSString*))keyFilter;
    -(id)deepCopyObject:(id)o withKeyFilter:(NSString*(^)(NSString*))keyFilter;
@end

@implementation NSDictionary(ESUtilsPrivate)

-(NSArray*)deepCopyArray:(NSArray*)a withKeyFilter:(NSString*(^)(NSString*))keyFilter
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:a.count];
    for(id o in a)
        [result addObject:[self deepCopyObject:o withKeyFilter:keyFilter]];
    return result;
}

-(id)deepCopyObject:(id)o withKeyFilter:(NSString*(^)(NSString*))keyFilter
{
    if([o isKindOfClass:NSArray.class])
        return [self deepCopyArray:o withKeyFilter:keyFilter];
    else if([o isKindOfClass:NSDictionary.class])
        return [((NSDictionary*)o) asDeepCopyWithKeyFilter:keyFilter];
    else return o;
}

@end

@implementation NSDictionary(ESUtils)

+(NSDictionary*)dictionaryWithObjects:(ESCollection*)objects keyPathForKeys:(NSString*)keyPath
{
    NSMutableDictionary* result = [NSMutableDictionary dictionaryWithCapacity:20];

    [result setObjects:objects keyPathForKeys:keyPath];
    return result;
}

+(NSDictionary*)dictionaryWithObjects:(ESCollection*)objects keyPathForKeys:(NSString*)keyPath keyPathForValues:(NSString*)valuePath
{
    NSMutableDictionary* result = [NSMutableDictionary dictionaryWithCapacity:20];
    
    [result setObjects:objects keyPathForKeys:keyPath keyPathForValues:valuePath];
    return result;
}

-(NSDictionary*)asDeepCopy
{
    return [self asDeepCopyWithKeyFilter:nil];
}

-(NSDictionary*)asDeepCopyWithKeyFilter:(NSString*(^)(NSString*))keyFilter
{
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:self.count];
    [result addEntriesFromDictionary:self withKeyFilter:keyFilter];

    //copy subarrays and subdictionaries
    for(NSString *key in result.allKeys)
        [result setObject:[self deepCopyObject:[result objectForKey:key] withKeyFilter:keyFilter] forKey:key];
    
    return result;
}

-(NSMutableDictionary*)asMutableDictionary { return self.mutableCopy; }

-(BOOL)isEmpty
{
    return self.count == 0;
}

-(BOOL)isNotEmpty
{
    return self.count > 0;
}

-(BOOL)containsValueForKey:(NSString*)key
{
    id o = [self objectForKey:key];
    return true && o && ![o isKindOfClass:NSNull.class];
}

-(id)objectForKeyObject:(id)key;
{
    return [self objectForKey:[NSValue valueWithNonretainedObject:key]];
}

-(NSDictionary*)asCamelCaseKeysFromUnderscore
{
    return [self asDeepCopyWithKeyFilter:^NSString*(NSString *key){ return key.asCamelCaseFromUnderscore; }];
}

-(NSDictionary*)asUnderscoreKeysFromCamelCase
{
    return [self asDeepCopyWithKeyFilter:^NSString*(NSString *key){ return key.asUnderscoreFromCamelCase; }];
}

@end


@implementation NSMutableArray(ESUtils)

-(NSArray*)asArray
{
    return self.copy;
}

-(id)dequeue
{
    if(self.isEmpty)
        return nil;
    
    id o = [self objectAtIndex:0];
    [self removeObjectAtIndex:0];
    return o;
}

-(id)pop
{
    if(self.count == 0)
        return nil;
    
    id object = [self lastObject];
    [self removeLastObject];
    return object;
}

-(void)replaceObject:(id)o withObject:(id)newO
{
    [self replaceObjectAtIndex:[self indexOfObject:o]
                    withObject:newO];
}

@end


@implementation NSMutableDictionary(ESUtils)

-(void)setObject:(id)value forKeyObject:(id)key
{
    [self setObject:value forKey:[NSValue valueWithNonretainedObject:key]];
}

-(void)setObjects:(ESCollection*)objects keyPathForKeys:(NSString*)keyPath
{
    for(id o in objects)
    {
        id key = [o valueForKeyPath:keyPath];
        if(key)
            [self setObject:o forKey:key];
    }
}

-(void)setObjects:(ESCollection*)objects keyPathForKeys:(NSString*)keyPath keyPathForValues:(NSString*)valuePath
{
    for(id o in objects)
    {
        id key = [o valueForKeyPath:keyPath];
        if(key)
            [self setObject:[o valueForKeyPath:valuePath] forKey:key];
    }
}

-(void)addEntriesFromDictionary:(NSDictionary*)d withKeyFilter:(NSString*(^)(NSString*))keyFilter
{
    if(!keyFilter)
        return [self addEntriesFromDictionary:d];
    
    for(NSString *key in d.allKeys)
        [self setObject:[d objectForKey:key] forKey:keyFilter(key)];
}

-(void)renameKey:(NSString*)key to:(NSString*)to
{
    id value = [self objectForKey:key];
    if(value)
    {
        [self setObject:value forKey:to];
        [self removeObjectForKey:key];
    }
}

@end


@implementation NSMutableSet(ESUtils)

-(void)removeObjects:(ESCollection*)objects
{
    for(id o in objects)
        [self removeObject:o];
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

-(NSArray*)sortedArrayByKey:(NSString*)key ascending:(BOOL)ascending
{
    NSSortDescriptor *d = [[NSSortDescriptor alloc] initWithKey:key ascending:ascending];
    NSArray *result = [self sortedArrayUsingDescriptors:$array(d)];
    return result;
}

-(NSArray*)asArray
{
    return [NSArray arrayByCoalescing:self, nil];
}

-(NSMutableSet*)asMutableSet
{
    return self.mutableCopy;
}

@end