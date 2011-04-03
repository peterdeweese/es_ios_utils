@class ESVerticalLayoutView, ESFlowLayoutView;

@interface TestViewController : UIViewController {
    ESVerticalLayoutView *verticalLayout;
    ESFlowLayoutView     *flowLayout;
}

@property(nonatomic, retain) IBOutlet ESVerticalLayoutView *verticalLayout;
@property(nonatomic, retain) IBOutlet ESFlowLayoutView *flowLayout;

@end
