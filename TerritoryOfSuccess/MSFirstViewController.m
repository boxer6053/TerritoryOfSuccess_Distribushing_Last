//
//  MSFirstViewController.m
//  TerritoryOfSuccess
//
//  Created by Matrix Soft on 1/8/13.
//  Copyright (c) 2013 Matrix Soft. All rights reserved.
//

#import "MSFirstViewController.h"
#import "MSNewsDetailsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Tesseract.h"
#import "SVProgressHUD.h"
#import <SDWebImage/UIButton+WebCache.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "PrettyKit.h"
#import "MSiOSVersionControlHeader.h"

#define I 8

@interface MSFirstViewController ()

//розміри екрана
@property CGFloat screenWidth;
@property CGFloat screenHeight;

//розміри маркерної рамки
@property CGFloat frameMarkWidth;
@property CGFloat frameMarkHeight;

//timer for slideshow
@property NSTimer *slideShowTimer;
@property NSTimer *userTouchTimer;

@property (strong, nonatomic) MSAPI *api;
//@property (strong, nonatomic) MSTabBarController *tabBarController;

@property (strong, nonatomic) UITapGestureRecognizer *tapRecognizer;

@property (nonatomic, strong) MSLogInView *loginView;
@property (nonatomic) BOOL isAuthorized;
@property (nonatomic, strong) NSNotificationCenter *nc;
@property (nonatomic, strong) UITextField *activeField;

@property (nonatomic) CGRect complaintViewFrame;

@property (nonatomic) BOOL isTextFieldEtiting;
@property (nonatomic) BOOL isFromBeginEditing;

@property (nonatomic) BOOL textViewBeginEditing;

@property (nonatomic) int beginCount;
@property (nonatomic) int endCount;

@property (strong, nonatomic) NSString *codeStr;

@property (strong, nonatomic) NSMutableString *productString;
@property (strong, nonatomic) UIImageView *defaultImage;

@property BOOL isInternetConnectionFailed;

@end

@implementation MSFirstViewController

@synthesize scrollView = _scrollView;
@synthesize newsScrollView = _newsScrollView;
@synthesize newsPageControl = _newsPageControl;
@synthesize newsView = _newsView;
@synthesize codeInputView = _codeInputView;
@synthesize codeTextField = _codeTextField;
@synthesize sendCodeButton = _sendCodeButton;
@synthesize photoButton = _photoButton;

@synthesize tapRecognizer = _tapRecognizer;

@synthesize screenWidth = _screenWidth;
@synthesize screenHeight = _screenHeight;

@synthesize frameMarkWidth = _frameMarkWidth;
@synthesize frameMarkHeight = _frameMarkHeight;

@synthesize api = _api;
@synthesize receivedData = _receivedData;

@synthesize dialogView = _dialogView;
@synthesize loginView = _loginView;
@synthesize activeField = _activeField;
@synthesize isAuthorized = _isAuthorized;
@synthesize productImageView = _productImageView;
//@synthesize mainFishkaImageView = _mainFishkaImageView;
@synthesize mainFishkaLabel = _mainFishkaLabel;
@synthesize backAlphaView = _backAlphaView;

@synthesize logoBarImageView = _logoBarImageView;
@synthesize logoBarTextImageView = _logoBarTextImageView;

@synthesize complaintView = _complaintView;

@synthesize complaintViewFrame = _complaintViewFrame;

@synthesize isTextFieldEtiting = _isTextFieldEtiting;
@synthesize isFromBeginEditing = _isFromBeginEditing;

@synthesize textViewBeginEditing = _textViewBeginEditing;

@synthesize beginCount = _beginCount;
@synthesize endCount = _endCount;

@synthesize codeStr = _codeStr;
@synthesize productString = _productString;

@synthesize defaultImage = _defaultImage;

@synthesize newsActivityIdicator = _newsActivityIdicator;
@synthesize isInternetConnectionFailed = _isInternetConnectionFailed;


- (MSAPI *)api
{
    if(!_api)
    {
        _api = [[MSAPI alloc]init];
        _api.delegate = self;
    }
    return _api;
}

- (void)viewDidLoad
{    
    [super viewDidLoad];
    
    //translation
    [self.sendCodeButton setTitle:NSLocalizedString(@"SendButtonKey", nil) forState:UIControlStateNormal];
    [self.codeTextField setPlaceholder:NSLocalizedString(@"CodeTextFieldTextKey", nil)];
    
    
    self.newsActivityIdicator.hidesWhenStopped = YES;
    [self.newsActivityIdicator startAnimating];
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
    {
        [self customizeNavBar];
    }
    
    self.beginCount = 0;
    self.endCount = 0;
    
    //------------------------------------------------------
    self.logoBarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 2, 147, 40)];
    [self.logoBarImageView setImage:[UIImage imageNamed:@"logo_color_invert_40*147.png"]];
    
    self.logoBarTextImageView = [[UIImageView alloc] initWithFrame:CGRectMake(77.5, 7, 165, 30)];
    [self.logoBarTextImageView setImage:[UIImage imageNamed:@"logo_text_30*165.png"]];
    
    [self.navigationController.navigationBar addSubview:self.logoBarImageView];
    //------------------------------------------------------
    
    if (self == [self.navigationController.viewControllers objectAtIndex:0]) {
        NSLog(@"Root view controller");
    }
        
    [self.api getTopNews];
    
    [self.codeTextField setDelegate:self];
    
    if (!SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0"))
    {
        [self.codeTextField setClearButtonMode:UITextFieldViewModeNever];
    }
    [self.codeTextField setAutocapitalizationType:UITextAutocapitalizationTypeAllCharacters];
        
    [self.scrollView setScrollEnabled:NO];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
    }
    else
    {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
        self.codeInputView.frame = CGRectMake(self.codeInputView.frame.origin.x, self.codeInputView.frame.origin.y - 55, self.codeInputView.frame.size.width, self.codeInputView.frame.size.height);
    }
    
    CGRect frame = CGRectMake(self.codeTextField.frame.origin.x, self.codeTextField.frame.origin.y, self.codeTextField.frame.size.width, 45);
    self.codeTextField.frame = frame;
    
    self.newsView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
    self.codeInputView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0"))
    {
        self.newsPageControl.pageIndicatorTintColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0];
        self.newsPageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1.0];
    }
    
    self.newsPageControl.numberOfPages = 1;
    [self.newsView.layer setBorderColor:[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:0.7].CGColor];
    [self.newsView.layer setBorderWidth:1.0f];
    
    [self.codeInputView.layer setCornerRadius:7.0];
    [self.codeInputView.layer setBorderColor:[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:0.7].CGColor];
    [self.codeInputView.layer setBorderWidth:1.0f];
    
    self.nc = [NSNotificationCenter defaultCenter];
    
    [self.nc addObserver:self selector:@selector(keyboardWillShow:) name:
     UIKeyboardWillShowNotification object:nil];
    
    [self.nc addObserver:self selector:@selector(keyboardWillHide:) name:
     UIKeyboardWillHideNotification object:nil];
    
    self.slideShowTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(slide) userInfo:nil repeats:YES];
    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapAnywhere:)];
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"isFirstStart"] == nil)
    {
        NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
        [userDefults setObject:[NSNumber numberWithInt:1] forKey:@"isFirstStart"];
        [userDefults synchronize];
        
        UIViewController *tipsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"tips"];
        
//        loginViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        
        [self presentViewController:tipsViewController animated:YES completion:nil];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveOKClicked:)
                                                 name:@"FailConnectionAllertClickedOK"
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [UIView animateWithDuration:0.3 animations:^{
        [self.logoBarImageView setAlpha:1];
        [self.logoBarTextImageView setAlpha:1];
    }];
    [self checkAutorization];
    
    if (self.isInternetConnectionFailed)
    {
        [self.api getTopNews];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.logoBarImageView setAlpha:1];
    [self.logoBarTextImageView setAlpha:1];
    [self checkAutorization];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [UIView animateWithDuration:0.3 animations:^{
        [self.logoBarImageView setAlpha:0];
        [self.logoBarTextImageView setAlpha:0];
    }];
    if(self.loginView)
    {
        [self.loginView removeFromSuperview];
        self.loginView = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)receiveOKClicked:(NSNotification *)notification
{
    self.isInternetConnectionFailed = YES;
    
    [SVProgressHUD dismiss];
}

- (void)slide
{
    if (self.newsPageControl.currentPage + 1 == self.newsPageControl.numberOfPages)
    {
        self.newsPageControl.currentPage = 0;
    }
    else
    {
        self.newsPageControl.currentPage++;
    }
    [self changeImageByPageController];
}

- (IBAction)changeNewsPage:(id)sender
{
    [self changeImageByPageController];
    [self.slideShowTimer invalidate];
    self.slideShowTimer = nil;
    self.userTouchTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(touchDelay) userInfo:nil repeats:NO];
}

- (void)changeImageByPageController
{
    CGRect frame;
    frame.origin.x = self.newsScrollView.frame.size.width * self.newsPageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.newsScrollView.frame.size;
    [self.newsScrollView scrollRectToVisible:frame animated:YES];
}

- (void)picturePressed:(UIButton *)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        [self.logoBarImageView setAlpha:0];
        [self.logoBarTextImageView setAlpha:0];
    }];
    
    [self.logoBarImageView setAlpha:0];
    [self.logoBarTextImageView setAlpha:0];
    
    [self performSegueWithIdentifier:@"newsDetailsFromHome" sender:sender];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"newsDetailsFromHome"])
    {
        UIButton *currentSender = sender;
        [segue.destinationViewController setContentOfArticleWithId:[NSString stringWithFormat:@"%u",currentSender.tag]];
    }
}

-(void) touchDelay
{
    [self.userTouchTimer invalidate];
    self.userTouchTimer = nil;
    self.slideShowTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(slide) userInfo:nil repeats:YES];
}

#pragma mark ScrollViewDelegate

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    float pageWidth = self.newsScrollView.frame.size.width;
    int page = floor((self.newsScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.newsPageControl.currentPage = page;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.slideShowTimer invalidate];
    self.slideShowTimer = nil;
    [self.userTouchTimer invalidate];
    self.userTouchTimer = nil;
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    self.userTouchTimer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(touchDelay) userInfo:nil repeats:NO];
}

#pragma mark working with camera and processing photo

//зробити фото коду
- (void)takePhoto:(UIButton *)sender
{
    //перевірка наявності камири в девайсі
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        //якщо є
        imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [imagePickerController setAllowsEditing:YES];
                                
        UIImageView *overlayImageView = [[UIImageView alloc] init];
//        [overlayImageView setImage:[UIImage imageNamed:@"rect_220*30.png"]];
        [overlayImageView setImage:[UIImage imageNamed:@"rect_180*40.png"]];
        
        UIView *rootOverlayAlphaTopView = [[UIView alloc] init];
        [rootOverlayAlphaTopView setBackgroundColor:[UIColor blackColor]];
        [rootOverlayAlphaTopView setAlpha:0.7];
        
        UIView *overlayAlphaTopView = [[UIView alloc] init];
        [overlayAlphaTopView setBackgroundColor:[UIColor blackColor]];
        [overlayAlphaTopView setAlpha:0.7];
        
        UIView *overlayAlphaBottomView = [[UIView alloc] init];
        [overlayAlphaBottomView setBackgroundColor:[UIColor blackColor]];
        
        UIView *overlayAlphaLeftView = [[UIView alloc] init];
        [overlayAlphaLeftView setBackgroundColor:[UIColor blackColor]];
        
        UIView *overlayAlphaRightView = [[UIView alloc] init];
        [overlayAlphaRightView setBackgroundColor:[UIColor blackColor]];
        
        //розмір екрана
        self.screenWidth = [[UIScreen mainScreen] bounds].size.width;
        self.screenHeight = [[UIScreen mainScreen] bounds].size.height;
        
        //розмір рамки
        self.frameMarkWidth = 180;
        self.frameMarkHeight = 40;
        
        //запуск камери
        [self presentViewController:imagePickerController animated:YES completion:^(void){
            NSLog(@"Block");
            
            [rootOverlayAlphaTopView setFrame:CGRectMake(0, 0, 0, 0)];
            
            //додавання рамки і напівпрозорого фону
//            if (self.screenHeight == 568)
//            {
//                [overlayImageView setFrame:CGRectMake((self.screenWidth - self.frameMarkWidth)/2, (self.screenHeight - 96 - self.frameMarkHeight)/2, self.frameMarkWidth, self.frameMarkHeight)];
//                
//                [overlayAlphaTopView setFrame:CGRectMake(0, 0, 320, (self.screenHeight - 96 - self.frameMarkHeight)/2)];
//            }
//            else
//            {
//                [overlayImageView setFrame:CGRectMake((self.screenWidth - self.frameMarkWidth)/2, (self.screenHeight - 54 - self.frameMarkHeight)/2, self.frameMarkWidth, self.frameMarkHeight)];
//                [overlayAlphaTopView setFrame:CGRectMake(0, 0, 320, (self.screenHeight - 54 - self.frameMarkHeight)/2)];
//            }
            
//            [overlayAlphaTopView setFrame:CGRectMake(0, 0, 320, (self.screenHeight - 54 - self.frameMarkHeight)/2)];
            
            if (self.screenHeight == 568)
            {
                [overlayImageView setFrame:CGRectMake((self.screenWidth - self.frameMarkWidth)/2, (self.screenHeight - 96 - self.frameMarkHeight)/2, self.frameMarkWidth, self.frameMarkHeight)];
                
                [overlayAlphaTopView setFrame:CGRectMake(0, 0, 320, (self.screenHeight - 96 - self.frameMarkHeight)/2)];
                
                [overlayAlphaBottomView setFrame:CGRectMake(0, (self.screenHeight - 96 + self.frameMarkHeight)/2, 320, self.screenHeight - (self.screenHeight - 96 + self.frameMarkHeight)/2 - 96)];
                
                [overlayAlphaLeftView setFrame:CGRectMake(0, (self.screenHeight - 96 - self.frameMarkHeight)/2, (self.screenWidth - self.frameMarkWidth)/2, self.frameMarkHeight)];
                
                [overlayAlphaRightView setFrame:CGRectMake(self.frameMarkWidth + (self.screenWidth - self.frameMarkWidth)/2, (self.screenHeight - 96 - self.frameMarkHeight)/2, 320 - self.frameMarkWidth + (self.screenWidth - self.frameMarkWidth)/2, self.frameMarkHeight)];
            }
            else
            {
                [overlayImageView setFrame:CGRectMake((self.screenWidth - self.frameMarkWidth)/2, (self.screenHeight - 54 - self.frameMarkHeight)/2, self.frameMarkWidth, self.frameMarkHeight)];
                [overlayAlphaTopView setFrame:CGRectMake(0, 0, 320, (self.screenHeight - 54 - self.frameMarkHeight)/2)];

                [overlayAlphaBottomView setFrame:CGRectMake(0, (self.screenHeight - 54 + self.frameMarkHeight)/2, 320, self.screenHeight - (self.screenHeight - 54 + self.frameMarkHeight)/2 - 52)];
                
                [overlayAlphaLeftView setFrame:CGRectMake(0, (self.screenHeight - 54 - self.frameMarkHeight)/2, (self.screenWidth - self.frameMarkWidth)/2, self.frameMarkHeight)];
                
                [overlayAlphaRightView setFrame:CGRectMake(self.frameMarkWidth + (self.screenWidth - self.frameMarkWidth)/2, (self.screenHeight - 54 - self.frameMarkHeight)/2, 320 - self.frameMarkWidth + (self.screenWidth - self.frameMarkWidth)/2, self.frameMarkHeight)];
            }
            
//            [overlayAlphaLeftView setFrame:CGRectMake(0, (self.screenHeight - 54 - self.frameMarkHeight)/2, (self.screenWidth - self.frameMarkWidth)/2, self.frameMarkHeight)];
            
//            [overlayAlphaRightView setFrame:CGRectMake(self.frameMarkWidth + (self.screenWidth - self.frameMarkWidth)/2, (self.screenHeight - 54 - self.frameMarkHeight)/2, 320 - self.frameMarkWidth + (self.screenWidth - self.frameMarkWidth)/2, self.frameMarkHeight)];
            
            [rootOverlayAlphaTopView addSubview:overlayAlphaTopView];
            
            [overlayAlphaTopView addSubview:overlayImageView];
            [overlayAlphaTopView addSubview:overlayAlphaBottomView];
            [overlayAlphaTopView addSubview:overlayAlphaLeftView];
            [overlayAlphaTopView addSubview:overlayAlphaRightView];
            
            //добавлення маркерної рамки на камеру
            imagePickerController.cameraOverlayView = rootOverlayAlphaTopView;

        }];
    }
    else
    {
        //якщо нема
        UIAlertView *cameraNotAvailableMessage = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Ошибка камеры",nil) message:NSLocalizedString(@"Камера не доступна",nil) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [cameraNotAvailableMessage show];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    NSLog(@"Picture width: %f", img.size.width);
    NSLog(@"Picture hight: %f", img.size.height);
    
    UIImage *tempImage = [self cropImage:[info objectForKey:UIImagePickerControllerEditedImage] withX:(self.screenWidth - self.frameMarkWidth)/2 withY:(self.screenHeight - 54 - self.frameMarkHeight)/2 withWidth:self.frameMarkWidth withHeight:self.frameMarkHeight];
    
    //------------------------------
    NSString *recognizedText;
    @try {
        recognizedText = [NSString stringWithString:[self recognizeImage:tempImage]];
        
        NSLog(@"%@", recognizedText);
        
        recognizedText = [recognizedText stringByReplacingOccurrencesOfString:@" " withString:@""];
        recognizedText = [recognizedText stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        [self.codeTextField setText:[self filtringCode:recognizedText]];
                
        [imagePickerController dismissViewControllerAnimated:YES completion:NULL];
    }
    @catch (NSException *exception) {
        [imagePickerController dismissViewControllerAnimated:YES completion:NULL];
        
        UIAlertView *recognizingCodeError = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"RecognitionErrorKey", nil)
                                                                       message:NSLocalizedString(@"RecognitionCodeErrorKey", nil)
                                                                      delegate:nil
                                                             cancelButtonTitle:@"OK"
                                                             otherButtonTitles:nil, nil];
        [recognizingCodeError show];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [imagePickerController dismissViewControllerAnimated:YES completion:NULL];
}

static inline double radians (double degrees)
{
    return degrees * M_PI/180;
}

//обрізка фото
- (UIImage *)cropImage:(UIImage *)image withX:(CGFloat)x withY:(CGFloat)y withWidth:(CGFloat)cropWidth withHeight:(CGFloat)cropHeight
{    
    CGImageRef imageRef = [image CGImage];
	CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef);
	CGColorSpaceRef colorSpaceInfo = CGColorSpaceCreateDeviceRGB();
	
	if (alphaInfo == kCGImageAlphaNone)
		alphaInfo = kCGImageAlphaNoneSkipLast;
	
	CGFloat width, height;
    
	width = [image size].width;
	height = [image size].height;
    
    NSLog(@"%f", image.size.width);
    NSLog(@"%f", image.size.height);
	
	CGContextRef bitmap;
	
	if (image.imageOrientation == UIImageOrientationUp | image.imageOrientation == UIImageOrientationDown) {
		bitmap = CGBitmapContextCreate(NULL, width, height, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, alphaInfo);
		
	} else {
		bitmap = CGBitmapContextCreate(NULL, height, width, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, alphaInfo);
		
	}
	
	if (image.imageOrientation == UIImageOrientationLeft) {
		NSLog(@"image orientation left");
		CGContextRotateCTM (bitmap, radians(90));
		CGContextTranslateCTM (bitmap, 0, -height);
		
	} else if (image.imageOrientation == UIImageOrientationRight) {
		NSLog(@"image orientation right");
		CGContextRotateCTM (bitmap, radians(-90));
		CGContextTranslateCTM (bitmap, -width, 0);
		
	} else if (image.imageOrientation == UIImageOrientationUp) {
		NSLog(@"image orientation up");
		
	} else if (image.imageOrientation == UIImageOrientationDown) {
		NSLog(@"image orientation down");
		CGContextTranslateCTM (bitmap, width,height);
		CGContextRotateCTM (bitmap, radians(-180.));
		
	}
	
	CGContextDrawImage(bitmap, CGRectMake(0, 0, width, height), imageRef);
    
//    CGFloat koefForWidth, koefForHeight;
    
//    koefForWidth = 8.1;
//    koefForHeight = 4.5;
        
//    CGRect rect;
//    rect.origin.x = x * koefForWidth;
//    rect.origin.y = y * koefForHeight;
//    rect.size.width = cropWidth * koefForWidth;
//    rect.size.height = cropHeight * koefForHeight;
    
    CGRect rect;
    
    if ([[UIScreen mainScreen] bounds].size.height == 568)
    {
        rect.origin.x = 140;
        rect.origin.y = 285;
        rect.size.width = cropWidth * 2;
        rect.size.height = cropHeight * 2;
    }
    else
    {
        rect.origin.x = 140;
        rect.origin.y = 280;
        rect.size.width = cropWidth * 2;
        rect.size.height = cropHeight * 2;
    }
        
	CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    
	UIImage *result = [UIImage imageWithCGImage:ref];
    
    CGImageRef resultRef = CGImageCreateWithImageInRect([result CGImage], rect);
    UIImage *cropedImage = [UIImage imageWithCGImage:resultRef];
	   
	CGContextRelease(bitmap);
	CGImageRelease(ref);
    
    NSLog(@"Croped image size: %f * %f", cropedImage.size.width, cropedImage.size.height);
    
	return cropedImage;
}

//роспізнавання коду
- (NSString *)recognizeImage:(UIImage *)image
{
    Tesseract* tesseract = [[Tesseract alloc] initWithDataPath:@"tessdata" language:@"eng"];
    [tesseract setImage:image];
    [tesseract recognize];
    
    return [tesseract recognizedText];
}

//фільтрування коду
- (NSString *)filtringCode:(NSString *)code
{
    NSMutableString *filtredString = [[NSMutableString alloc] init];
    NSMutableString *tempStr = [NSMutableString stringWithString:code];
    
    for (int i = 0; i < tempStr.length; i++) {
        unichar ch = [tempStr characterAtIndex:i];
        if ((ch >= 50 && ch <= 57) || (ch >= 65 && ch <= 72) || (ch >= 75 && ch <= 78) || ch == 80 || ch == 82 || (ch >= 84 && ch <= 89) || ch == 45 || ch == 8212 || ch == 8211)
        {
            if (ch == 45 || ch == 8211 || ch == 8212) {
                ch = 45;
                
                unichar tempCh = [tempStr characterAtIndex:i+1];
                
                if (tempCh == 45 || tempCh == 8211 || tempCh == 8212) {
                    NSRange charDeleteRange;
                    charDeleteRange.location = i+1;
                    charDeleteRange.length = 1;
                    
                    [tempStr deleteCharactersInRange:charDeleteRange];
                }
            }
            NSLog(@"%@", [NSString stringWithFormat:@"%c", ch]);
            [filtredString appendString:[NSString stringWithFormat:@"%c", ch]];
        }
    }
    
    return filtredString;
}

//перевірка коду
- (IBAction)sendCode:(UIButton *)sender
{
    
    float a = 3.125f;
    float b = (int)a;
    NSLog(@"float b = %f", b);
    
    NSLog(@"You click on send button!!!");
    
    [self.sendCodeButton setEnabled:NO];
    
    [self.codeTextField resignFirstResponder];
    
    
    [self.api setDelegate:self];
    
//    self.codeStr = @"0353-264A-37AF-4E66";
//    self.codeStr = @"CED0-152F-80CC-893E";
    self.codeStr = [self.codeTextField text];
    
//    [self.api checkCode:[self.codeTextField text]];
    
//    unichar ch = [codeStr characterAtIndex:4];
//    NSString *str = [NSString stringWithFormat:@"%c", ch];
    
    NSMutableString *tempStr = [[NSMutableString alloc] init];
    
    for (int i = 0; i < self.codeStr.length; i++)
    {
        unichar ch = [self.codeStr characterAtIndex:i];
        
        if (!(ch == 45 || ch == 8211 || ch == 8212))
        {
            [tempStr appendString:[NSString stringWithFormat:@"%c", ch]];
        }
    }
    
    self.codeStr = [NSString stringWithString:tempStr];
    
    if (![self.codeStr isEqualToString:@""] && self.codeStr.length == 9) {
        [SVProgressHUD showWithStatus:NSLocalizedString(@"Отправка кода...",nil)];
        
        [self.api checkCode:self.codeStr];
    }
    else
    {
        UIAlertView *codeFailMessage = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Ошибка кода",nil)
                                                                     message:NSLocalizedString(@"Код должен включать 9 символов",nil)
                                                                    delegate:self
                                                           cancelButtonTitle:@"Ok"
                                                           otherButtonTitles:nil];
        [codeFailMessage show];
        
        [self.sendCodeButton setEnabled:YES];
    }
    
//    [self showDialogView];
    
}

- (IBAction)profileButtonPressed:(id)sender
{
    if (self.isAuthorized)
    {
        [self performSegueWithIdentifier:@"toProfile" sender:self];
    }
    else
    {
        if (!self.loginView)
        {
            self.loginView = [[MSLogInView alloc]initWithOrigin:CGPointMake(25, self.view.frame.size.height/2 - 120)];
            [self.view addSubview:self.loginView];
            [self.loginView blackOutOfBackground];
            [self.loginView attachPopUpAnimationForView:self.loginView.loginView];
            self.loginView.delegate = self;
        }
    }
}

-(void)dismissPopView:(BOOL)result
{
    if(result)
    {
        self.isAuthorized = YES;
        [self.profileBarButton setImage:[UIImage imageNamed:@"Profile-Picture_40*28_white.png"]];
    }
    self.loginView = nil;
}

- (void)showDialogView
{
//    [SVProgressHUD showSuccessWithStatus:@"Ok"];
    
    [self.sendCodeButton setEnabled:YES];
    
//    [self.scrollView addSubview:self.dialogView];
    [self.view addSubview:self.dialogView];
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.backAlphaView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
    } completion:^(BOOL finished) {
        [self.dialogView setFrame:CGRectMake(5, ([[UIScreen mainScreen] bounds].size.height - self.dialogView.frame.size.height)/2 - 54, 310, 295)];
        [self.dialogView attachPopUpAnimationForView:self.dialogView];
        
        [self.dialogView.closeButton addTarget:self action:@selector(closeDialogView) forControlEvents:UIControlEventTouchUpInside];
        [self.dialogView.okButton addTarget:self action:@selector(closeDialogView) forControlEvents:UIControlEventTouchUpInside];
        [self.dialogView.complaint addTarget:self action:@selector(showComplaintView) forControlEvents:UIControlEventTouchUpInside];
    }];
    
}

- (void)closeDialogView
{    
    [UIView animateWithDuration:0.5 animations:^{
        [self.backAlphaView setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.0]];
        [self.dialogView setAlpha:0];
    } completion:^(BOOL finished) {
        [self.backAlphaView removeFromSuperview];
        [self.dialogView removeFromSuperview];
    }];
}

- (void)closeComplaintView
{
    [UIView animateWithDuration:0.5 animations:^{
        [self.backAlphaView setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.0]];
        [self.complaintView setAlpha:0];
    } completion:^(BOOL finished) {
        [self.backAlphaView removeFromSuperview];
        [self.complaintView removeFromSuperview];
    }];
}

- (void)showComplaintView
{        
    [UIView animateWithDuration:0.5 animations:^{
        [self.dialogView setAlpha:0];
    } completion:^(BOOL finished) {
        self.complaintView = [[MSComplaintView alloc] initWithFrame:CGRectMake(5, ([[UIScreen mainScreen] bounds].size.height - 311)/2 - 54, 310, 311)];
        self.complaintViewFrame = self.complaintView.frame;
        [self.complaintView setDelegate:self];
//        [self.view addSubview:self.complaintView];
        [self.view addSubview:self.complaintView];
        [self.complaintView attachPopUpAnimationForView:self.complaintView];
        [self.dialogView removeFromSuperview];
        
        [self.complaintView.productTextField setText:self.productString];
        [self.complaintView.codeTextField setText:self.codeStr];
        
        [self.complaintView.cancelButton addTarget:self action:@selector(closeComplaintView) forControlEvents:UIControlEventTouchUpInside];
        [self.complaintView.closeButton addTarget:self action:@selector(closeComplaintView) forControlEvents:UIControlEventTouchUpInside];
        [self.complaintView.sendComplaintButton addTarget:self action:@selector(sendComplaint) forControlEvents:UIControlEventTouchUpInside];
        
        [self.complaintView.productTextField setDelegate:self];
        [self.complaintView.codeTextField setDelegate:self];
        [self.complaintView.locationTextField setDelegate:self];
        
        [self.complaintView.commentTextView setDelegate:self];
    }];
}

- (void)sendComplaint
{
    if ([self.complaintView.productTextField text] != nil && [self.complaintView.codeTextField text] != nil && [self.complaintView.locationTextField text] != nil && [self.complaintView.commentTextView text] != nil) {
        
        [SVProgressHUD showWithStatus:@"Complaint sending..."];
        
        [self.api sendComplaintForProduct:[self.complaintView.productTextField text]
                                 withCode:[self.complaintView.codeTextField text]
                             withLocation:[self.complaintView.locationTextField text]
                              withComment:[self.complaintView.commentTextView text]
                                withImage:[self.complaintView.productImageButton backgroundImageForState:UIControlStateNormal]
                            withImageName:@"productImage"];
    }
    else
    {
        UIAlertView *complaintError = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ComplaintErrorKey", nil)
                                                                 message:NSLocalizedString(@"FillAllFieldsKey", nil)
                                                                delegate:nil cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil, nil];
        [complaintError show];
    }
}

- (void)startCameraWithImagePickerController:(UIImagePickerController *)pickerController
{
    [self presentViewController:pickerController animated:YES completion:^{
        
    }];

}

- (void)closeCameraWithImagePickerController:(UIImagePickerController *)pickerController
{
    [pickerController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark finishedWithDictionary:withTypeRequest:

- (void)finishedWithDictionary:(NSDictionary *)dictionary withTypeRequest:(requestTypes)type
{
    if (type == kCode) {
        NSLog(@"checking");
        
        if ([[dictionary valueForKey:@"status"] isEqualToString:@"valid"] || [[dictionary valueForKey:@"status"] isEqualToString:@"registered"]) {
            
            NSLog(@"valid");
            
            if ([[UIScreen mainScreen] bounds].size.height == 568) {
                self.dialogView = [[MSDialogView alloc] initWithFrame:CGRectMake(5, 568, 310, 295)];
                
                self.backAlphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
            }
            else
            {
                self.dialogView = [[MSDialogView alloc] initWithFrame:CGRectMake(5, 480, 310, 295)];
                
                self.backAlphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
                
            }
            
            [self.backAlphaView setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0]];
            [self.view insertSubview:self.backAlphaView belowSubview:self.dialogView];
            
            self.mainFishkaLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 178, 20)];
            self.mainFishkaLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
            [self.mainFishkaLabel setTextColor:[UIColor whiteColor]];
            [self.mainFishkaLabel setBackgroundColor:[UIColor clearColor]];
            [self.mainFishkaLabel setTextAlignment:NSTextAlignmentCenter];
            [self.mainFishkaLabel setText:NSLocalizedString(@"ПРОВЕРКА КОДА",nil)];
                        
            [self.dialogView.captionLabel setText:[[dictionary valueForKey:@"message"] objectAtIndex:0]];
            [self.dialogView.productLabel setText:NSLocalizedString(@"Товар:",nil)];
            NSURL *imageUrl = [NSURL URLWithString:[[dictionary valueForKey:@"product"] valueForKey:@"image"]];
            [self.dialogView.productImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"placeholder622*415.png"]];
            
            self.productString = [NSMutableString stringWithString:[[dictionary valueForKey:@"brand"] valueForKey:@"title"]];
            [self.productString appendFormat:@" / %@", [[dictionary valueForKey:@"product"] valueForKey:@"title"]];
            
            [self.dialogView.productDescripptionLabel setText:self.productString];
            [self.dialogView.productDescripptionLabel sizeToFit];
            
            [self.dialogView.categoryLabel setText:NSLocalizedString(@"Категория:",nil)];
            [self.dialogView.categoryDescripptionLabel setText:[[dictionary valueForKey:@"category"] valueForKey:@"title"]];
            [self.dialogView.categoryDescripptionLabel sizeToFit];
            
            [self.dialogView.bonusLabel setText:NSLocalizedString(@"Бонус за продукт:",nil)];
            [self.dialogView.bonusValueLabel setText:[dictionary valueForKey:@"bonus"]];
            
            [self.dialogView.messageLabel setText:[[dictionary valueForKey:@"message"] objectAtIndex:1]];
            [self.dialogView.messageLabel sizeToFit];
            
            [self.dialogView.messageView setFrame:CGRectMake(self.dialogView.messageView.frame.origin.x, self.dialogView.messageView.frame.origin.y, self.dialogView.messageView.frame.size.width, self.dialogView.messageLabel.frame.size.height)];
            
            [self showDialogView];
            
            [self.codeTextField setText:@""];
        }
        else
        {
            if ([[dictionary valueForKey:@"status"] isEqualToString:@"expiried"]) {
                NSLog(@"expiried");
                
                if ([[UIScreen mainScreen] bounds].size.height == 568) {
                    self.dialogView = [[MSDialogView alloc] initWithFrame:CGRectMake(5, 568, 310, 295)];
                    
                    self.backAlphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
                    
                }
                else
                {
                    self.dialogView = [[MSDialogView alloc] initWithFrame:CGRectMake(5, 480, 310, 295)];
                    
                    self.backAlphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
                    
                }
                
                [self.backAlphaView setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0]];
                [self.view insertSubview:self.backAlphaView belowSubview:self.dialogView];
                
                self.mainFishkaLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 178, 20)];
                self.mainFishkaLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
                [self.mainFishkaLabel setTextColor:[UIColor whiteColor]];
                [self.mainFishkaLabel setBackgroundColor:[UIColor clearColor]];
                [self.mainFishkaLabel setTextAlignment:NSTextAlignmentCenter];
                [self.mainFishkaLabel setText:NSLocalizedString(@"ПРОВЕРКА КОДА",nil)];
                
                [self.dialogView.captionLabel setText:[[dictionary valueForKey:@"message"] objectAtIndex:0]];
                [self.dialogView.productLabel setText:NSLocalizedString(@"Товар:",nil)];
                NSURL *imageUrl = [NSURL URLWithString:[[dictionary valueForKey:@"product"] valueForKey:@"image"]];
                [self.dialogView.productImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"placeholder_415*415.png"]];
                
                self.productString = [NSMutableString stringWithString:[[dictionary valueForKey:@"brand"] valueForKey:@"title"]];
                [self.productString appendFormat:@" / %@", [[dictionary valueForKey:@"product"] valueForKey:@"title"]];
                
                [self.dialogView.productDescripptionLabel setText:self.productString];
                [self.dialogView.productDescripptionLabel sizeToFit];
                
                [self.dialogView.categoryLabel setText:NSLocalizedString(@"Категория:",nil)];
                [self.dialogView.categoryDescripptionLabel setText:[[dictionary valueForKey:@"category"] valueForKey:@"title"]];
                [self.dialogView.categoryDescripptionLabel sizeToFit];
                
                [self.dialogView.bonusLabel setText:NSLocalizedString(@"Бонус за продукт:",nil)];
//                [self.dialogView.bonusValueLabel setText:[dictionary valueForKey:@"bonus"]];
                [self.dialogView.bonusValueLabel setText:@"0"];
                
                [self.dialogView.messageLabel setText:[[dictionary valueForKey:@"message"] objectAtIndex:1]];
                [self.dialogView.messageLabel sizeToFit];
                
                [self.dialogView.messageView setFrame:CGRectMake(self.dialogView.messageView.frame.origin.x, self.dialogView.messageView.frame.origin.y, self.dialogView.messageView.frame.size.width, self.dialogView.messageLabel.frame.size.height)];
                
                [self showDialogView];
                
                [self.codeTextField setText:@""];
            }
            else
            {
                if ([[dictionary valueForKey:@"status"] isEqualToString:@"notfound"] || [[dictionary valueForKey:@"status"] isEqualToString:@"already"]) {
                    
                    NSLog(@"notfound");
                    
                    if ([[UIScreen mainScreen] bounds].size.height == 568) {
                        self.dialogView = [[MSDialogView alloc] initWithFrame:CGRectMake(5, 568, 310, 295)];
                        
                        self.backAlphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
                    }
                    else
                    {
                        self.dialogView = [[MSDialogView alloc] initWithFrame:CGRectMake(5, 480, 310, 295)];
                        
                        self.backAlphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
                                                
                    }
                    
                    [self.backAlphaView setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0]];
                    [self.view insertSubview:self.backAlphaView belowSubview:self.dialogView];
                    
                    self.mainFishkaLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 178, 20)];
                    self.mainFishkaLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
                    [self.mainFishkaLabel setTextColor:[UIColor whiteColor]];
                    [self.mainFishkaLabel setBackgroundColor:[UIColor clearColor]];
                    [self.mainFishkaLabel setTextAlignment:NSTextAlignmentCenter];
                    [self.mainFishkaLabel setText:NSLocalizedString(@"ПРОВЕРКА КОДА",nil)];
                    
                    [self.dialogView.captionLabel setText:[[dictionary valueForKey:@"message"] objectAtIndex:0]];
                    
                    
                    
                    NSString *messageStr = [[dictionary valueForKey:@"message"] objectAtIndex:1];
                    
                    messageStr = [messageStr stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
                    messageStr = [messageStr stringByReplacingOccurrencesOfString:@"</p>" withString:@"\n"];
                    
                    UILabel *notFoundMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.dialogView.captionLabel.frame.origin.y + self.dialogView.captionLabel.frame.size.height + 10, 290, 100)];
                    [notFoundMessageLabel setNumberOfLines:0];
                    [notFoundMessageLabel setLineBreakMode:NSLineBreakByWordWrapping];
                    [notFoundMessageLabel setBackgroundColor:[UIColor clearColor]];
                    notFoundMessageLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:11.0];
                    [notFoundMessageLabel setTextColor:[UIColor whiteColor]];
                    [notFoundMessageLabel setText:messageStr];
                    [notFoundMessageLabel sizeToFit];
                    
                    [self.dialogView addSubview:notFoundMessageLabel];
                    
                    [self.dialogView.bonusNameLabel setText:@""];
                    [self.dialogView.productImageView setHidden:YES];
                    
                    [self showDialogView];
                }
            }
        }
    }
    if (type == kNews)
    {
        [self.newsActivityIdicator stopAnimating];
        
        NSArray *arrayOfNews = [dictionary valueForKey:@"list"];
        for (int i = 0; i < arrayOfNews.count; i++)
        {
            CGRect frame;
            frame.origin.x = i * self.newsScrollView.frame.size.width;
            frame.origin.y = 0;
            frame.size = self.newsScrollView.frame.size;
            
            UIView *subView = [[UIView alloc]initWithFrame:frame];
            [self.newsScrollView addSubview:subView];
            
            UIButton *subViewButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.newsScrollView.frame.size.width, self.newsScrollView.frame.size.height)];
            [subViewButton addTarget:self
                              action:@selector(picturePressed:)
                    forControlEvents:UIControlEventTouchUpInside];
        
            NSURL *imageUrl = [NSURL URLWithString:[[arrayOfNews objectAtIndex:i] valueForKey:@"imageBig" ]];
            [subViewButton setBackgroundImageWithURL:imageUrl forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder622*415.png"]];
            subViewButton.tag = [[[arrayOfNews objectAtIndex:i]valueForKey:@"id"] integerValue];
            [subView addSubview:subViewButton];
        }
        self.newsScrollView.contentSize = CGSizeMake(self.newsScrollView.frame.size.width * arrayOfNews.count, self.newsScrollView.frame.size.height);
        [self.newsScrollView.layer setCornerRadius:5.0];
        self.newsPageControl.numberOfPages = arrayOfNews.count;
    }
    if (type == kQuestions) {
        NSLog(@"");
    }
    if (type == kComplaint) {
        if ([[dictionary valueForKey:@"status"] isEqualToString:@"ok"])
        {
            [self closeComplaintView];
        }
        else
        {
            UIAlertView *authorisationError = [[UIAlertView alloc] initWithTitle:[[dictionary valueForKey:@"message"] valueForKey:@"title"]
                                                                         message:[[dictionary valueForKey:@"message"] valueForKey:@"text"]
                                                                        delegate:self
                                                               cancelButtonTitle:NSLocalizedString(@"Отмена", nil)
                                                               otherButtonTitles:@"OK", nil];
            [authorisationError show];
        }
    }
}

- (void)didSelectTabBarItem:(UITabBarItem *)item
{
    if ([item tag] == 1)
    {
        NSLog(@"Ніхуя собі");
    }
}

- (void)didTapAnywhere:(UITapGestureRecognizer*)recognizer
{
    [self.codeTextField resignFirstResponder];
    [self.complaintView.productTextField resignFirstResponder];
    [self.complaintView.codeTextField resignFirstResponder];
    [self.complaintView.locationTextField resignFirstResponder];
    [self.complaintView.commentTextView resignFirstResponder];
}

- (void)keyboardWillShow:(NSNotification *)note
{
    NSLog(@"Screen height: %f", [[UIScreen mainScreen] bounds].size.height);
    
    if (self.activeField == self.codeTextField)
    {
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            [self.scrollView setScrollEnabled:NO];
            [self.scrollView setContentSize:CGSizeMake(320.0, 568.0 + 40.0)];
            
            CGFloat tempy = 568.0 + 40.0;
            CGFloat tempx = 320.0;
            CGRect zoomRect = CGRectMake((tempx/2), (tempy/2), tempy, tempx);
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.25];
            [self.scrollView scrollRectToVisible:zoomRect animated:NO];
            [UIView commitAnimations];
        }
        
        else
        {
            [self.scrollView setScrollEnabled:NO];
            [self.scrollView setContentSize:CGSizeMake(320.0, 480.0 + 55.0)];
            
            CGFloat tempy = 480.0 + 55.0;
            CGFloat tempx = 320.0;
            CGRect zoomRect = CGRectMake((tempx/2), (tempy/2), tempy, tempx);
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.25];
            [self.scrollView scrollRectToVisible:zoomRect animated:NO];
            [UIView commitAnimations];
        }
        [self.view addGestureRecognizer:self.tapRecognizer];
        [self.view.window addGestureRecognizer:self.tapRecognizer];
    }
}

- (void)keyboardWillHide:(NSNotification *)note
{
    if (self.activeField == self.codeTextField)
    {
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            CGRect zoomRect = CGRectMake(0, 0, 320, 568);
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.25];
            [self.scrollView scrollRectToVisible:zoomRect animated:NO];
            [UIView commitAnimations];
        }
        
        else
        {
            CGRect zoomRect = CGRectMake(0, 0, 320, 480);
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.25];
            [self.scrollView scrollRectToVisible:zoomRect animated:NO];
            [UIView commitAnimations];
        }
        
        [self.scrollView setScrollEnabled:NO];
        [self.view removeGestureRecognizer:self.tapRecognizer];
        [self.view.window removeGestureRecognizer:self.tapRecognizer];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.complaintView setFrame:CGRectMake(self.complaintView.frame.origin.x, self.complaintViewFrame.origin.y, self.complaintView.frame.size.width, self.complaintView.frame.size.height)];
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.beginCount++;
    
    self.isTextFieldEtiting = YES;
    
    self.activeField = textField;
    
    self.complaintView.productTextField = textField;
    
    if (textField.tag == 1 || textField.tag == 2 || textField.tag == 3)
    {
        if ([[UIScreen mainScreen] bounds].size.height == 480)
        {
            [UIView animateWithDuration:0.25 animations:^{
                [self.complaintView setFrame:CGRectMake(self.complaintView.frame.origin.x, 0, self.complaintView.frame.size.width, self.complaintView.frame.size.height)];
            }];
            
            self.isTextFieldEtiting = YES;
        }
        else
        {
            [UIView animateWithDuration:0.25 animations:^{
                [self.complaintView setFrame:CGRectMake(self.complaintView.frame.origin.x, 0, self.complaintView.frame.size.width, self.complaintView.frame.size.height)];
            }];
        }
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.endCount++;
    
    self.activeField = nil;
    
    if (textField.tag == 1 || textField.tag == 2 || textField.tag == 3)
    {
        if (self.beginCount == self.endCount)
        {
            if ([[UIScreen mainScreen] bounds].size.height == 480 && self.textViewBeginEditing == NO) {
                [UIView animateWithDuration:0.25 animations:^{
                    [self.complaintView setFrame:CGRectMake(self.complaintView.frame.origin.x, self.complaintViewFrame.origin.y, self.complaintView.frame.size.width, self.complaintView.frame.size.height)];
                }];
                
                self.isTextFieldEtiting = NO;
                
                self.beginCount = 0;
                self.endCount = 0;
            }
            else
            {
                if (self.textViewBeginEditing == NO) {
                    [UIView animateWithDuration:0.25 animations:^{
                        [self.complaintView setFrame:CGRectMake(self.complaintView.frame.origin.x, self.complaintViewFrame.origin.y, self.complaintView.frame.size.width, self.complaintView.frame.size.height)];
                    }];
                }
            }
        }
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //бидло код трололо
    if (textField == self.codeTextField || textField == self.complaintView.codeTextField)
    {
        if (![string isEqualToString:@" "])
        {
            if ((range.location == 3 || range.location == 7) && range.location != 0 && ![string isEqualToString:@""])
            {
                NSRange myRange;
                myRange.location = range.location + 1;
                myRange.length = 1;
                
                NSMutableString *tempMutStr = [NSMutableString stringWithString:textField.text];
                
                if ([string isEqualToString:@"-"])
                {
                    return YES;
                }
                else
                {
                    if (range.location < [textField.text length]) {
                        return  NO;
                    }
                    else
                    {
                        [tempMutStr insertString:@"-" atIndex:range.location];
                        textField.text = [NSString stringWithString:tempMutStr];
                    }
                }
            }
            
            NSUInteger newLength = [textField.text length] + [string length] - range.length;
            
            if ([string isEqualToString:@""])
            {
                return YES;
            }
            else
            {
                if (newLength > 11)
                {
                    return NO;
                }
                else
                {
                    return YES;
                }
                
                //        return (newLength > 19) ? NO : YES;
            }
        }
        else
        {
            return NO;
        }
    }
    else
    {
        return YES;
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.textViewBeginEditing = YES;
    
    if([textView.text isEqualToString:NSLocalizedString(@"WriteACommentForComplaintKey", nil)])
        textView.text = @"";
    textView.textColor = [UIColor blackColor];
    if ([[UIScreen mainScreen] bounds].size.height == 568)
    {
        [UIView animateWithDuration:0.25 animations:^{
            [self.complaintView setFrame:CGRectMake(self.complaintView.frame.origin.x, 0, self.complaintView.frame.size.width, self.complaintView.frame.size.height)];
        }];
    }
    else
    {
        [UIView animateWithDuration:0.25 animations:^{
            [self.complaintView setFrame:CGRectMake(self.complaintView.frame.origin.x, -100, self.complaintView.frame.size.width, self.complaintView.frame.size.height)];
        }];
    }
    
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.textViewBeginEditing = NO;
    
    if ([textView.text isEqualToString:@""]){
        textView.text = NSLocalizedString(@"WriteACommentForComplaintKey", nil);
        textView.textColor = [UIColor lightGrayColor];
    }
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        if (self.isTextFieldEtiting == NO) {
            [UIView animateWithDuration:0.25 animations:^{
                [self.complaintView setFrame:CGRectMake(self.complaintView.frame.origin.x, self.complaintViewFrame.origin.y, self.complaintView.frame.size.width, self.complaintView.frame.size.height)];
            }];
        }
    }
    else
    {
        if (self.isTextFieldEtiting == NO) {
            [UIView animateWithDuration:0.25 animations:^{
                [self.complaintView setFrame:CGRectMake(self.complaintView.frame.origin.x, self.complaintViewFrame.origin.y, self.complaintView.frame.size.width, self.complaintView.frame.size.height)];
            }];
        }
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSCharacterSet *doneButtonCharacterSet = [NSCharacterSet newlineCharacterSet];
    NSRange replacementTextRange = [text rangeOfCharacterFromSet:doneButtonCharacterSet];
    NSUInteger location = replacementTextRange.location;
    
    if (textView.text.length + text.length > 140)
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

-(void)checkAutorization
{
    NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefults valueForKey:@"authorization_Token" ];
    if(token.length)
    {
        self.isAuthorized = YES;
        [self.profileBarButton setImage:[UIImage imageNamed:@"Profile-Picture_40*28_white.png"]];
    }
    else
    {
        self.isAuthorized = NO;
        [self.profileBarButton setImage:nil];
        [self.profileBarButton setTitle:NSLocalizedString(@"Войти",nil)];
    }
}

- (void)customizeNavBar {
    PrettyNavigationBar *navBar = (PrettyNavigationBar *)self.navigationController.navigationBar;
    
    navBar.topLineColor = [UIColor colorWithHex:0x414141];
    navBar.gradientStartColor = [UIColor colorWithHex:0x373737];
    navBar.gradientEndColor = [UIColor colorWithHex:0x1a1a1a];
    navBar.bottomLineColor = [UIColor colorWithHex:0x000000];
    navBar.tintColor = navBar.gradientEndColor;
    
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
    [super viewDidUnload];
}
@end
