#import <UIKit/UIKit.h>
#import "MSAnimationView.h"
#import "MSAPI.h"

@protocol MSOrderDelegate <NSObject>

- (void)closeOrderMenu;

@end

@interface MSOrderBonusView : MSAnimationView <WsCompleteDelegate, UITextFieldDelegate, UIAlertViewDelegate>
@property (strong, nonatomic) UIView *orderContainerView;
@property (weak, nonatomic) id <MSOrderDelegate> delegate;

- (id)initOrderMenuWithProductId:(int)prodId andPhoneNumber:(NSString *)phone;
@end
