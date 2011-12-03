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
    
    return [a.copy autorelease];
}

-(NSArray*)arrayByRemovingLastObject
{
    return [self subarrayWithRange:NSMakeRange(0, self.count-1)];
}

-(NSArray*)arrayByRemovingObject:(id)anObject
{
    NSMutableArray *a = [self.mutableCopy autorelease];
    [a removeObject:anObject];
    return [a.copy autorelease];
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

-(NSArray*)arrayMappedWithFormat:(__block NSString*)format
{
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

-(NSArray*)filteredArrayWhereKeyPath:(NSString*)keyPath equals:(id)object;
{
    NSString *format = $format(@"%@ == %@", keyPath, @"%@");
    NSPredicate *pred = [NSPredicate predicateWithFormat:format, object];
    return [self filteredArrayUsingPredicate:pred];
}

-(NSArray*)filteredArrayWhereKeyPath:(NSString*)keyPath contains:(id)object;
{
    NSString *format = $format(@"%@ IN %@", @"%@", keyPath);
    NSPredicate *pred = [NSPredicate predicateWithFormat:format, object];
    return [self filteredArrayUsingPredicate:pred];
}

-(BOOL)isIndexInRange:(NSInteger)i
{
    return i >= 0 && i < self.count;
}

-(NSArray*)reversed
{
    return self.reverseObjectEnumerator.allObjects;
}

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
    NSMutableArray *a = [NSMutableArray arrayWithCapacity:set.count];
    
    for(id o in self)
        if([set containsObject:o])
            [a addObject:o];
    
    return [a.copy autorelease];
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
    return [self.mutableCopy autorelease];
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

-(NSMutableDictionary*)asMutableDictionary { return [self.mutableCopy autorelease]; }

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
    return [self.copy autorelease];
}

-(id)dequeue
{
    if(self.isEmpty)
        return nil;
    
    id o = [[[self objectAtIndex:0] retain] autorelease];
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
    [d release];
    return result;
}

-(NSArray*)asArray
{
    return [NSArray arrayByCoalescing:self, nil];
}

-(NSMutableSet*)asMutableSet
{
    return [self.mutableCopy autorelease];
}

@end