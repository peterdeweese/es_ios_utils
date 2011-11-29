#import "ESArrayBackedPickerView.h"

@implementation ESArrayBackedPickerView

@synthesize array, key, valueKey, doOnSelect;

+(ESArrayBackedPickerView*)arrayBackedPickerViewWithArray:(NSArray*)array
{
    ESArrayBackedPickerView* result = [[[ESArrayBackedPickerView alloc] init] autorelease];
    result.array = array;
    return result;
}

-(id)init
{
    if(self = [super initWithDelegateAndDataSource:self])
        self.showsSelectionIndicator = YES;
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
        self = [self init];
    return self;
}

-(NSString*)titleForRow:(int)r
{
    id o = [array objectAtIndex:r];
    return key ? [o valueForKeyPath:key] : [o description];
}

-(void)setSelected:(id)value
{
    NSArray* values = key || valueKey ? [array arrayOfChildrenWithKeyPath:valueKey?:key] : array;
    int row = [values indexOfObject:value];
    if(row > array.count)
    {
        row = 0;
        [self pickerView:self didSelectRow:0 inComponent:0];
    }
    [self selectRow:row inComponent:0 animated:NO];
}

#pragma mark - Delegate and Data Source

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pv
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView*)pv numberOfRowsInComponent:(NSInteger)c
{
    return array.count;
}

-(NSString*)pickerView:(UIPickerView*)pv titleForRow:(NSInteger)r forComponent:(NSInteger)c
{
    return [self titleForRow:r];
}

- (void)pickerView:(UIPickerView*)pv didSelectRow:(NSInteger)r inComponent:(NSInteger)c
{
    id result = valueKey ? [[array objectAtIndex:r] valueForKey:valueKey] : [self titleForRow:r];
    if(doOnSelect)
        doOnSelect(result);
}


#pragma mark - Cleanup

-(void)dealloc
{
    self.array      = nil;
    self.key        = nil;
    self.valueKey   = nil;
    self.doOnSelect = nil;
    [super dealloc];
}

@end
