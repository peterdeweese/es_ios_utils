/*
 * If key is not specified, it will use the description from each array item.
 * valueKey is also optional.
 */
@interface ESArrayBackedPickerView : UIPickerView <UIPickerViewDelegate, UIPickerViewDataSource>
  +(ESArrayBackedPickerView*)arrayBackedPickerViewWithArray:(NSArray*)array;
  @property(nonatomic, strong) NSArray*  array;
  @property(nonatomic, strong) NSString* key;
  @property(nonatomic, strong) NSString* valueKey;
  @property(nonatomic, copy)  void(^doOnSelect)(NSString* value);
  -(void)setSelected:(id)value;
@end
