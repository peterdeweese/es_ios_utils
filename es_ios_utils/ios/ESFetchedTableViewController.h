#import "ESUtils.h"

#if IS_IOS && CORE_DATA_AVAILABLE

#import <Foundation/Foundation.h>

//  Implemented with one section.
@interface ESFetchedTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property(nonatomic, strong) NSFetchedResultsController* fetchedResultsController;
@property(nonatomic, strong) NSManagedObjectContext*     managedObjectContext;

@property(unsafe_unretained, nonatomic, readonly) id selectedObject;

-(id)objectAtIndexPath:(NSIndexPath*)i;
-(NSIndexPath*)indexPathForObject:(id)o;
-(void)selectObject:(id)o scrollPosition:(UITableViewScrollPosition)scrollPosition;
-(void)deselectObject:(id)o;
-(void)deselectAll;

//Configure these:
@property(nonatomic, unsafe_unretained) Class     entityClass;
@property(nonatomic, strong) NSString* cellReuseIdentifier;
@property(nonatomic, strong) NSString* sectionNameKeyPath; //optional, defaults to nil
@property(copy) void(^doOnError)(NSError*); //defaults to log and abort
@property(nonatomic, assign) UITableViewCellStyle cellStyle; //defaults to normal
-(void)didSelectObject:(id)o;
-(void)didDeselectObject:(id)o;

-(UITableViewCell*)createCell; //defaults to creating a cell with cellStyle
-(void)configureFetchRequest:(NSFetchRequest*)fetchRequest; //optional
-(void)configureFetchRequestController:(NSFetchedResultsController*)controller; //optional
-(void)configureCell:(UITableViewCell*)cell with:(id)object;
-(void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath;

@end

#endif /*IS_IOS*/