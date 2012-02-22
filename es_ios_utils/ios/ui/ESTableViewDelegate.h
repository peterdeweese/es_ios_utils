#import <Foundation/Foundation.h>

@protocol ESTableViewDelegate<NSObject>
  #pragma mark - Data
    @required
      -(id)objectFor:(NSIndexPath*)ip;
      -(int)numberOfRowsInSection:(int)s;
    @optional
      // Either sectionTitles or numberOfSections and titleForSection must be implemented
      -(NSArray*)sectionTitles;
      -(int)numberOfSections;
      -(NSString*)titleForSection:(int)s;

  #pragma mark - View
    @required
      -(UITableViewCell*)createCell;
      -(void)updateCell:(UITableViewCell*)c for:(id)o;
    @optional
      -(float)heightForSelectedState;

  #pragma mark - Events
    @optional
      -(void)didSelectRowAt:(NSIndexPath*)indexPath;
      -(void)didDeselectRowAt:(NSIndexPath*)indexPath;
@end
