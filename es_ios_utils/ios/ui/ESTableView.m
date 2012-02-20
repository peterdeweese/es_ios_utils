#import "ESTableView.h"

@interface ESTableView()
  @property(retain) NSString* reuseIdentifier;
@end

@implementation ESTableView

@synthesize /*private*/ reuseIdentifier;
@synthesize esDelegate;

-(id)initWithCoder:(NSCoder*)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        self.delegate = self;
        self.dataSource = self;
        self.reuseIdentifier = NSString.stringWithUUID;
    }
    return self;
}

#pragma mark - Data

-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return esDelegate.numberOfSections;
}

-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [esDelegate numberOfRowsInSection:section];
}

-(NSString*)tableView:(UITableView*)tv titleForHeaderInSection:(NSInteger)s
{
    return [esDelegate titleForSection:s];
}


#pragma mark - View

-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)ip
{
    
    UITableViewCell* cell = [self dequeueReusableCellWithIdentifier:self.reuseIdentifier];
    if(!cell)
        cell = [esDelegate createCellFor:ip];
    
    [esDelegate updateCell:cell at:ip];
    return cell;
}


#pragma mark - Events

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [esDelegate didSelectRowAtIndexPath:indexPath];
}

@end
