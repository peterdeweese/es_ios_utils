#import "ESArrayBackedTableViewController.h"

@implementation ESArrayBackedTableViewController

-(void)configureCellForData:(id)o
{
    int i = [self.cellData indexOfObject:o];
    UITableViewCell* c = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
    [self configureCell:c withData:o];
}

-(NSArray*)cellData
{
    $must_override;
    return nil;
}

-(void)configureCell:(UITableViewCell*)c withData:(id)o
{
    $must_override;
}

-(void)didSelectCellWithData:(id)o { }

#pragma mark - Table view data source

-(int)numberOfSectionsInTableView:(UITableView*)tv { return 1; }
-(int)tableView:(UITableView*)tv numberOfRowsInSection:(int)s { return s==0 ? self.cellData.count : 0; }

-(UITableViewCell*)tableView:(UITableView*)tv cellForRowAtIndexPath:(NSIndexPath*)ip
{
    UITableViewCell *c = [tv dequeueReusableCellWithIdentifier:@"Cell"];
    [self configureCell:c withData:[self.cellData objectAtIndex:ip.row]];
    return c;
}

-(void)tableView:(UITableView*)tv didSelectRowAtIndexPath:(NSIndexPath*)ip
{
    [self didSelectCellWithData:[self.cellData objectAtIndex:ip.row]];
}

@end
