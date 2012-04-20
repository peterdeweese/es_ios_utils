#import <UIKit/UIKit.h>

@interface ESArrayBackedTableViewController : UITableViewController
  @property(retain) NSArray*             cellData;
  @property(retain) NSString*            textKey;
  @property(retain) NSString*            detailKey;
  @property(assign) UITableViewCellStyle cellStyle;

  @property(readonly) BOOL usesSections;

  -(void)convertToIndex:(ObjectReturnBlock)indexTitle;
  -(void)convertToAlphaIndex;

  -(void)configureCellForData:(id)o;

  //Override these:
  -(NSArray*)cellData;
  -(void)configureCell:(UITableViewCell*)c withData:(id)o;
  -(void)didSelectCellWithData:(id)o;

  -(NSIndexPath*)indexPathForObject:(id)data;
  -(void)scrollToObject:(id)data animated:(BOOL)animated;
@end
