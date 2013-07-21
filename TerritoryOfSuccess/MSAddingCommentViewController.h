#import <UIKit/UIKit.h>
#import "MSAPI.h"
//@protocol AddingCommentDelegate <NSObject>
//
//-(void) addNewComment:(NSArray *) array;
//
//@end

@interface MSAddingCommentViewController : UIViewController <UITextViewDelegate, WsCompleteDelegate>
@property (strong, nonatomic) IBOutlet UINavigationItem *navigation;
@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (strong, nonatomic) IBOutlet UITextView *inputText;
@property (strong, nonatomic) UITapGestureRecognizer *tap;
@property (strong, nonatomic) IBOutlet UIView *containView;
@property (strong, nonatomic) IBOutlet UILabel *pleaseLabel;
//@property (strong, nonatomic) id <AddingCommentDelegate> delegate;
@property (strong, nonatomic) NSMutableArray *sentArray;

@property (strong, nonatomic) IBOutlet UIButton *starButton1;
@property (strong, nonatomic) IBOutlet UIButton *starButton2;
@property (strong, nonatomic) IBOutlet UIButton *starButton3;
@property (strong, nonatomic) IBOutlet UIButton *starButton4;
@property (strong, nonatomic) IBOutlet UIButton *starButton5;

- (IBAction)starButtonPressed:(UIButton *)sender;
- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;
@end
