@class ESVerticalLayoutView, ESFlowLayoutView;

@interface TestViewController : UIViewController {
    ESVerticalLayoutView *verticalLayout;
    ESFlowLayoutView     *flowLayout;
}

@property(nonatomic, strong) IBOutlet ESVerticalLayoutView *verticalLayout;
@property(nonatomic, strong) IBOutlet ESFlowLayoutView *flowLayout;

@end
