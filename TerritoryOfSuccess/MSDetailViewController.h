#import <UIKit/UIKit.h>
#import "MSLogInView.h"
#import "MSAPI.h"
#import "MSOrderBonusView.h"
@interface MSDetailViewController : UIViewController <UIAlertViewDelegate, WsCompleteDelegate, UIWebViewDelegate, dismissView, MSOrderDelegate>

@property (strong, nonatomic) IBOutlet UIView *likeView;
@property (strong, nonatomic) IBOutlet UIView *starView;
@property (strong, nonatomic) IBOutlet UIWebView *productDescriptionWebView;
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UIView *imageView;
@property (strong, nonatomic) IBOutlet UIView *transitionContainerView;
@property (strong, nonatomic) IBOutlet UIScrollView *detailScrollView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *priceImage;

@property (strong, nonatomic) IBOutlet UILabel *productName;
@property (strong, nonatomic) IBOutlet UILabel *advisesLabel;
@property (strong, nonatomic) IBOutlet UILabel *commentsLabel;
@property (strong, nonatomic) IBOutlet UIImageView *ratingImage;
@property (strong, nonatomic) IBOutlet UIImageView *detailImage;
@property (nonatomic) int productSentId;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UIButton *orderButton;
- (IBAction)orderButtonAction:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *fbButton;
- (IBAction)fbButtonPressed:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *twButton;
- (IBAction)twButtonPressed:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *vkButton;

- (IBAction)vkButtonPressed:(id)sender;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *shareButton;
@property (strong, nonatomic) UIBarButtonItem *moreActionButton;
- (IBAction)shareButtonPressed:(id)sender;

- (void)sentProductName:(NSString *)name
                  andId:(int)prodId
              andRating:(int)rating
      andCommentsNumber:(int)comments
       andAdvisesNumber:(int)advises
            andImageURL:(NSString *)imageURL
     andDescriptionText:(NSString *) descriptionText
        andNumberInList:(int)numberInList
             andBrandId:(int)brandId
          andCategoryId:(int)categoryId
              andOffset:(int)offset;

- (void)sentProductName:(NSString *)name
                  andId:(int)prodId
              andRating:(int)rating
      andCommentsNumber:(int)comments
       andAdvisesNumber:(int)advises
            andImageURL:(NSString *)imageURL
     andDescriptionText:(NSString *) descriptionText
        andNumberInList:(int)numberInList
          andCategoryId:(int)categoryId
              andOffset:(int)offset
               andPrice:(int)price;

- (void)sentBonusProductName:(NSString *)name
                  andId:(int)prodId
              andRating:(int)rating
      andCommentsNumber:(int)comments
       andAdvisesNumber:(int)advises
            andImageURL:(NSString *)imageURL
     andDescriptionText:(NSString *) descriptionText
        andNumberInList:(int)numberInList
          andCategoryId:(int)categoryId
              andOffset:(int)offset
               andPrice:(int)price;


@end
