#import "MSShare.h"
#import "Vkontakte.h"
#import <QuartzCore/QuartzCore.h>
#import "MSiOSVersionControlHeader.h"

@interface MSShare()
@property (nonatomic, strong) SLComposeViewController *slComposeSheet;
@property (nonatomic) Vkontakte *vkontakte;
@property (nonatomic) UIButton *loginVKButton;
@property (nonatomic) UIButton *postVKButton;
@property (nonatomic) NSString *postTextVK;
@property (nonatomic, strong) UIImage *postImageVK;
@end

@implementation MSShare
@synthesize vkontakte = _vkontakte;
@synthesize slComposeSheet = _slComposeSheet;
@synthesize loginVKButton = _loginVKButton;
@synthesize postVKButton = _postVKButton;
@synthesize vkView = _vkView;
@synthesize vkBackgroundView = _vkBackgroundView;
@synthesize mainView = _mainView;
@synthesize postImageVK = _postImageVK;
@synthesize postTextVK = _postTextVK;

- (void)shareOnFacebookWithText:(NSString *)shareText
                      withImage:(UIImage *)shareImage
          currentViewController:(UIViewController *)viewController;
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0"))
    {
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
        {
            self.slComposeSheet = [[SLComposeViewController alloc]init];
            self.slComposeSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            [self.slComposeSheet setInitialText:shareText];
            [self.slComposeSheet addImage:shareImage];
            [self.slComposeSheet addURL:[NSURL URLWithString:@"http://id-bonus.com"]];
            [viewController presentViewController:self.slComposeSheet animated:YES completion:nil];
            [self slComposeSheetHandlerMethod];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ErrorKey", nil) message:NSLocalizedString(@"YouNeedToLoginInSettingsKey", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SorryKey", nil) message:NSLocalizedString(@"DontAvailableOnThisVersionKey", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)shareOnTwitterWithText:(NSString *)shareText
                     withImage:(UIImage *)shareImage
         currentViewController:(UIViewController *)viewController;
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0"))
    {
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
        {
            self.slComposeSheet = [[SLComposeViewController alloc]init];
            self.slComposeSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            [self.slComposeSheet setInitialText:shareText];
            [self.slComposeSheet addImage:shareImage];
            [self.slComposeSheet addURL:[NSURL URLWithString:@"http://id-bonus.com"]];
            [viewController presentViewController:self.slComposeSheet animated:YES completion:nil];
            [self slComposeSheetHandlerMethod];
            
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ErrorKey", nil) message:NSLocalizedString(@"YouNeedToLoginInSettingsKey", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SorryKey", nil) message:NSLocalizedString(@"DontAvailableOnThisVersionKey", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void) slComposeSheetHandlerMethod
{
    [self.slComposeSheet setCompletionHandler:^(SLComposeViewControllerResult result)
     {
         switch (result)
         {
             case SLComposeViewControllerResultCancelled:
                 break;
                 
             case SLComposeViewControllerResultDone:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Facebook" message:NSLocalizedString(@"PostedSuccessfullyKey",nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [alertView show];
             }
                 break;
         }
     }];
    
}
- (void)shareOnVKWithText:(NSString *)shareText withImage:(UIImage *)shareImage
{
    _vkontakte = [Vkontakte sharedInstance];
    _vkontakte.delegate = self;
    self.postTextVK = shareText;
    self.postImageVK = shareImage;
    
    self.vkBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height)];
    [self.vkBackgroundView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
    [UIView animateWithDuration:0.5 animations:^
     {
         [self.vkBackgroundView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
     }];
    [self.mainView.view addSubview:self.vkBackgroundView];
    
    UITapGestureRecognizer *singleCloseTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeVKView)];
    [self.vkBackgroundView addGestureRecognizer:singleCloseTap];
    
    if ([[UIScreen mainScreen] bounds].size.height == 568)
    {
        self.vkView = [[UIView alloc] initWithFrame:CGRectMake(70, 110, 180, 195)];
    }
    else
    {
        self.vkView = [[UIView alloc] initWithFrame:CGRectMake(70, 70, 180, 195)];
    }
    [[self vkView] setBackgroundColor:[UIColor whiteColor]];
    [[self vkView] setAlpha:0];
    [self.vkView.layer setBorderColor:[UIColor colorWithRed:75/255.0 green:110/255.0 blue:148/255.0 alpha:0].CGColor];
    [UIView animateWithDuration:0.4 animations:^
     {
         [[self vkView]setAlpha:1];
     }];
    [self.vkView.layer setCornerRadius:10];
    [self.vkView.layer setBorderWidth:1.0f];
    self.vkView.clipsToBounds = YES;
    [self.mainView.view addSubview:self.vkView];
    
    UIImageView *vkHeaderImage = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"vkHeader.png"]];
    vkHeaderImage.frame = CGRectMake(0, 0, 180, 45);
    [self.vkView addSubview:vkHeaderImage];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"cancelVKButton.png"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(closeVKView) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.frame = CGRectMake(162, 3, 15, 15);
    cancelButton.hidden = NO;
    [self.vkView addSubview:cancelButton];
    
    self.loginVKButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.loginVKButton setBackgroundImage:[UIImage imageNamed:@"vkActionButton.png"] forState:UIControlStateNormal];
    [self.loginVKButton addTarget:self action:@selector(loginPressed) forControlEvents:UIControlEventTouchUpInside];
    self.loginVKButton.hidden = NO;
    [self.vkView addSubview:self.loginVKButton];
    [self refreshButtonState];
    
    self.postVKButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.postVKButton addTarget:self action:@selector(post) forControlEvents:UIControlEventTouchUpInside];
    self.postVKButton.frame = CGRectMake (self.vkView.frame.size.width/2 - 58, 130, 117, 27);
    [self.postVKButton setBackgroundImage:[UIImage imageNamed:@"vkActionButton.png"] forState:UIControlStateNormal];
    if (![_vkontakte isAuthorized])
        self.postVKButton.hidden = YES;
    else self.postVKButton.hidden = NO;
    [self.postVKButton setTitle:NSLocalizedString(@"PostKey",nil) forState:UIControlStateNormal];
    [self.vkView addSubview:self.postVKButton];
}

- (void)closeVKView
{
    [UIView animateWithDuration:0.4 animations:^{
        [self.vkBackgroundView setAlpha:0];
        [self.vkView setAlpha:0];
    } completion:^(BOOL finished){
        [[self vkBackgroundView] removeFromSuperview];
        [[self vkView]removeFromSuperview];
    }];
    
}

- (void)refreshButtonState
{
    if (![_vkontakte isAuthorized])
    {
        self.loginVKButton.frame = CGRectMake(self.vkView.frame.size.width/2 - 58, 100, 117, 27);
        [self.loginVKButton setTitle:NSLocalizedString(@"LogInKey",nil)
                            forState:UIControlStateNormal];
        self.postVKButton.hidden = YES;
    }
    else
    {
        self.loginVKButton.frame = CGRectMake(self.vkView.frame.size.width/2 - 58, 70, 117, 27);
        [self.loginVKButton setTitle:NSLocalizedString(@"LogOutKey",nil)
                            forState:UIControlStateNormal];
        self.postVKButton.hidden = NO;
    }
}

- (void)loginPressed
{
    if (![_vkontakte isAuthorized])
    {
        [_vkontakte authenticate];
    }
    else
    {
        [_vkontakte logout];
    }
}

- (void)post
{
    [_vkontakte postImageToWall:self.postImageVK
                           text:self.postTextVK
                           link:[NSURL URLWithString:@"http://id-bonus.com"]];
}

- (void)vkontakteDidFinishPostingToWall:(NSDictionary *)responce
{
    UIAlertView *alertVK = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"PostedSuccessfullyKey",nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertVK show];
    [self.vkView removeFromSuperview];
    [[self vkBackgroundView] removeFromSuperview];
}

#pragma mark - VkontakteDelegate

- (void)vkontakteDidFailedWithError:(NSError *)error
{
    [[self mainView] dismissViewControllerAnimated:YES completion:nil];
}

- (void)showVkontakteAuthController:(UIViewController *)controller
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        controller.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    
    [[self mainView] presentViewController:controller animated:YES completion:nil];
    
}

- (void)vkontakteAuthControllerDidCancelled
{
    [[self mainView] dismissViewControllerAnimated:YES completion:nil];
}

- (void)vkontakteDidFinishLogin:(Vkontakte *)vkontakte
{
    [[self mainView] dismissViewControllerAnimated:YES completion:nil];
    [self refreshButtonState];
}

- (void)vkontakteDidFinishLogOut:(Vkontakte *)vkontakte
{
    [self refreshButtonState];
}
@end
