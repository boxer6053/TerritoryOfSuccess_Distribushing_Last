#import "MSOrderBonusView.h"
#import "MSiOSVersionControlHeader.h"
#import <QuartzCore/QuartzCore.h>

@interface MSOrderBonusView()
@property (strong, nonatomic) MSAPI *api;
@property (strong, nonatomic) UIView *orderBackgroundView;
@property (strong, nonatomic) UIView *orderView;
@property (strong, nonatomic) UILabel *orderHeaderTitle;
@property (strong, nonatomic) UIImageView *headerImageView;
@property (strong, nonatomic) UIButton *closeButton;
@property (strong, nonatomic) UIButton *orderButton;
@property (strong, nonatomic) UILabel *tipLabel;
@property (strong, nonatomic) UITextField *phoneTextField;

@property (nonatomic) int productId;

@end

@implementation MSOrderBonusView
@synthesize api = _api;
@synthesize delegate = _delegate;
@synthesize productId = _productId;

- (id)initOrderMenuWithProductId:(int)prodId andPhoneNumber:(NSString *)phone
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    self.productId = prodId;
    if (self)
    {
        self.orderBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320 ,568)];
        [[self orderBackgroundView] setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
        [UIView animateWithDuration:0.3 animations:^{
            [[self orderBackgroundView] setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
        }];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeOrderSubview)];
        [self.orderBackgroundView addGestureRecognizer:tap];
        [self addSubview:[self orderBackgroundView]];
        
        self.orderContainerView = [[UIView alloc]initWithFrame:CGRectMake(10, 100, [UIScreen mainScreen].bounds.size.width - 20, 160)];
        [self addSubview:[self orderContainerView]];
        
        self.orderView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, [UIScreen mainScreen].bounds.size.width - 20, 150)];
        [[self orderView] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"dialogViewGradient.png"]]];
        [[self orderView].layer setBorderWidth:2.0f];
        [[self orderView].layer setBorderColor:[UIColor colorWithWhite:0.5 alpha:1].CGColor];
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0"))
        {
            [[self orderView].layer setCornerRadius:10];
        }
        [[self orderContainerView] addSubview:[self orderView]];
        
        UIImage *headerImage = [UIImage imageNamed:@"TOS cap.png"];
        self.headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(51, 6, 198, 33)];
        [self.headerImageView setImage:headerImage];
        [[self orderContainerView] addSubview:[self headerImageView]];
        
        self.orderHeaderTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 178, 20)];
        [self.orderHeaderTitle setText:NSLocalizedString(@"MakingOrderKey", nil)];
        self.orderHeaderTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
        [self.orderHeaderTitle setTextColor:[UIColor whiteColor]];
        [self.orderHeaderTitle setBackgroundColor:[UIColor clearColor]];
        [self.orderHeaderTitle setTextAlignment:NSTextAlignmentCenter];
        [[self headerImageView] addSubview:[self orderHeaderTitle]];
        
        self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.closeButton setFrame:CGRectMake(278, 8, 15, 15)];
        [self.closeButton setBackgroundImage:[UIImage imageNamed:@"closeIcon.png"] forState:UIControlStateNormal];
        [self.closeButton addTarget:self action:@selector(closeOrderSubview) forControlEvents:UIControlEventTouchDown];
        [self.orderView addSubview:self.closeButton];
        
        self.orderButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.orderButton setFrame:CGRectMake(self.orderView.frame.size.width/2 - 50, self.orderView.frame.size.height - 45, 100, 35)];
        [self.orderButton setBackgroundImage:[UIImage imageNamed:@"button_120*35_new.png"] forState:UIControlStateNormal];
        [self.orderButton setTitle:NSLocalizedString(@"SendKey", nil) forState:UIControlStateNormal];
        [self.orderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.orderButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
        [self.orderButton addTarget:self action:@selector(makeOrder) forControlEvents:UIControlEventTouchDown];
        [self.orderView addSubview:self.orderButton];
        
        self.phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, self.orderButton.frame.origin.y - 40, 280, 30)];
        [self.phoneTextField setBorderStyle:UITextBorderStyleRoundedRect];
        [self.phoneTextField setBackgroundColor:[UIColor whiteColor]];
        [self.phoneTextField setText:phone];
        [self.phoneTextField setKeyboardType:UIKeyboardTypePhonePad];
        [self.orderView addSubview:self.phoneTextField];
        
        self.tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, self.phoneTextField.frame.origin.y - 30, 280, 25)];
        self.tipLabel.text = NSLocalizedString(@"EnterYoutPhoneNumberKey", nil);
        [self.tipLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14.0]];
        [self.tipLabel setTextColor:[UIColor whiteColor]];
        [self.tipLabel setBackgroundColor:[UIColor clearColor]];
        [self.orderView addSubview:self.tipLabel];
    }
    return self;
}

- (void)makeOrder
{
    if (self.phoneTextField.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Ошибка", nil) message:NSLocalizedString(@"EnterYourPhoneNumberKey", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        [self.api orderBonusProductWithProductId:self.productId andPhoneNumber:self.phoneTextField.text];
        [self closeOrderSubview];
    }
}

- (void)closeOrderSubview
{
    [UIView animateWithDuration:0.4 animations:^{
        [self.orderBackgroundView setAlpha:0];
        [self.orderView setAlpha:0];
        [self.headerImageView setAlpha:0];
    } completion:^(BOOL finished){
        [self removeFromSuperview];
        [self.delegate closeOrderMenu];
    }];
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
    if (type == kOrderBonus)
    {
        NSDictionary *messageDictionary = [dictionary valueForKey:@"message"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[messageDictionary valueForKey:@"title"] message:[messageDictionary valueForKey:@"text"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}
@end
