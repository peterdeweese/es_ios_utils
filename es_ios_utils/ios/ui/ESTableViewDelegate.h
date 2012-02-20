#import <Foundation/Foundation.h>

@protocol ESTableViewDelegate<NSObject>
  #pragma mark - Data
    -(int)numberOfSections;
    -(int)numberOfRowsInSection:(int)s;
    -(NSString*)titleForSection:(int)s;

  #pragma mark - View
    -(UITableViewCell*)cellForRowAtIndexPath:(NSIndexPath*)indexPath;

  #pragma mark - Events
    -(void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end
