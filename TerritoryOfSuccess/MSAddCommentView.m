#import "MSAddCommentView.h"
#import <QuartzCore/QuartzCore.h>
#import "MSiOSVersionControlHeader.h"

@interface MSAddCommentView()
{
    BOOL isFromBonus;
}
@property (nonatomic) MSAPI *api;
@property (strong, nonatomic) UITextView *inputCommentTextView;
@property (strong, nonatomic) UIButton *sentButton;
@property (strong, nonatomic) UILabel *headerTitle;
@property (strong, nonatomic) UIImageView *headerImageView;
@property (strong, nonatomic) UIButton *closeButton;
@property (strong, nonatomic) NSDictionary *messageDictionary;
@end

@implementation MSAddCommentView

@synthesize commentBackgroundView = _commentBackgroundView;
@synthesize commentView = _commentView;
@synthesize api = _api;
@synthesize headerImageView = _headerImageView;
@synthesize inputCommentTextView = _inputCommentTextView;
@synthesize closeButton = _closeButton;
@synthesize sentButton = _sentButton;
@synthesize productId = _productId;
@synthesize headerTitle = _headerTitle;
@synthesize containerView = _containerView;
@synthesize delegate = _delegate;
@synthesize messageDictionary = _messageDictionary;

- (id)initCommentAdder
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self)
    {
        self.commentBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320 ,568)];
        [[self commentBackgroundView] setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
        [UIView animateWithDuration:0.3 animations:^{
            [[self commentBackgroundView] setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
        }];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeAddingCommentSubview)];
        [self.commentBackgroundView addGestureRecognizer:tap];
        [self addSubview:[self commentBackgroundView]];
        
        self.containerView = [[UIView alloc]initWithFrame:CGRectMake(10, 100, [UIScreen mainScreen].bounds.size.width - 20, 310)];
        [self addSubview:[self containerView]];
        
        self.commentView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, [UIScreen mainScreen].bounds.size.width - 20, 300)];
        [[self commentView] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"dialogViewGradient.png"]]];
        [[self commentView].layer setBorderWidth:2.0f];
        [[self commentView].layer setBorderColor:[UIColor colorWithWhite:0.5 alpha:1].CGColor];
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0"))
        {
            [[self commentView].layer setCornerRadius:10];
        }
        [[self containerView] addSubview:[self commentView]];

        UIImage *headerImage = [UIImage imageNamed:@"TOS cap.png"];
        self.headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(51, 6, 198, 33)];
        [self.headerImageView setImage:headerImage];
        [[self containerView] addSubview:[self headerImageView]];
        
        self.headerTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 178, 20)];
        [self.headerTitle setText:NSLocalizedString(@"YourCommentKey", nil)];
        self.headerTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
        [self.headerTitle setTextColor:[UIColor whiteColor]];
        [self.headerTitle setBackgroundColor:[UIColor clearColor]];
        [self.headerTitle setTextAlignment:NSTextAlignmentCenter];
        [[self headerImageView] addSubview:[self headerTitle]];
        
        self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.closeButton setFrame:CGRectMake(278, 8, 15, 15)];
        [self.closeButton setBackgroundImage:[UIImage imageNamed:@"closeIcon.png"] forState:UIControlStateNormal];
        [self.closeButton addTarget:self action:@selector(closeAddingCommentSubview) forControlEvents:UIControlEventTouchDown];
        [self.commentView addSubview:self.closeButton];
        
        self.sentButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.sentButton setFrame:CGRectMake(self.containerView.frame.size.width/2 - 60, self.commentView.frame.size.height - 45, 120, 35)];
        [self.sentButton setBackgroundImage:[UIImage imageNamed:@"button_120*35_new.png"] forState:UIControlStateNormal];
        [self.sentButton setTitle:NSLocalizedString(@"SendKey", nil) forState:UIControlStateNormal];
        [self.sentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.sentButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
        [self.sentButton addTarget:self action:@selector(sentComment) forControlEvents:UIControlEventTouchDown];
        [self.commentView addSubview:self.sentButton];
        
        self.inputCommentTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, self.headerImageView.frame.size.height + 10, 280, 200)];
        self.inputCommentTextView.returnKeyType = UIReturnKeyDone;
        self.inputCommentTextView.delegate = self;
        self.inputCommentTextView.text = NSLocalizedString(@"writeWhatYouThinkKey", nil);
        self.inputCommentTextView.font = [UIFont fontWithName:@"Helvetica" size:18.0];
        self.inputCommentTextView.layer.cornerRadius = 10;
        self.inputCommentTextView.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:1].CGColor;
        self.inputCommentTextView.layer.borderWidth = 1.0f;
        self.inputCommentTextView.layer.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1].CGColor;
        self.inputCommentTextView.autocorrectionType = UITextAutocorrectionTypeNo;
        self.inputCommentTextView.textColor = [UIColor lightGrayColor];
        [self.commentView addSubview:self.inputCommentTextView];
    }
    return self;
}

- (void)closeAddingCommentSubview
{
    [UIView animateWithDuration:0.4 animations:^{
        [self.commentBackgroundView setAlpha:0];
        [self.commentView setAlpha:0];
        [self.headerImageView setAlpha:0];
    } completion:^(BOOL finished){
        [self removeFromSuperview];
        [self.delegate closeAddingCommentSubviewWithAdditionalActions];
    }];
}

- (void)setProductId:(int)productId isFromBonus:(BOOL)bonus
{
    _productId = productId;
    isFromBonus = bonus;
}

- (void)sentComment
{
    if(![[NSUserDefaults standardUserDefaults] valueForKey:@"authorization_Token"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Ошибка", nil) message:NSLocalizedString(@"NeedToAuthorizedKey", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    } else if ([self.inputCommentTextView.text isEqualToString:NSLocalizedString(@"writeWhatYouThinkKey", nil)])
    {
        NSString *message = NSLocalizedString(@"YouShouldEnterCommentKey", nil);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Ошибка", nil) message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }else
    {
        if (isFromBonus == YES)
             [self.api sentBonusCommentWithProductId:self.productId andText:self.inputCommentTextView.text];
        else
            [self.api sentCommentWithProductId:self.productId andText:self.inputCommentTextView.text];
        [self closeAddingCommentSubview];
    }
}

#pragma mark Text View
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if([self.inputCommentTextView.text isEqualToString:NSLocalizedString(@"writeWhatYouThinkKey", nil)])
        self.inputCommentTextView.text = @"";
    self.inputCommentTextView.textColor = [UIColor blackColor];
    
    if ([UIScreen mainScreen].bounds.size.height == 480)
    {
        [UIView animateWithDuration:0.5 animations:^{
            self.containerView.frame = CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width - 20, 310);
        }];
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([self.inputCommentTextView.text isEqualToString:@""])
    {
        self.inputCommentTextView.text = NSLocalizedString(@"writeWhatYouThinkKey", nil);
        self.inputCommentTextView.textColor = [UIColor lightGrayColor];
    }
    
    if ([UIScreen mainScreen].bounds.size.height == 480)
    {
        [UIView animateWithDuration:0.5 animations:^{
            self.containerView.frame = CGRectMake(10, 100, [UIScreen mainScreen].bounds.size.width - 20, 310);
        }];
    }
    
}
// ввод текста комментария
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSCharacterSet *doneButtonCharacterSet = [NSCharacterSet newlineCharacterSet];
    NSRange replacementTextRange = [text rangeOfCharacterFromSet:doneButtonCharacterSet];
    NSUInteger location = replacementTextRange.location;
    
    if (textView.text.length + text.length > 255)
    {
        if (location != NSNotFound)
        {
            [textView resignFirstResponder];
        }
        return NO;
    }
    
    else if (location != NSNotFound)
    {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

#pragma mark Web Methods
- (MSAPI *)api
{
    if (!_api) {
        _api = [[MSAPI alloc] init];
        _api.delegate = self;
    }
    return _api;
}

- (void)finishedWithDictionary:(NSDictionary *)dictionary withTypeRequest:(requestTypes)type
{
    if ([[dictionary objectForKey:@"status"] isEqualToString:@"failed"])
    {
        NSString *message = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"message"]];
        UIAlertView *alert = [[UIAlertView  alloc] initWithTitle:message message:NSLocalizedString(@"NeedToLoginKey", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        self.messageDictionary = [dictionary valueForKey:@"message"];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[self.messageDictionary valueForKey:@"title"] message:[self.messageDictionary valueForKey:@"text"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}
@end