#import "ESUtils.h"

#if IS_IOS && CORE_DATA_AVAILABLE

#import <Foundation/Foundation.h>

//  Implemented with one section.
@interface ESFetchedTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property(nonatomic, retain) NSFetchedResultsController* fetchedResultsController;
@property(nonatomic, retain) NSManagedObjectContext*     managedObjectContext;

@property(nonatomic, readonly) id selectedObject;

-(id)objectAtIndexPath:(NSIndexPath*)i;
-(NSIndexPath*)indexPathForObject:(id)o;
-(void)selectObject:(id)o scrollPosition:(UITableViewScrollPosition)scrollPosition;
-(void)deselectObject:(id)o;
-(void)deselectAll;

//Configure these:
@property(nonatomic, assign) Class     entityClass;
@property(nonatomic, retain) NSString* cellReuseIdentifier;
@property(nonatomic, retain) NSString* sectionNameKeyPath; //optional, defaults to nil
@property(copy) void(^doOnError)(NSError*); //defaults to log and abort
@property(nonatomic, assign) UITableViewCellStyle cellStyle; //defaults to normal
-(void)didSelectObject:(id)o;
-(void)didDeselectObject:(id)o;

-(UITableViewCell*)createCell; //defaults to creating a cell with cellStyle
-(void)configureFetchRequest:(NSFetchRequest*)fetchRequest; //optional
-(void)configureFetchRequestController:(NSFetchedResultsController*)controller; //optional
-(void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath;

@end

#endif /*IS_IOS*/