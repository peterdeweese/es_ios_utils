#import "ESTableView.h"

@implementation ESTableView

@synthesize esDelegate;

-(id)initWithCoder:(NSCoder*)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        self.delegate = self;
        self.dataSource = self;
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

-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return [esDelegate cellForRowAtIndexPath:indexPath];
}


#pragma mark - Events

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [esDelegate didSelectRowAtIndexPath:indexPath];
}

@end
