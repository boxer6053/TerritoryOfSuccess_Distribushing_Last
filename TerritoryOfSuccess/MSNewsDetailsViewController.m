//
//  MSNewsDetailsViewController.m
//  TerritoryOfSuccess
//
//  Created by Alex on 1/21/13.
//  Copyright (c) 2013 Matrix Soft. All rights reserved.
//

#import "MSNewsDetailsViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>
#import "MSShare.h"
#import "SVProgressHUD.h"
#import <dispatch/dispatch.h>
#import "MSiOSVersionControlHeader.h"

@interface MSNewsDetailsViewController ()
{
    dispatch_queue_t backgroundQueue;
}

@property (nonatomic) MSAPI *dbApi;
@property (nonatomic) BOOL shareButtonsShowed;
@property (strong, nonatomic) MSShare *share;
@property (strong, nonatomic) NSData *shareImageData;
@property (strong, nonatomic) UIImage *shareImage;
@property (strong, nonatomic) NSURL *imageUrl;

@end

@implementation MSNewsDetailsViewController

@synthesize dbApi = _dbApi;
@synthesize shareButtonsShowed = _shareButtonsShowed;
@synthesize articleTextWebView = _articleTextWebView;
@synthesize articleImageView = _articleImageView;
@synthesize articleTitleLabel = _articleTitleLabel;
@synthesize articleScrollView = _articleScrollView;
@synthesize articleShareButton = _articleShareButton;
@synthesize articleShareFbButton = _articleShareFbButton;
@synthesize articleShareTwButton = _articleShareTwButton;
@synthesize articleShareVkButton = _articleShareVkButton;
@synthesize share = _share;
@synthesize shareImageData = _shareImageData;
@synthesize shareImage = _shareImage;
@synthesize imageUrl = _imageUrl;
@synthesize articleActivityIndicator = _articleActivityIndicator;

- (MSAPI *)dbApi
{
    if(!_dbApi)
    {
        _dbApi = [[MSAPI alloc]init];
        _dbApi.delegate = self;
    }
    return _dbApi;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
//        [self.navigationController.navigationBar setFrame:CGRectMake(0, 0, 320, 64)];
    }
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
    }
    else
    {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
        self.articleActivityIndicator.frame = CGRectMake(self.articleActivityIndicator.frame.origin.x, self.articleActivityIndicator.frame.origin.y-50, self.articleActivityIndicator.frame.size.width, self.articleActivityIndicator.frame.size.height);
    }
    
    self.shareButtonsShowed = NO;
    self.articleScrollView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.0];
    self.articleTextWebView.backgroundColor = [UIColor clearColor];
    self.articleTextWebView.opaque = NO;
    self.articleTextWebView.hidden = YES;
    self.articleActivityIndicator.hidesWhenStopped = YES;
   // self.articleScrollView.layer.cornerRadius = 10.0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveOKClicked:)
                                                 name:@"FailConnectionAllertClickedOK"
                                               object:nil];
    
	// Do any additional setup after loading the view.
}

- (void)receiveOKClicked:(NSNotification *)notification
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Share Methods

- (MSShare *)share
{
    if (!_share) {
        _share = [[MSShare alloc] init];
    }
    return _share;
}

- (void)convertingSharingInfoInDataFormat
{
    self.shareImageData = [NSData dataWithContentsOfURL:self.imageUrl];
    self.shareImage = [UIImage imageWithData:self.shareImageData];
}
- (IBAction)vkButtonPressed:(id)sender
{
    [self convertingSharingInfoInDataFormat];
    self.share.mainView = self;
    [[self share] shareOnVKWithText:self.articleBriefTextView.text withImage:self.shareImage];
        [self.share attachPopUpAnimationForView:self.share.vkView];
}

- (IBAction)twbButtonPressed:(id)sender
{
    [self convertingSharingInfoInDataFormat];
    [[self share] shareOnTwitterWithText:self.articleBriefTextView.text
                               withImage:self.shareImage
                   currentViewController:self];

}

- (IBAction)fbButtonPressed:(id)sender
{
    [self convertingSharingInfoInDataFormat];
    [[self share] shareOnFacebookWithText:self.articleBriefTextView.text
                                withImage:self.shareImage
                    currentViewController:self];
}

- (IBAction)shareButtonPressed:(id)sender
{
    if (!self.shareButtonsShowed)
    {
        self.shareButtonsShowed = YES;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25];
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        {
            self.articleShareVkButton.frame = CGRectMake(self.articleShareVkButton.frame.origin.x, self.articleShareVkButton.frame.origin.y + 35 + 64, self.articleShareVkButton.frame.size.width, self.articleShareVkButton.frame.size.height);
            self.articleShareTwButton.frame = CGRectMake(self.articleShareTwButton.frame.origin.x, self.articleShareTwButton.frame.origin.y + 35 + 64, self.articleShareTwButton.frame.size.width, self.articleShareTwButton.frame.size.height);
            self.articleShareFbButton.frame = CGRectMake(self.articleShareFbButton.frame.origin.x, self.articleShareFbButton.frame.origin.y + 35 + 64, self.articleShareFbButton.frame.size.width, self.articleShareFbButton.frame.size.height);
            self.articleScrollView.frame = CGRectMake(0, 35, self.articleScrollView.frame.size.width, self.articleScrollView.frame.size.height);
        }
        else
        {
            self.articleShareVkButton.frame = CGRectMake(self.articleShareVkButton.frame.origin.x, self.articleShareVkButton.frame.origin.y + 35, self.articleShareVkButton.frame.size.width, self.articleShareVkButton.frame.size.height);
            self.articleShareTwButton.frame = CGRectMake(self.articleShareTwButton.frame.origin.x, self.articleShareTwButton.frame.origin.y + 35, self.articleShareTwButton.frame.size.width, self.articleShareTwButton.frame.size.height);
            self.articleShareFbButton.frame = CGRectMake(self.articleShareFbButton.frame.origin.x, self.articleShareFbButton.frame.origin.y + 35, self.articleShareFbButton.frame.size.width, self.articleShareFbButton.frame.size.height);
            self.articleScrollView.frame = CGRectMake(0, 35, self.articleScrollView.frame.size.width, self.articleScrollView.frame.size.height);
        }
        [UIView commitAnimations];
    }
    else
    {
        self.shareButtonsShowed = NO;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25];
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        {
            self.articleShareVkButton.frame = CGRectMake(self.articleShareVkButton.frame.origin.x, self.articleShareVkButton.frame.origin.y - 35 - 64, self.articleShareVkButton.frame.size.width, self.articleShareVkButton.frame.size.height);
            self.articleShareTwButton.frame = CGRectMake(self.articleShareTwButton.frame.origin.x, self.articleShareTwButton.frame.origin.y - 35 - 64, self.articleShareTwButton.frame.size.width, self.articleShareTwButton.frame.size.height);
            self.articleShareFbButton.frame = CGRectMake(self.articleShareFbButton.frame.origin.x, self.articleShareFbButton.frame.origin.y - 35 - 64, self.articleShareFbButton.frame.size.width, self.articleShareFbButton.frame.size.height);
            self.articleScrollView.frame = CGRectMake(0, 0, self.articleScrollView.frame.size.width, self.articleScrollView.frame.size.height);
        }
        else
        {
            self.articleShareVkButton.frame = CGRectMake(self.articleShareVkButton.frame.origin.x, self.articleShareVkButton.frame.origin.y - 35, self.articleShareVkButton.frame.size.width, self.articleShareVkButton.frame.size.height);
            self.articleShareTwButton.frame = CGRectMake(self.articleShareTwButton.frame.origin.x, self.articleShareTwButton.frame.origin.y - 35, self.articleShareTwButton.frame.size.width, self.articleShareTwButton.frame.size.height);
            self.articleShareFbButton.frame = CGRectMake(self.articleShareFbButton.frame.origin.x, self.articleShareFbButton.frame.origin.y - 35, self.articleShareFbButton.frame.size.width, self.articleShareFbButton.frame.size.height);
            self.articleScrollView.frame = CGRectMake(0, 0, self.articleScrollView.frame.size.width, self.articleScrollView.frame.size.height);
        }
        [UIView commitAnimations];
    }
}

- (void)setContentOfArticleWithId:(NSString *)articleId
{
    [self.dbApi getNewsWithId:articleId];
    [SVProgressHUD showWithStatus:NSLocalizedString(@"DownloadingInformationKey",nil)];
}

-(void)finishedWithDictionary:(NSDictionary *)dictionary withTypeRequest:(requestTypes)type
{
    if (type == kNewsWithId)
    {
        
        [self.articleActivityIndicator startAnimating];
        self.imageUrl = [NSURL URLWithString: [[dictionary valueForKey:@"post"] valueForKey:@"image"]];
        [self.articleImageView setImageWithURL:self.imageUrl placeholderImage:[UIImage imageNamed:@"placeholder_622*415.png"]];
        [self.articleImageView.layer setCornerRadius:5.0];
        self.articleTitleLabel.text = [[dictionary valueForKey:@"post"] valueForKey:@"title"];
        
        //change iframe size for youtube video

        NSString *articleText = [[dictionary valueForKey:@"post"] valueForKey:@"content"];
        articleText  = [articleText stringByReplacingOccurrencesOfString:@"width=\"327\" height=\"245\"></iframe>" withString:@"width=\"300\" height=\"224\"></iframe>"];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0), ^{[self.articleTextWebView loadHTMLString:[NSString stringWithFormat:@"<div background-color:transparent>%@<div>",articleText] baseURL:nil];});
        
        self.articleBriefTextView.text = [[dictionary valueForKey:@"post"] valueForKey:@"brief"];
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        {
            [self.articleBriefTextView sizeToFit];
            [self.articleBriefTextView layoutIfNeeded];
        }
        self.articleDateLabel.text = [[dictionary valueForKey:@"post"] valueForKey:@"date"];
        self.articleBriefTextView.frame = CGRectMake(self.articleBriefTextView.frame.origin.x, self.articleBriefTextView.frame.origin.y, 310, self.articleBriefTextView.contentSize.height);
        self.articleBriefTextView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    }
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.articleActivityIndicator stopAnimating];
    [self.articleTextWebView sizeToFit];
    self.articleTextWebView.frame = CGRectMake(self.articleTextWebView.frame.origin.x, self.articleBriefTextView.frame.origin.y + self.articleBriefTextView.frame.size.height, 320, self.articleTextWebView.frame.size.height);
    self.articleScrollView.contentSize= CGSizeMake(self.articleScrollView.contentSize.width, self.articleTextWebView.frame.origin.y + self.articleTextWebView.frame.size.height + 5);
    self.articleTextWebView.hidden = NO;
    //[SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"DownloadIsCompletedKey",nil)];
}
@end
