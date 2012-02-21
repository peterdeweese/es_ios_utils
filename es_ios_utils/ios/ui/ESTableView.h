#import <UIKit/UIKit.h>
#import "ESTableViewDelegate.h"
#import "ESUtils.h"
/* 
 * Overrides data source and delegate to use itself.  Use esDelegate.
 */
@interface ESTableView : UITableView<UITableViewDataSource, UITableViewDelegate>
  @property(assign) IBOutlet id<ESTableViewDelegate> esDelegate;
@end
