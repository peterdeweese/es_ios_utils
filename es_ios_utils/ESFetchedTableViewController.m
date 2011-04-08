//
//  ESFetchedTableViewController.m
//  es_ios_utils
//
//  Created by Peter DeWeese on 4/8/11.
//  Copyright 2011 Eye Street Research, LLC. All rights reserved.
//

#import "ESFetchedTableViewController.h"


@implementation ESFetchedTableViewController

@synthesize fetchedResultsController, managedObjectContext, doOnError;

-(id)init
{
    self.doOnError = ^(NSError *e){
        [e log];
        abort();
    };
    return self;
}

-(id)initWithNibName:(NSString*)name bundle:(NSBundle*)b
{
    [self init];
    return [super initWithNibName:name bundle:b];
}

-(id)initWithCoder:(NSCoder*)coder
{
    [self init];
    return [super initWithCoder:coder];
}

-(void)dealloc
{
    self.fetchedResultsController = nil;
    self.managedObjectContext = nil;
    
    [super dealloc];
}


#pragma mark - Implement

- (void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    [NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass of ESFetchedTableViewController", NSStringFromSelector(_cmd)];
}

-(NSArray*)sortDescriptors
{
    [NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass of ESFetchedTableViewController", NSStringFromSelector(_cmd)];
    return nil;
}


#pragma mark - Table Controller, Datasource, and Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.fetchedResultsController.sections.count;
}

-(int)tableView:(UITableView*)t numberOfRowsInSection:(int)s
{
    id<NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController.sections objectAtIndex:s];
    return sectionInfo.numberOfObjects;
}

-(UITableViewCell*)tableView:(UITableView*)t cellForRowAtIndexPath:(NSIndexPath*)i
{
    static NSString *CellIdentifier = @"ESFetchedTableViewControllerCell";
    
    UITableViewCell *c = [t dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!c)
        c = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    
    [self configureCell:c atIndexPath:i];
    
    return c;
}

-(void)tableView:(UITableView*)t commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)i
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        [managedObjectContext deleteObject:[self.fetchedResultsController objectAtIndexPath:i]];
        [managedObjectContext saveAndDoOnError:self.doOnError];
    }   
}


#pragma mark - Fetched results controller

-(NSFetchedResultsController *)fetchedResultsController
{    
    if (fetchedResultsController)
        return fetchedResultsController;
    
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    fetchRequest.entity = [NSEntityDescription entityForName:@"Order" inManagedObjectContext:managedObjectContext];
    fetchRequest.fetchBatchSize = 20;
    fetchRequest.sortDescriptors = self.sortDescriptors;
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
    self.fetchedResultsController.delegate = self;
    
    [self.fetchedResultsController performFetchAndDoOnError:self.doOnError];
    
    return fetchedResultsController;
}    

#pragma mark - Fetched results controller delegate

-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

-(void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo
          atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
      atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
     newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type)
    {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowAtIndexPath:newIndexPath withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowAtIndexPath:newIndexPath withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

@end
