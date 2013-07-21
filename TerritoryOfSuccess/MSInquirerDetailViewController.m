//
//  MSInquirerDetailViewController.m
//  TerritoryOfSuccess
//
//  Created by Matrix Soft on 1/28/13.
//  Copyright (c) 2013 Matrix Soft. All rights reserved.
//

#import "MSInquirerDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>
#import "MSStatisticViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SVProgressHUD.h"
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
@interface MSInquirerDetailViewController ()
@property (strong, nonatomic) NSMutableData *receivedData;
@property (strong, nonatomic) MSAPI *api;

@end

@implementation MSInquirerDetailViewController
@synthesize inquirerType = _inquirerType;

@synthesize inquirerTitle = _inquirerTitle;
@synthesize itemID = _itemID;
@synthesize arrayOfProducts = _arrayOfProducts;
@synthesize productName = _productName;
@synthesize receivedData = _receivedData;
@synthesize api = _api;
@synthesize toStatButton = _toStatButton;
@synthesize count = _count;
@synthesize optionForAnswer = _optionForAnswer;
@synthesize ownerIndex = _ownerIndex;

- (MSAPI *) api{
    if(!_api){
        _api = [[MSAPI alloc]init];
        _api.delegate = self;
    }
    return _api;
}

- (void)viewDidLoad
{
   
   // [self.navigationItem.rightBarButtonItem setTitle:NSLocalizedString(@"AnswersKey",nil)];
    NSLog(@"itemID %ld", (long)self.itemID);
    NSLog(@"getted %@",self.productName);
    NSLog(@"adfdsfsdf%d", _inquirerType);
    int item = [self.itemID integerValue];
    NSLog(@"gonnatakeID %d", item);
    NSLog(@"Now Statistics");
   // [self.inquirerTitle setText:NSLocalizedString(@"InquirerDescriptionKey",nil)];
     [SVProgressHUD showWithStatus:NSLocalizedString(@"DownloadInquirerDetailKey",nil)];
    [self.api getDetailQuestionWithID:item];
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
    }
    else
    {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
    }
   
   [self.api getStatisticQuestionWithID:item];
    
    
    
    [super viewDidLoad];
    
    
    
	// Do any additional setup after loading the view.
}
-(void)finishedWithDictionary:(NSDictionary *)dictionary withTypeRequest:(requestTypes)type{
    if (type == kQuestDetail)
    {
        self.arrayOfProducts = [dictionary valueForKey:@"options"];
        self.count = self.arrayOfProducts.count;
        NSLog(@"COUNT %d", self.count);
        
        NSString *response = [[dictionary valueForKey:@"message"] valueForKey:@"text"];
        if([response isEqualToString:@"To get access to this page please log in to the system."]){
            UIAlertView *failmessage = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"Пожалуйста перезайдите в систему!" delegate:self cancelButtonTitle:@"Ок" otherButtonTitles:nil];
            [failmessage show];
            
        }
        [self buildView];
    }
     if (type == kSendAnswer)
     {
         NSString *answer = [dictionary valueForKey:@"status"];
         NSDictionary *message = [dictionary valueForKey:@"message"];
         NSString *goodAnswer = @"ok";
         NSString *alreadyAnswer = @"!-- already-voted --!";
         if([answer isEqualToString:goodAnswer]){
             NSLog(@"Everything's fine");
         }
         else{
             NSLog(@"Trouble");
         }
         if([answer isEqualToString:goodAnswer])
         {
             UIAlertView *failmessage = [[UIAlertView alloc] initWithTitle:@"Успех" message:@"Ваш ответ засчитан!" delegate:self cancelButtonTitle:@"Ок" otherButtonTitles:nil];
             [failmessage show];
             
         }
         if([[message valueForKey:@"text"]isEqualToString:alreadyAnswer])
         {
             UIAlertView *failmessage = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"Вы уже ответили!" delegate:self cancelButtonTitle:@"Ок" otherButtonTitles:nil];
             [failmessage show];
         }

     }
    if(type == kQuestStat){
        NSString *message = [dictionary valueForKey:@"status"];
        if(![message isEqualToString:@"failed"]){
            NSLog(@"not my");
            UIBarButtonItem *flipButton = [[UIBarButtonItem alloc]
                                           initWithTitle:NSLocalizedString(@"AnswersKey",nil)
                                           style:UIBarButtonItemStyleBordered
                                           target:self
                                           action:@selector(toStatAction)];
            self.navigationItem.rightBarButtonItem = flipButton;

        }
       // [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"DownloadIsCompletedKey",nil)];
    }
}
-(void)buildView
{
    NSLog(@"comparing %d", self.count);
    if(self.count == 1)
    {
        
        //ВИД ОПРОСА "ОЦЕНИТЕ ТОВАР"
        //UIImage *imagge = [UIImage imageWithURL]
        UILabel *productTitle = [[UILabel alloc] init];
        UIView *productView = [[UIView alloc] init];
        productView.layer.cornerRadius = 10.0f;
        productView.clipsToBounds = YES;
        productTitle.numberOfLines = 2;
//        [productView.layer setBorderColor:[[UIColor blackColor] CGColor]];
//        [productView.layer setBorderWidth:1];
        [productTitle setBackgroundColor:[UIColor clearColor]];
        [productTitle setText:[[self.arrayOfProducts objectAtIndex:0] valueForKey:@"title"]];
        //[productTitle setFont:[UIFont fontWithName:@"Helvetica" size:14]];
        if (SYSTEM_VERSION_LESS_THAN(@"6.0")) {
            productTitle.minimumFontSize = 12.0f;
        }
        else{
            productTitle.minimumScaleFactor = 0.3f;
            productTitle.adjustsFontSizeToFitWidth = YES;
        }
        productTitle.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:productTitle];
        UIImageView *imageForInquirer1 = [[UIImageView alloc] init];
        self.optionForAnswer = [[[self.arrayOfProducts objectAtIndex:0] valueForKey:@"id"] integerValue];
//        imageForInquirer1.layer.cornerRadius = 10.0f;
//        imageForInquirer1.clipsToBounds = YES;
//        [imageForInquirer1.layer setBorderColor:[[UIColor grayColor] CGColor]];
//        [imageForInquirer1.layer setBorderWidth:1];
        //[imageForInquirer1 setImage:[UIImage imageNamed:@"placeholder_415*415.png"]];
        
        [imageForInquirer1 setImageWithURL:[[self.arrayOfProducts objectAtIndex:0] valueForKey:@"image"] placeholderImage:[UIImage imageNamed:@"placeholder_415*415.png"]];
      //  [self.view addSubview:imageForInquirer1];
        UIButton *likeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];

            [likeButton setBackgroundImage:[UIImage imageNamed:@"chooseButton.png"] forState:UIControlStateNormal];
        
           
//        [likeButton setBackgroundImage:[UIImage imageNamed:@"likeWithOpacity copy.png"] forState:UIControlStateNormal];
        [likeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [likeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        [likeButton setTitle:NSLocalizedString(@"LikeKey", nil) forState:UIControlStateNormal];
        
        [likeButton addTarget:self action:@selector(likeAction)  forControlEvents:UIControlEventTouchUpInside];
        //[self.view addSubview:likeButton];
        UIButton *dislikeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
       // [dislikeButton setBackgroundImage:[UIImage imageNamed:@"dislikeWithOpacity copy.png"] forState:UIControlStateNormal];
         [dislikeButton setBackgroundImage:[UIImage imageNamed:@"chooseButton copy.png"] forState:UIControlStateNormal];
        //[dislikeButton setBackgroundColor:[UIColor blackColor]];
       [dislikeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [dislikeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];

       [dislikeButton setTitle:NSLocalizedString(@"DislikeKey", nil) forState:UIControlStateNormal];
        [dislikeButton addTarget:self action:@selector(dislikeAction) forControlEvents:UIControlEventTouchUpInside];
       // [self.view addSubview:dislikeButton];
        [productView addSubview:imageForInquirer1];
        [productView addSubview:likeButton];
        [productView addSubview:dislikeButton];
        [self.view addSubview:productView];
        if(self.ownerIndex ==1){
            likeButton = nil;
            dislikeButton= nil;
        }
        else{
            likeButton.enabled = YES;
            dislikeButton.enabled = YES;
        }

       // _inquirerTitle.text = @"Оцените товар";
        //фреймы для разных экранов (4 и 5 айфон)
        if ([[UIScreen mainScreen] bounds].size.height == 568)
            
        {
            [productView setFrame:CGRectMake(5, 60, 310, 360)];
            [productTitle setFrame:CGRectMake(10,20,290,20)];
            [imageForInquirer1 setFrame:CGRectMake(0, 0, 310, 310)];
            likeButton.frame = CGRectMake(0, 310, 155, 50);
            dislikeButton.frame = CGRectMake(155, 310, 155,50);
        }
        
        else{
            [productView setFrame:CGRectMake(15, 30, 290, 330)];
            [productTitle setFrame:CGRectMake(10,10,290,20)];
            [imageForInquirer1 setFrame:CGRectMake(0, 0, 290, 290)];
            likeButton.frame = CGRectMake(0, 290, 145, 40);
            dislikeButton.frame = CGRectMake(145, 290, 145, 40);
        }
    }
    else{
        //ВИД ОПРОСА КАКОЙ ТОВАР ЛУЧШЕ
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, 200, 20)];
        [titleLabel setText:NSLocalizedString(@"whatProductIsBetterKey", nil)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:titleLabel];
       // _inquirerTitle.text = @"Какой товар лучше";
               UITapGestureRecognizer *selectProduct = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseAProduct:)];
        [selectProduct setNumberOfTapsRequired:1];
        UIButton *image1 = [UIButton buttonWithType:UIButtonTypeCustom];
        UIButton *image2 = [UIButton buttonWithType:UIButtonTypeCustom];
        UIButton *image3 = [UIButton buttonWithType:UIButtonTypeCustom];
        UIButton *image4 = [UIButton buttonWithType:UIButtonTypeCustom];
        UIButton *image5 = [UIButton buttonWithType:UIButtonTypeCustom];
        UIButton *image6 = [UIButton buttonWithType:UIButtonTypeCustom];
        UILabel *nameLabel1 = [[UILabel alloc] init];
        UILabel *nameLabel2 = [[UILabel alloc] init];
        UILabel *nameLabel3 = [[UILabel alloc] init];
        UILabel *nameLabel4 = [[UILabel alloc] init];
        UILabel *nameLabel5 = [[UILabel alloc] init];
        UILabel *nameLabel6 = [[UILabel alloc] init];
        
                //фреймы для разных экранов (4 и 5 айфон)
        if ([[UIScreen mainScreen] bounds].size.height == 568)
        {
            [image1 setFrame:CGRectMake(30, 50, 100, 100)];
                        [nameLabel1 setFrame:CGRectMake(20, 155, 130, 13)];
            [image2 setFrame:CGRectMake(190, 50, 100, 100)];
                        [nameLabel2 setFrame:CGRectMake(180, 155, 130, 13)];
            [image3 setFrame:CGRectMake(30, 180, 100, 100)];
                        [nameLabel3 setFrame:CGRectMake(20, 285, 130, 13)];
            [image4 setFrame:CGRectMake(190, 180, 100, 100)];
                        [nameLabel4 setFrame:CGRectMake(180, 285, 130, 13)];
            [image5 setFrame:CGRectMake(30, 300, 100, 100)];
                        [nameLabel5 setFrame:CGRectMake(20, 415, 130, 13)];
            [image6 setFrame:CGRectMake(190, 300, 100, 100)];
                        [nameLabel6 setFrame:CGRectMake(180, 415, 130, 13)];

        }
        else
        {
         
            [image1 setFrame:CGRectMake(35, 36, 75, 75)];
                [nameLabel1 setFrame:CGRectMake(20, 115, 130, 21)];
            [image2 setFrame:CGRectMake(200, 36, 75, 75)];
                [nameLabel2 setFrame:CGRectMake(170, 115, 130, 21)];
            [image3 setFrame:CGRectMake(35, 146, 75, 75)];
                [nameLabel3 setFrame:CGRectMake(20, 225, 130, 21)];
            [image4 setFrame:CGRectMake(200, 146, 75, 75)];
                [nameLabel4 setFrame:CGRectMake(170, 225, 130, 21)];
            [image5 setFrame:CGRectMake(35, 256, 75, 75)];
                [nameLabel5 setFrame:CGRectMake(20, 335, 130, 21)];
            [image6 setFrame:CGRectMake(200, 256, 75, 75)];
                [nameLabel6 setFrame:CGRectMake(170, 335, 130, 21)];
        }
        NSArray *arrayOfNames = [[NSArray alloc] initWithObjects:nameLabel1,nameLabel2,nameLabel3,nameLabel4,nameLabel5,nameLabel6, nil];
        NSArray *arrayOfViews = [[NSArray alloc] initWithObjects:image1,image2,image3,image4,image5,image6, nil];
        for(int i=0;i<6;i++)
        {
            //UIButton *currentButton = [arrayOfViews objectAtIndex:i];
            
            [[arrayOfViews objectAtIndex:i] setBackgroundImage:[UIImage imageNamed:@"bag.png"] forState:UIControlStateNormal];
            UIButton *currentButton = [arrayOfViews objectAtIndex:i];
            currentButton.layer.cornerRadius = 10;
            currentButton.clipsToBounds= YES;
            if(self.ownerIndex ==1){
                currentButton.userInteractionEnabled = 0;
            }
            UILabel *currentLabel = [arrayOfNames objectAtIndex:i];
            [currentLabel setText:@"name"];
            [currentLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
            [currentLabel setBackgroundColor:[UIColor clearColor]];
//            [[[arrayOfViews objectAtIndex:i] layer] setCornerRadius:10];
            [[arrayOfViews objectAtIndex:i] setAlpha:0.85];
            [self.view addSubview:currentLabel];
            [self.view addSubview:currentButton];
        }
        for (int i = 0;i<self.arrayOfProducts.count;i++)
        {
            NSURL *imageUrl = [NSURL URLWithString:[[self.arrayOfProducts objectAtIndex:i] valueForKey:@"image" ]];
            [[arrayOfViews objectAtIndex:i] setTag:[[[self.arrayOfProducts objectAtIndex:i] valueForKey:@"id" ] integerValue]];
            UILabel *currentLabel = [arrayOfNames objectAtIndex:i];
            [currentLabel setText:[[self.arrayOfProducts objectAtIndex:i] valueForKey:@"title"]];
            [[arrayOfViews objectAtIndex:i] addTarget:self action:@selector(chooseAProduct:)forControlEvents:UIControlEventTouchUpInside];
           // [[arrayOfViews objectAtIndex:i] setBackgroundImage:[UIImage imageNamed:@"placeholder_415*415.png"] forState:UIControlStateNormal];
            [[arrayOfViews objectAtIndex:i]setBackgroundImageWithURL:imageUrl  forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder_415*415.png"]];
        }
        for (int i = self.arrayOfProducts.count;i<arrayOfViews.count;i++)
        {
            [[arrayOfViews objectAtIndex:i] setHidden:YES];
            [[arrayOfNames objectAtIndex:i] setHidden:YES];
            
        }

    }
   
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)toStatAction
{
    [self performSegueWithIdentifier:@"toStat" sender:self] ;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString: @"toStat"]){
        MSStatisticViewController *controller = (MSStatisticViewController *)segue.destinationViewController;
        controller.interfaceIndex = self.count;
        controller.questionID = [self.itemID integerValue];
        NSMutableArray *translateArray = [[NSMutableArray alloc] init];
        for(int i=0;i<self.arrayOfProducts.count;i++){
            [translateArray addObject:[[self.arrayOfProducts objectAtIndex:i] valueForKey:@"title"]];
        }
        controller.names = [translateArray mutableCopy];
        
        
        
        
    }
}
-(void)chooseAProduct:(id)sender
{
    NSInteger *questionID = [self.itemID integerValue];
    NSInteger *optionID = [sender tag];
    NSLog(@"TAP %d", [sender tag]);
    [self.api answerToQuestionWithID:questionID andOptionID:optionID];
         
}
- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        [self.navigationController popViewControllerAnimated:YES];

        }
}
-(void)likeAction{
      NSInteger *questionID = [self.itemID integerValue];
    NSLog(@"pressed option %d", self.optionForAnswer);
    [self.api answerToQuestionWithID:questionID andOptionID:self.optionForAnswer];
    //[self.navigationController popViewControllerAnimated:YES];
    NSLog(@"LIKE");
}
-(void)dislikeAction{
    NSInteger *questionID = [self.itemID integerValue];
    [self.api answerToQuestionWithID:questionID andOptionID:0];
    NSLog(@"DISLIKE");
}
@end
