#import "ESUtils.h"

#if IS_IOS && CORE_DATA_AVAILABLE

#import "ESCDCategories.h"
#import "ESFetchedTableViewController.h"

@implementation ESFetchedTableViewController

@synthesize fetchedResultsController = _fetchedResultsController, managedObjectContext, sectionNameKeyPath, doOnError, entityClass, cellReuseIdentifier, cellStyle;

-(id)init
{
    if(self = [super init])
    {
        self.doOnError = ^(NSError *e){
            [e log];
            abort();
        };
        self.cellStyle = UITableViewCellStyleDefault;
    }
    return self;
}

-(id)initWithNibName:(NSString*)name bundle:(NSBundle*)b
{
    return self = [super initWithNibName:name bundle:b];
}

-(id)initWithCoder:(NSCoder*)coder
{
    return self = [super initWithCoder:coder];
}

-(id)objectAtIndexPath:(NSIndexPath*)i
{
    return [self.fetchedResultsController objectAtIndexPath:i];
}

-(NSIndexPath*)indexPathForObject:(id)o
{
    return [self.fetchedResultsController indexPathForObject:o];
}

-(void)selectObject:(id)o scrollPosition:(UITableViewScrollPosition)scrollPosition
{
    [self.tableView selectRowAtIndexPath:[self indexPathForObject:o] animated:YES scrollPosition:scrollPosition];
}

-(void)deselectObject:(id)o
{
    [self.tableView deselectRowAtIndexPath:[self indexPathForObject:o] animated:YES];
}

-(void)deselectAll
{
    [self.tableView deselectAll];
}

#pragma mark - Implement

static NSString *kESFetchedTableViewControllerCell = @"ESFetchedTableViewControllerCell";

-(UITableViewCell*)createCell
{
    id reuseIdentifier = self.cellReuseIdentifier ?: kESFetchedTableViewControllerCell;
    UITableViewCell* c = [self.tableView dequeueReusableCellWithIdentifier:self.cellReuseIdentifier];
    return c ?: [[[UITableViewCell alloc] initWithStyle:self.cellStyle reuseIdentifier:reuseIdentifier] autorelease];
}

-(void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    $must_override;
}

-(void)didSelectObject:(id)o { }
-(void)didDeselectObject:(id)o { }

-(id)selectedObject
{
    return [self.fetchedResultsController objectAtIndexPath:self.tableView.indexPathForSelectedRow];
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

-(void)tableView:(UITableView*)t didSelectRowAtIndexPath:(NSIndexPath*)i
{
    [self didSelectObject:[self objectAtIndexPath:i]];
}

-(void)tableView:(UITableView*)t didDeselectRowAtIndexPath:(NSIndexPath*)i
{
    [self didDeselectObject:[self objectAtIndexPath:i]];
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
        [self.managedObjectContext deleteObject:[self objectAtIndexPath:i]];
        [self.managedObjectContext saveAndDoOnError:self.doOnError];
    }   
}


#pragma mark - Fetched results controller

-(NSFetchedResultsController*)generateFetchedResultsControllerWithManagedObjectContext:(NSManagedObjectContext*)context
{
    assert(context);
    assert(self.entityClass);
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestForClass:self.entityClass 
                                                 inManagedObjectContext:context];
    fetchRequest.fetchBatchSize = 20;
    [self configureFetchRequest:fetchRequest];
    self.fetchedResultsController = [NSFetchedResultsController fetchedResultsControllerWithRequest:fetchRequest
                                                                               managedObjectContext:context 
                                                                                 sectionNameKeyPath:self.sectionNameKeyPath];
    self.fetchedResultsController.delegate = self;
    
    [self configureFetchRequestController:self.fetchedResultsController];
    [self.fetchedResultsController performFetchAndDoOnError:self.doOnError];
    
    return self.fetchedResultsController;
}

-(NSFetchedResultsController*)fetchedResultsController
{
    return _fetchedResultsController ?: (self.fetchedResultsController = [self generateFetchedResultsControllerWithManagedObjectContext:self.managedObjectContext]);
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

-(void)insertNewObject
{
    NSManagedObject *newManagedObject = [self.managedObjectContext createManagedObjectOfClass:self.entityClass];
    [newManagedObject.managedObjectContext saveAndDoOnError:self.doOnError];
}

#pragma mark -

-(void)dealloc
{
    _fetchedResultsController.delegate     = nil;
    self.fetchedResultsController          = nil;
    self.managedObjectContext              = nil;
    self.sectionNameKeyPath                = nil;
    self.cellReuseIdentifier               = nil;
    self.entityClass                       = nil;
    self.doOnError                         = nil;
    [super dealloc];
}

@end

#endif /*IS_IOS*/