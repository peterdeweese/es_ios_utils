#import <UIKit/UIKit.h>

@interface ESArrayBackedTableViewController : UITableViewController
  -(void)configureCellForData:(id)o;

  //Override these:
  -(NSArray*)cellData;
  -(void)configureCell:(UITableViewCell*)c withData:(id)o;
  -(void)didSelectCellWithData:(id)o;
@end
