#import "MSAnimationView.h"
#import "MSAPI.h"
@protocol AddingCommentDelegate <NSObject>
- (void) closeAddingCommentSubviewWithAdditionalActions;
@end

@interface MSAddCommentView : MSAnimationView <UITextViewDelegate, WsCompleteDelegate, UIAlertViewDelegate>

@property (nonatomic, strong)UIView *commentBackgroundView;
@property (nonatomic, strong)UIView *commentView;
@property (nonatomic) int productId;
@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) id <AddingCommentDelegate> delegate;

- (id)initCommentAdder;
- (void)setProductId:(int)productId isFromBonus:(BOOL)bonus;

@end
