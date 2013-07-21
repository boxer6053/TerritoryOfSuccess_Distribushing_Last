#import <UIKit/UIKit.h>
#import "MSAskViewController.h"
#import "MSAPI.h"
@interface MSCreateQuestionViewController : UIViewController <UIGestureRecognizerDelegate, AddingRequestStringDelegate, WsCompleteDelegate>
@property (strong, nonatomic) NSArray *arrayOfViews;
@property (strong, nonatomic) NSMutableString *requestString;

@property (strong, nonatomic) NSMutableArray *gettedImages;
@property (strong, nonatomic) NSString *response;
@property (nonatomic) int upperID;
@property (nonatomic) int savedIndex;
- (IBAction)startButton:(id)sender;
@property (strong, nonatomic) UIButton *askButton;
@property (strong, nonatomic)  UIButton *cleanButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) NSArray *arrayOfProducts;
@property (strong, nonatomic) NSMutableArray *requestStringArray;

- (IBAction)cleanButton:(id)sender;
@end
