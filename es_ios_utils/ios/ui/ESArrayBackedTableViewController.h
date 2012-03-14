#import <UIKit/UIKit.h>

@interface ESArrayBackedTableViewController : UITableViewController
  @property(retain) NSArray* cellData;
  @property(retain) NSString* textKey;
  @property(retain) NSString* detailKey;

  @property(readonly) BOOL usesSections;

  -(void)convertToAlphaIndex;

  -(void)configureCellForData:(id)o;

  //Override these:
  -(NSArray*)cellData;
  -(void)configureCell:(UITableViewCell*)c withData:(id)o;
  -(void)didSelectCellWithData:(id)o;

@end
