//
//  ESFetchedTableViewController.m
//  es_ios_utils
//
//  Created by Peter DeWeese on 4/8/11.
//  Copyright 2011 Eye Street Research, LLC. All rights reserved.
//

#import "ESFetchedTableViewController.h"


@implementation ESFetchedTableViewController

@synthesize fetchedResultsController, managedObjectContext, sectionNameKeyPath, doOnError, entityName = _entityName;

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

-(NSString*)entityName
{
    if(!_entityName)
        $must_override;
    return _entityName;
}

-(UITableViewCellStyle)useCellStyle
{
    return UITableViewCellStyleDefault;
}

static NSString *kESFetchedTableViewControllerCell = @"ESFetchedTableViewControllerCell";

-(UITableViewCell*)createCell
{
    return  [[[UITableViewCell alloc] initWithStyle:self.useCellStyle
                                    reuseIdentifier:kESFetchedTableViewControllerCell] autorelease];
}

-(void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    $must_override;
}

-(NSArray*)sortDescriptors
{
    $must_override;
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

-(NSString*)tableView:(UITableView *)t titleForHeaderInSection:(NSInteger)s
{
    id<NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController.sections objectAtIndex:s];
    return sectionInfo.name;
}

-(UITableViewCell*)tableView:(UITableView*)t cellForRowAtIndexPath:(NSIndexPath*)i
{    
    UITableViewCell *c = [t dequeueReusableCellWithIdentifier:kESFetchedTableViewControllerCell];
    if (!c)
        c = [self createCell];
    
    [self configureCell:c atIndexPath:i];
    
    return c;
}

-(void)configureFetchRequest:(NSFetchRequest*)fetchRequest
{
    //optional
}

-(void)configureFetchRequestController:(NSFetchedResultsController*)controller
{
    //optional
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

-(NSFetchedResultsController*)fetchedResultsController
{
    assert(managedObjectContext);

    if (fetchedResultsController)
        return fetchedResultsController;
    
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    fetchRequest.entity = [NSEntityDescription entityForName:self.entityName inManagedObjectContext:managedObjectContext];
    fetchRequest.fetchBatchSize = 20;
    fetchRequest.sortDescriptors = self.sortDescriptors;
    [self configureFetchRequest:fetchRequest];
    self.fetchedResultsController = [[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:self.sectionNameKeyPath cacheName:nil] autorelease];
    self.fetchedResultsController.delegate = self;
    
    [self configureFetchRequestController:self.fetchedResultsController];
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
