//
//  MSNewsDetailsViewController.h
//  TerritoryOfSuccess
//
//  Created by Alex on 1/21/13.
//  Copyright (c) 2013 Matrix Soft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSAPI.h"

@interface MSNewsDetailsViewController : UIViewController <UIWebViewDelegate, WsCompleteDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *articleImageView;
@property (weak, nonatomic) IBOutlet UILabel *articleTitleLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *articleScrollView;
@property (weak, nonatomic) IBOutlet UITextView *articleBriefTextView;
@property (weak, nonatomic) IBOutlet UILabel *articleDateLabel;
@property (weak, nonatomic) IBOutlet UIWebView *articleTextWebView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *articleShareButton;
@property (weak, nonatomic) IBOutlet UIButton *articleShareVkButton;
@property (weak, nonatomic) IBOutlet UIButton *articleShareTwButton;
@property (weak, nonatomic) IBOutlet UIButton *articleShareFbButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *articleActivityIndicator;

- (IBAction)vkButtonPressed:(id)sender;
- (IBAction)twbButtonPressed:(id)sender;
- (IBAction)fbButtonPressed:(id)sender;

- (IBAction)shareButtonPressed:(id)sender;
-(void)setContentOfArticleWithId:(NSString *)articleId;

@end
