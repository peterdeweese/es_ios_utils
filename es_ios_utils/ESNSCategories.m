//
//  NSCategories.m
//  es_ios_utils
//
//  Created by Peter DeWeese on 3/16/11.
//  Copyright 2011 Eye Street Research, LLC. All rights reserved.
//

#import "ESNSCategories.h"


@implementation ESNSCategories

@end


@implementation NSArray(ESUtils)

-(id)firstObject
{
    return [self objectAtIndex:0];
}

-(BOOL)isEmpty
{
    return self.count == 0;
}

-(BOOL)isNotEmpty
{
    return self.count > 0;
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

-(NSManagedObject*)createAndSaveManagedObject:(ESNSManagedObjectBlock)configure doOnError:(ErrorBlock)doOnError
{
    // Create a new instance of the entity managed by the fetched results controller.
    NSManagedObject *new = [NSEntityDescription insertNewObjectForEntityForName:self.fetchRequest.entity.name inManagedObjectContext:self.managedObjectContext];
    
    configure(new);
    
    if(![self.managedObjectContext saveAndDoOnError:doOnError])
        [new release], new=nil;
    
    return new;
}

@end


@implementation NSManagedObjectContext(ESUtils)

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
