#import "MSDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "MSShare.h"
#import "MSCommentsViewController.h"
#import <Social/Social.h>
#import "MSiOSVersionControlHeader.h"
#import "SVProgressHUD.h"
#import "MSOrderBonusView.h"

@interface MSDetailViewController () 
{
    BOOL _isFromBrandCatalog;
}

@property (nonatomic) int commentsDetail, advisesDetail, ratingDetail;
@property (strong, nonatomic) NSString *productImageURL;
@property (strong, nonatomic) NSString *productSentName;
@property (strong, nonatomic) NSString *productSentDescription;
@property (nonatomic, strong) NSString *productPrice;
@property (strong, nonatomic) MSShare *share;
@property (strong, nonatomic) UIView *transitionView;
@property (strong, nonatomic) UIButton *rateButton;
@property (strong, nonatomic) UIButton *likeButton;
@property (strong, nonatomic) UIButton *commentButton;
@property (strong, nonatomic) UILabel *rateButtonLabel;
@property (strong, nonatomic) UILabel *likeButtonLabel;
@property (strong, nonatomic) UILabel *commentButtonLabel;
@property BOOL *shareIsPressed;
@property BOOL *isImageDisplay;
@property BOOL *rateButtonPressed;
@property (strong, nonatomic) MSAPI *api;
@property (strong, nonatomic) NSData *shareImageData;
@property (strong, nonatomic) UIImage *shareImage;
@property (strong, nonatomic) NSString *shareString;

@property (strong, nonatomic) NSArray *starsArray;
@property (weak, nonatomic) UIButton *star1;
@property (weak, nonatomic) UIButton *star2;
@property (weak, nonatomic) UIButton *star3;
@property (weak, nonatomic) UIButton *star4;
@property (weak, nonatomic) UIButton *star5;
@property int rateNumber;// 0 - 5

//для обновления лайков, комментов и звездочек на странице
@property int numberInList;
@property int brandId;
@property int categoryId;
@property int detailProductOffset;

//login popUP
@property (nonatomic, strong) MSLogInView *loginView;

//order
@property (nonatomic, strong) MSOrderBonusView *orderBonusView;
@end

@implementation MSDetailViewController

@synthesize commentsDetail = _commentsDetail;
@synthesize advisesDetail = _advisesDetail;
@synthesize ratingDetail = _ratingDetail;
@synthesize productName = _productName;
@synthesize share = _share;
@synthesize productSentDescription = _productSentDescription;
@synthesize productSentId = _productSentId;
@synthesize shareButton = _shareButton;
@synthesize moreActionButton = _moreActionButton;
@synthesize shareIsPressed = _shareIsPressed;
@synthesize transitionView = _transitionView;
@synthesize commentButton = _commentButton;
@synthesize rateButton = _rateButton;
@synthesize likeButton = _likeButton;
@synthesize rateButtonLabel = _rateButtonLabel;
@synthesize likeButtonLabel = _likeButtonLabel;
@synthesize commentButtonLabel = _commentButtonLabel;
@synthesize transitionContainerView = _transitionContainerView;
@synthesize detailProductOffset = _detailProductOffset;
@synthesize priceImage = _priceImage;
@synthesize priceLabel = _priceLabel;
@synthesize productPrice = _productPrice;
@synthesize loginView = _loginView;
@synthesize orderBonusView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.shareIsPressed = NO;
    self.isImageDisplay = YES;
    self.rateButtonPressed = NO;
    
    self.rateNumber = 0;
    self.transitionView = [[UIView alloc] initWithFrame:CGRectMake(self.imageView.frame.origin.x, self.imageView.frame.origin.y, self.imageView.frame.size.width, self.imageView.frame.size.height)];
    [[self transitionView] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"dialogViewGradient.png"]]];
    [[self transitionView].layer setBorderWidth:2.0f];
    [[self transitionView].layer setBorderColor:[UIColor colorWithWhite:0.5 alpha:1].CGColor];
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0"))
    {
        [[self transitionView].layer setCornerRadius:10];
    }
    self.likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.likeButton setFrame:CGRectMake(10, 30, 80, 80)];
    [self.likeButton setBackgroundImage:[UIImage imageNamed:@"likeButton.png"] forState:UIControlStateNormal];
    [self.likeButton setBackgroundColor:[UIColor orangeColor]];
    self.likeButton.layer.cornerRadius = 15.0;
    self.likeButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.likeButton.layer.borderWidth = 3.0;
    [self.likeButton addTarget:self action:@selector(likeAction) forControlEvents:UIControlEventTouchDown];
    [self.transitionView addSubview:self.likeButton];
    
    self.likeButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.likeButton.frame.origin.x, self.likeButton.frame.origin.y + 85, self.likeButton.frame.size.width, 20)];
    [self.likeButtonLabel setText:NSLocalizedString(@"RecommendKey", nil)];
    [self.likeButtonLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:11 ]];
    [self.likeButtonLabel setTextColor:[UIColor whiteColor]];
    [self.likeButtonLabel setBackgroundColor:[UIColor clearColor]];
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0"))
    {
        [self.likeButtonLabel setMinimumScaleFactor:0.5];
    }
    else
    {
        [self.likeButtonLabel setMinimumFontSize:8.0];
    }
    self.likeButtonLabel.adjustsFontSizeToFitWidth = YES;
    [self.likeButtonLabel setTextAlignment:NSTextAlignmentCenter];
    [self.transitionView addSubview:self.likeButtonLabel];
    
    
    self.commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.commentButton setFrame:CGRectMake(220, 30, 80, 80)];
    [self.commentButton setBackgroundImage:[UIImage imageNamed:@"commentButton.png"] forState:UIControlStateNormal];
    [self.commentButton setBackgroundColor:[UIColor orangeColor]];
    self.commentButton.layer.cornerRadius = 15.0;
    self.commentButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.commentButton.layer.borderWidth = 3.0;
    [self.commentButton addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchDown];
    [self.transitionView addSubview:self.commentButton];
    
    self.commentButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.commentButton.frame.origin.x, self.commentButton.frame.origin.y + 85, self.commentButton.frame.size.width, 20)];
    [self.commentButtonLabel setText:NSLocalizedString(@"CommentKey", nil)];
    [self.commentButtonLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:11]];
    [self.commentButtonLabel setTextColor:[UIColor whiteColor]];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0"))
    {
        [self.commentButtonLabel setMinimumScaleFactor:0.5];
    }
    else
    {
        [self.commentButtonLabel setMinimumFontSize:8.0];
    }
    self.commentButtonLabel.adjustsFontSizeToFitWidth = YES;
    [self.commentButtonLabel setBackgroundColor:[UIColor clearColor]];
    [self.commentButtonLabel setTextAlignment:NSTextAlignmentCenter];
    [self.transitionView addSubview:self.commentButtonLabel];
    
    self.rateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rateButton setFrame:CGRectMake(115, 30, 80, 80)];
    [self.rateButton setBackgroundImage:[UIImage imageNamed:@"whiteStarButton.png"] forState:UIControlStateNormal];
    [self.rateButton setBackgroundColor:[UIColor orangeColor]];
    self.rateButton.layer.cornerRadius = 15.0;
    self.rateButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.rateButton.layer.borderWidth = 3.0;
    [self.rateButton addTarget:self action:@selector(rateAction) forControlEvents:UIControlEventTouchDown];
    [self.transitionView addSubview:self.rateButton];
    
    self.rateButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.rateButton.frame.origin.x, self.rateButton.frame.origin.y + 85, self.rateButton.frame.size.width, 20)];
    [self.rateButtonLabel setText:NSLocalizedString(@"RateKey", nil)];
    [self.rateButtonLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:11]];
    [self.rateButtonLabel setTextColor:[UIColor whiteColor]];
    [self.rateButtonLabel setBackgroundColor:[UIColor clearColor]];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0"))
    {
        [self.rateButtonLabel setMinimumScaleFactor:0.5];
    }
    else
    {
        [self.rateButtonLabel setMinimumFontSize:8.0];
    }
    self.rateButtonLabel.adjustsFontSizeToFitWidth = YES;
    [self.rateButtonLabel setTextAlignment:NSTextAlignmentCenter];
    [self.transitionView addSubview:self.rateButtonLabel];
    
    // stars buttons
    self.star1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.star1 setFrame:CGRectMake(self.transitionView.frame.size.width/2 - 145, 110, 50, 50)];
    
    self.star2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.star2 setFrame:CGRectMake(self.transitionView.frame.size.width/2 - 85, 110, 50, 50)];
    
    self.star3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.star3 setFrame:CGRectMake(self.transitionView.frame.size.width/2 - 25, 110, 50, 50)];
    
    self.star4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.star4 setFrame:CGRectMake(self.transitionView.frame.size.width/2 + 35, 110, 50, 50)];
    
    self.star5 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.star5 setFrame:CGRectMake(self.transitionView.frame.size.width/2 + 95, 110, 50, 50)];
    
    self.starsArray = [NSArray arrayWithObjects:self.star1, self.star2, self.star3, self.star4, self.star5, nil];
    for (int i = 0; i < self.starsArray.count; i++)
    {
        [[self.starsArray objectAtIndex:i] setTag:i+1];
        [self.transitionView addSubview:[self.starsArray objectAtIndex:i]];
        [[self.starsArray objectAtIndex:i] setAlpha:0];
        [[self.starsArray objectAtIndex:i]setUserInteractionEnabled:NO];
        [[self.starsArray objectAtIndex:i]addTarget:self action:@selector(chooseRateStar:) forControlEvents:UIControlEventTouchDown];
        [[self.starsArray objectAtIndex:i]setBackgroundImage:[UIImage imageNamed:@"whiteStarButton"] forState:UIControlStateNormal];
        ((UIButton*)[self.starsArray objectAtIndex:i]).adjustsImageWhenHighlighted = NO;
    }
    
    self.shareButton = [[UIBarButtonItem alloc] initWithTitle:@"Share" style:UIBarButtonItemStylePlain target:self action:@selector(shareButtonPressed:)];
    self.moreActionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(moreActions)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.moreActionButton,self.shareButton, nil];
    
    // вью с лайками и количеством комментариев
    self.likeView.layer.cornerRadius = 10;
    [self.likeView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6]];
    //вью со звездочками
    self.starView.layer.cornerRadius = 10;
    [self.starView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6]];
    
    [self.mainView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
    
    [self.productDescriptionWebView setBackgroundColor:[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:0.0]];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
    
    
    if ([[UIScreen mainScreen] bounds].size.height == 480)
    {
        self.detailScrollView.frame = CGRectMake(self.detailScrollView.frame.origin.x, self.detailScrollView.frame.origin.y, self.detailScrollView.frame.size.width, self.detailScrollView.frame.size.height - 88);
    }
    
    if(_isFromBrandCatalog)
    {
        self.priceLabel.text = self.productPrice;
        self.priceLabel.textAlignment = NSTextAlignmentCenter;
        self.priceLabel.hidden = NO;
        self.priceImage.hidden = NO;
        self.orderButton.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.commentsLabel.text = [NSString stringWithFormat:@"%d",self.commentsDetail];
    self.advisesLabel.text = [NSString stringWithFormat:@"%d",self.advisesDetail];
    self.productName.text = self.productSentName;
    self.ratingImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%dstar",self.ratingDetail]];
    [self.detailImage setImageWithURL:[NSURL URLWithString:self.productImageURL]];
    [self.productDescriptionWebView setOpaque:NO];
    [self.productDescriptionWebView setUserInteractionEnabled:NO];
    [self.productDescriptionWebView loadHTMLString:self.productSentDescription baseURL:nil];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.activityIndicatorView startAnimating];
    [self.activityIndicatorView setHidesWhenStopped:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.activityIndicatorView stopAnimating];
    [self.productDescriptionWebView sizeToFit];
    self.detailScrollView.contentSize = CGSizeMake(self.detailScrollView.contentSize.width, self.imageView.frame.size.height + self.productDescriptionWebView.frame.size.height + 50);
    [self.productDescriptionWebView setBackgroundColor:[UIColor clearColor]];
}

//необходим рефакторинг
//метод получения информации о продукте от сигвея
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
              andOffset:(int)offset
{
    self.productSentId = prodId;
    self.productSentName = name;
    self.productImageURL = imageURL;
    self.ratingDetail = rating;
    self.commentsDetail = comments;
    self.advisesDetail = advises;
    self.productSentDescription = descriptionText;
    
    self.numberInList = numberInList;
    self.brandId = brandId;
    self.categoryId = categoryId;
    
    self.detailProductOffset = offset;
}

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
               andPrice:(int)price
{
    self.productSentId = prodId;
    self.productSentName = name;
    self.productImageURL = imageURL;
    self.ratingDetail = rating;
    self.commentsDetail = comments;
    self.advisesDetail = advises;
    self.productSentDescription = descriptionText;
    
    self.numberInList = numberInList;
    self.categoryId = categoryId;
    self.detailProductOffset = offset;
    self.productPrice = [NSString stringWithFormat:@"%d", price];
    _isFromBrandCatalog = YES;
}
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
               andPrice:(int)price
{
    self.productSentId = prodId;
    self.productSentName = name;
    self.productImageURL = imageURL;
    self.ratingDetail = rating;
    self.commentsDetail = comments;
    self.advisesDetail = advises;
    self.productSentDescription = descriptionText;
    
    self.numberInList = numberInList;
    self.categoryId = categoryId;
    self.detailProductOffset = offset;
    self.productPrice = [NSString stringWithFormat:@"%d", price];
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toComments"])
    {
        if(_isFromBrandCatalog)
            [segue.destinationViewController sentProductId:self.productSentId isFromBonus:YES];
        else
            [segue.destinationViewController sentProductId:self.productSentId isFromBonus:NO];
    }
}

- (void)moreActions
{
    if (self.isImageDisplay)
    {
        [UIView transitionWithView:self.transitionContainerView duration:1 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
            self.imageView.hidden = YES;
            [self.transitionContainerView addSubview:self.transitionView];
            self.isImageDisplay = NO;
        } completion:nil];
    }
    else
    {
        [UIView transitionWithView:self.transitionContainerView duration:1 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            self.imageView.hidden = NO;
            [self.transitionView removeFromSuperview];
            self.isImageDisplay = YES;
        } completion:nil];
    }
}

- (void)commentAction:(UIButton*)sender
{
    if (self.rateButtonPressed) [self closeRateMenu];
    else [self performSegueWithIdentifier:@"toComments" sender:sender];
}
//метод вызываемый кнопками коммент и лайк при активной кнопки оценки. возвращает все на прежние места
- (void)closeRateMenu
{
    [UIView animateWithDuration:0.5 animations:^{
        [self.commentButton setFrame:CGRectMake(self.commentButton.frame.origin.x, self.commentButton.frame.origin.y + 25, self.commentButton.frame.size.width, self.commentButton.frame.size.height)];
        [self.commentButton setBackgroundColor:[UIColor orangeColor]];
        [self.commentButton setAlpha:1];
        
        [self.rateButton setFrame:CGRectMake(self.rateButton.frame.origin.x, self.rateButton.frame.origin.y + 25, self.rateButton.frame.size.width, self.rateButton.frame.size.height)];
        [self.rateButton setBackgroundImage:[UIImage imageNamed:@"whiteStarButton.png"] forState:UIControlStateNormal];
        [self.rateButton setBackgroundColor:[UIColor orangeColor]];
        self.rateButton.layer.borderColor = [UIColor whiteColor].CGColor;
        
        [self.likeButton setFrame:CGRectMake(self.likeButton.frame.origin.x, self.likeButton.frame.origin.y + 25, self.likeButton.frame.size.width, self.likeButton.frame.size.height)];
        [self.likeButton setBackgroundColor:[UIColor orangeColor]];
        [self.likeButton setAlpha:1];
        
        [self.rateButtonLabel setFrame:CGRectMake(self.rateButtonLabel.frame.origin.x, self.rateButtonLabel.frame.origin.y + 25, self.rateButtonLabel.frame.size.width, self.rateButtonLabel.frame.size.height)];
        [self.rateButtonLabel setText:NSLocalizedString(@"RateKey", nil)];
        
        [self.likeButtonLabel setFrame:CGRectMake(self.likeButtonLabel.frame.origin.x, self.likeButtonLabel.frame.origin.y + 25, self.likeButtonLabel.frame.size.width, self.likeButtonLabel.frame.size.height)];
        [self.likeButtonLabel setAlpha:1];
        
        [self.commentButtonLabel setFrame:CGRectMake(self.commentButtonLabel.frame.origin.x, self.commentButtonLabel.frame.origin.y + 25, self.commentButtonLabel.frame.size.width, self.commentButtonLabel.frame.size.height)];
        [self.commentButtonLabel setAlpha:1];
        
        for (int i =0; i < self.starsArray.count; i++)
        {
            [[self.starsArray objectAtIndex:i] setAlpha:0];
            [[self.starsArray objectAtIndex:i]setUserInteractionEnabled:NO];
        }
    }];
    self.rateButtonPressed = NO;
}

- (void)rateAction
{
    if (self.rateButtonPressed == NO)
    {
        [UIView animateWithDuration:0.5 animations:^{
            [self.commentButton setFrame:CGRectMake(self.commentButton.frame.origin.x, self.commentButton.frame.origin.y - 25, self.commentButton.frame.size.width, self.commentButton.frame.size.height)];
            [self.commentButton setBackgroundColor:[UIColor colorWithWhite:0.3 alpha:1]];
            [self.commentButton setAlpha:0.5];
            
            [self.rateButton setFrame:CGRectMake(self.rateButton.frame.origin.x, self.rateButton.frame.origin.y - 25, self.rateButton.frame.size.width, self.rateButton.frame.size.height)];
            [self.rateButton setBackgroundImage:[UIImage imageNamed:@"starButton.png"] forState:UIControlStateNormal];
            [self.rateButton setBackgroundColor:[UIColor whiteColor]];
            self.rateButton.layer.borderColor = [UIColor orangeColor].CGColor;
            
            [self.likeButton setFrame:CGRectMake(self.likeButton.frame.origin.x, self.likeButton.frame.origin.y - 25, self.likeButton.frame.size.width, self.likeButton.frame.size.height)];
            [self.likeButton setBackgroundColor:[UIColor colorWithWhite:0.3 alpha:1]];
            [self.likeButton setAlpha:0.5];
            
            [self.rateButtonLabel setFrame:CGRectMake(self.rateButtonLabel.frame.origin.x, self.rateButtonLabel.frame.origin.y - 25, self.rateButtonLabel.frame.size.width, self.rateButtonLabel.frame.size.height)];
            [self.rateButtonLabel setText:NSLocalizedString(@"ConfirmKey", nil)];
            
            [self.likeButtonLabel setFrame:CGRectMake(self.likeButtonLabel.frame.origin.x, self.likeButtonLabel.frame.origin.y - 25, self.likeButtonLabel.frame.size.width, self.likeButtonLabel.frame.size.height)];
            [self.likeButtonLabel setAlpha:0.3];
            
            [self.commentButtonLabel setFrame:CGRectMake(self.commentButtonLabel.frame.origin.x, self.commentButtonLabel.frame.origin.y - 25, self.commentButtonLabel.frame.size.width, self.commentButtonLabel.frame.size.height)];
            [self.commentButtonLabel setAlpha:0.3];
            
            for (int i =0; i < self.starsArray.count; i++)
            {
                [[self.starsArray objectAtIndex:i] setAlpha:1.0];
                [[self.starsArray objectAtIndex:i]setUserInteractionEnabled:YES];
            }
        }];
        self.rateButtonPressed = YES;
    }
    else
    {
        if (self.rateNumber == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Ошибка", nil) message:NSLocalizedString(@"MoreThan0StarKey", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            if (_isFromBrandCatalog == YES)
                [self.api sentBonusRate:self.rateNumber withProductId:self.productSentId];
            else
                [self.api sentRate:self.rateNumber withProductId:self.productSentId];
            [self closeRateMenu];
        }
    }
}

- (void)chooseRateStar:(UIButton*)sender
{
    for (int i = 0; i < self.starsArray.count; i++)
    {
        if ([[self.starsArray objectAtIndex:i] tag] <= sender.tag)
            [[self.starsArray objectAtIndex:i] setBackgroundImage:[UIImage imageNamed:@"starButton.png"] forState:UIControlStateNormal];
        else [[self.starsArray objectAtIndex:i] setBackgroundImage:[UIImage imageNamed:@"whiteStarButton.png"] forState:UIControlStateNormal];
    }
    self.rateNumber = sender.tag;
}

- (void)likeAction
{
    if (self.rateButtonPressed) [self closeRateMenu];
    else if (_isFromBrandCatalog)
        [self.api recommendBonusWithProductId:self.productSentId];
        else
        [self.api recommendWithProductId:self.productSentId];
}

#pragma mark Share Methods
- (MSShare *)share
{
    if (!_share) {
        _share = [[MSShare alloc] init];
    }
    return _share;
}

- (IBAction)shareButtonPressed:(id)sender
{
    if (self.shareIsPressed == NO)
    {
        [UIView animateWithDuration:0.5 animations:^{
            self.mainView.frame = CGRectMake(self.mainView.frame.origin.x, self.mainView.frame.origin.y + 35, self.mainView.frame.size.width, self.mainView.frame.size.height);
            self.vkButton.frame = CGRectMake(self.vkButton.frame.origin.x, self.vkButton.frame.origin.y + 35, self.vkButton.frame.size.width, self.vkButton.frame.size.height);
            self.fbButton.frame = CGRectMake(self.fbButton.frame.origin.x, self.fbButton.frame.origin.y + 35, self.fbButton.frame.size.width, self.fbButton.frame.size.height);
            self.twButton.frame = CGRectMake(self.twButton.frame.origin.x, self.twButton.frame.origin.y + 35, self.twButton.frame.size.width, self.twButton.frame.size.height);
        }];
        self.shareIsPressed = YES;
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:^{
            self.mainView.frame = CGRectMake(self.mainView.frame.origin.x, self.mainView.frame.origin.y - 35, self.mainView.frame.size.width, self.mainView.frame.size.height);
            self.vkButton.frame = CGRectMake(self.vkButton.frame.origin.x, self.vkButton.frame.origin.y - 35, self.vkButton.frame.size.width, self.vkButton.frame.size.height);
            self.fbButton.frame = CGRectMake(self.fbButton.frame.origin.x, self.fbButton.frame.origin.y -35, self.fbButton.frame.size.width, self.fbButton.frame.size.height);
            self.twButton.frame = CGRectMake(self.twButton.frame.origin.x, self.twButton.frame.origin.y -35, self.twButton.frame.size.width, self.twButton.frame.size.height);
        }];
        self.shareIsPressed = NO;
    }
}

- (void)convertingSharingInfoInDataFormat
{
    self.shareImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.productImageURL]];
    self.shareImage = [UIImage imageWithData:self.shareImageData];
    self.shareString = [NSString stringWithFormat:@"%@ \"%@\" %@ ",NSLocalizedString(@"ProductWasVerificatedKey", nil), self.productName.text, NSLocalizedString(@"WithAppKey", nil)];
}

- (IBAction)fbButtonPressed:(id)sender
{
    [self convertingSharingInfoInDataFormat];
    [[self share] shareOnFacebookWithText:self.shareString
                                withImage:self.shareImage
                    currentViewController:self];
}

- (IBAction)twButtonPressed:(id)sender
{
    [self convertingSharingInfoInDataFormat];
    [[self share] shareOnTwitterWithText:self.shareString 
                               withImage:self.shareImage
                   currentViewController:self];
}

- (IBAction)vkButtonPressed:(id)sender
{
    [self convertingSharingInfoInDataFormat];
    self.share.mainView = self;
    [[self share] shareOnVKWithText:self.shareString withImage:self.shareImage];
    [self.share attachPopUpAnimationForView:self.share.vkView];
}

- (IBAction)orderButtonAction:(id)sender
{
    [self.orderButton setUserInteractionEnabled:NO];
    self.orderBonusView = [[MSOrderBonusView alloc]initOrderMenuWithProductId:self.productSentId andPhoneNumber:[[NSUserDefaults standardUserDefaults]objectForKey:@"phoneNumber"]];
    [self.view.window addSubview:self.orderBonusView];
    [[self orderBonusView] attachPopUpAnimationForView:self.orderBonusView.orderContainerView];
    self.orderBonusView.delegate = self;
}

- (void)closeOrderMenu
{
    self.orderBonusView = nil;
    [self.orderButton setUserInteractionEnabled:YES];
}

#pragma mark - Login popUp
- (void)viewDidDisappear:(BOOL)animated  {
    if(self.loginView)
    {
        [self.loginView removeFromSuperview];
    }
}

- (void)dismissPopView:(BOOL)result
{
    if(result)
    {
        [self viewDidAppear:YES];
    }
    self.loginView = nil;
}

#pragma mark - Web Methods
- (MSAPI *) api
{
    if(!_api)
    {
        _api = [[MSAPI alloc]init];
        _api.delegate = self;
    }
    return _api;
}

- (void)finishedWithDictionary:(NSDictionary *)dictionary withTypeRequest:(requestTypes)type
{
    if ((type == kRate) || (type == kRecommend) || (type == kBonusRate) || (type == kBonusRecommend))
    {
        if ([[dictionary objectForKey:@"status"] isEqualToString:@"failed"])
        {
            if ([[dictionary objectForKey:@"message"] isKindOfClass:[NSDictionary class]])
            {
                NSString *messageTitle = [NSString stringWithFormat:@"%@",[[dictionary objectForKey:@"message"] objectForKey:@"title" ]];
                NSString *messageText = [NSString stringWithFormat:@"%@",[[dictionary objectForKey:@"message"] objectForKey:@"text" ]];
                UIAlertView *alert = [[UIAlertView  alloc] initWithTitle:messageTitle message:messageText delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
            else
            {
                NSString *message = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"message"]];
                UIAlertView *alert = [[UIAlertView  alloc] initWithTitle:message message:NSLocalizedString(@"NeedToLoginKey", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Отмена", nil) otherButtonTitles:@"OK", nil];
                [alert show];
            }
        }
        else
        {
            NSDictionary *recommendDictionary = [dictionary objectForKey:@"message"];
            UIAlertView *alert = [[UIAlertView  alloc] initWithTitle:[recommendDictionary objectForKey:@"title"] message:[recommendDictionary objectForKey:@"text"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            if (_isFromBrandCatalog)
                [self.api getBonusSubCategories:self.categoryId withOffset:self.detailProductOffset];
            else
                [self.api getProductsWithOffset:self.detailProductOffset withBrandId:self.brandId withCategoryId:self.categoryId];
        }
    }
    
    if ((type == kCatalog) || (type == kBonusSubCategories))
    {
//        self.commentsLabel.text = [NSString stringWithFormat:@"%@",[[[dictionary objectForKey:@"list"] objectAtIndex:self.numberInList]valueForKey: @"comments"]];
//        self.advisesLabel.text = [NSString stringWithFormat:@"%@",[[[dictionary objectForKey:@"list"] objectAtIndex:self.numberInList]valueForKey: @"advises"]];
//        self.ratingImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@star",[[[dictionary objectForKey:@"list"] objectAtIndex:self.numberInList] valueForKey:@"rating"]]];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        self.loginView = [[MSLogInView alloc]initWithOrigin:CGPointMake(25, self.view.frame.size.height/2 - 120)];
        [self.view addSubview:self.loginView];
        [self.loginView blackOutOfBackground];
        [self.loginView attachPopUpAnimationForView:self.loginView.loginView];
        self.loginView.delegate = self;
    }
}
- (void)viewDidUnload {
    [self setActivityIndicatorView:nil];
    [self setOrderButton:nil];
    [super viewDidUnload];
}
@end