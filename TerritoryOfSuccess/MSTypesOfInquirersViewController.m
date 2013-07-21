//
//  MSInquirerViewController.m
//  TerritoryOfSuccess
//
//  Created by Matrix Soft on 1/21/13.
//  Copyright (c) 2013 Matrix Soft. All rights reserved.
//


#import "MSTypesOfInquirersViewController.h"
#import "MSInquirerDetailViewController.h"
#import "MSStatisticViewController.h"
#import "SVProgressHUD.h"
#import "MSInquirerCell.h"
#import "MSLogInView.h"
#import "PrettyKit.h"

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@interface MSTypesOfInquirersViewController ()
@property int sendQuestionID;
@property (strong, nonatomic) NSMutableData *receivedData;
@property (strong, nonatomic) MSAPI *api;
@property (nonatomic, strong) MSLogInView *loginView;
@property (weak, nonatomic) NSString *sendingName;
@property ( nonatomic) NSInteger questionCount;
@property (strong, nonatomic) NSArray *lastDownloaded;
@property   BOOL isFirstDownload;
@property (nonatomic) NSInteger counter;
@property UIButton *footerButton;
@property BOOL loaded;
@property int interfaceIndex;
@property BOOL isInternetConnectionFailed;

@end


@implementation MSTypesOfInquirersViewController
@synthesize sendQuestionID = _sendQuestionID;
@synthesize footerButton = _footerButton;
@synthesize interfaceIndex = _interfaceIndex;
@synthesize counter = _counter;
@synthesize sendingName = _sendingName;
@synthesize tableOfInquirers = _tableOfInquirers;
@synthesize testInquirers = _testInquirers;
@synthesize selectedValue = _selectedValue;
@synthesize allInquirerMode;
@synthesize questionCount = _questionCount;
@synthesize myInquirerMode;
@synthesize inquirerTypeSegment = _inquirerTypeSegment;
@synthesize isAuthorized = _isAuthorized;
@synthesize addQuestionButton = _addQuestionButton;
@synthesize myQuestionsArray = _myQuestionsArray;
@synthesize allQuestionsArray = _allQuestionsArray;
@synthesize sendingID = _sendingID;
@synthesize loginView = _loginView;
@synthesize lastDownloaded = _lastDownloaded    ;
@synthesize isFirstDownload = _isFirstDownload;
@synthesize loaded = _loaded;
@synthesize isInternetConnectionFailed = _isInternetConnectionFailed;

- (MSAPI *) api{
    if(!_api){
        _api = [[MSAPI alloc]init];
        _api.delegate = self;
    }
    return _api;
}

- (MSLogInView *) loginView{
    if(!_loginView){
        _loginView = [[MSLogInView alloc]init];
        _loginView.delegate = self;
    }
    return _loginView;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
        _isFirstDownload = YES;
    self.myQuestionsArray = [[NSMutableArray alloc] init];
       self.tableOfInquirers.tableFooterView = nil;
    self.footerButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.tableOfInquirers.frame.size.width, 45)];
    [self.footerButton setTitle:NSLocalizedString(@"DownloadMoreKey",nil) forState:UIControlStateNormal];
    self.footerButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
    [self.footerButton setTitleColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4] forState:UIControlStateNormal];
    [self.footerButton addTarget:self action:@selector(downloadMoreQuestions) forControlEvents:UIControlEventTouchDown];
    

    self.allInquirerMode=YES;
    self.myInquirerMode = NO;
    [self.inquirersNavigationItem setTitle:NSLocalizedString(@"InquirerKey", nil)];
    [self.inquirerTypeSegment setTitle:NSLocalizedString(@"AllKey", nil) forSegmentAtIndex:0];
      [self.inquirerTypeSegment setTitle:NSLocalizedString(@"MyKey", nil) forSegmentAtIndex:1];
    
    NSLog(@"AllQuestions");
    
    [SVProgressHUD showWithStatus:NSLocalizedString(@"DownloadInquirersKey",nil)];
   
    [self.view addSubview:self.tableOfInquirers];

    
    if ([[UIScreen mainScreen] bounds].size.height == 568)
    {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
    }
    else
    {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
    }

    
   
    
    if(!self.isAuthorized){
        [self.addQuestionButton setEnabled:NO];
    }
    [_inquirerTypeSegment setTintColor:[UIColor blackColor]];
    _tableOfInquirers.delegate = self;
    _tableOfInquirers.dataSource = self;
    _testInquirers = [[NSArray alloc] initWithObjects:@"1",@"2", nil];
    [_tableOfInquirers setShowsVerticalScrollIndicator:NO];
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
    }
    else
    {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
    }
    
    // Do any additional setup after loading the view.
    
    [self customizeNavBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveOKClicked:)
                                                 name:@"FailConnectionAllertClickedOK"
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.isInternetConnectionFailed)
    {
        if(self.inquirerTypeSegment.selectedSegmentIndex == 0)
        {
            [self.api getLastQuestions];
        }
        else
        {
            [self.api getMyQuestionsWithOffset:0];
        }
    }
}

- (void)receiveOKClicked:(NSNotification *)notification
{
    self.isInternetConnectionFailed = YES;
    
    [SVProgressHUD dismiss];
}

-(void)dismissPopView:(BOOL)result
{
    if(result)
    {
        self.isAuthorized = YES;
        [self viewDidAppear:YES];
    }
    self.loginView = nil;
}
-(void)viewDidDisappear:(BOOL)animated  {
    if(_loginView)
    {
        [self.loginView removeFromSuperview];
    }
    self.isFirstDownload = YES;
    [self.myQuestionsArray removeAllObjects];
    self.questionCount = 0;
    self.counter = 0;
    NSLog(@"LEAVING %d",self.myQuestionsArray.count);
    [self.tableOfInquirers reloadData];

    }

-(void)setSegmentControlColor
{
    if (self.allInquirerMode) {
        [[_inquirerTypeSegment.subviews objectAtIndex:1] setTintColor:[UIColor colorWithRed:255.0/255.0 green:140.0/255.0 blue:0 alpha:1.0]];
        [[_inquirerTypeSegment.subviews objectAtIndex:0] setTintColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0]];
    }else{
        [[_inquirerTypeSegment.subviews objectAtIndex:0] setTintColor:[UIColor colorWithRed:255.0/255.0 green:140.0/255.0 blue:0 alpha:1.0]];
        [[_inquirerTypeSegment.subviews objectAtIndex:1] setTintColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0]];
    }
    
}

-(void)viewDidAppear:(BOOL)animated
{
      NSLog(@"COMING %d", self.myQuestionsArray.count);
   // [self.myQuestionsArray removeAllObjects];
    NSLog(@"COOMING %d",self.myQuestionsArray.count);
    NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefults valueForKey:@"authorization_Token" ];
    if(token.length){
        self.isAuthorized = YES;
        [self.addQuestionButton setEnabled:YES];
    }
    else{
        self.isAuthorized = NO;
        [self.addQuestionButton setEnabled:NO];
    }
    //[self.tableOfInquirers setContentOffset:CGPointMake(0, 0)];
    //[self.inquirerTypeSegment setSelectedSegmentIndex:1];
    if(self.inquirerTypeSegment.selectedSegmentIndex == 0)
    {
    [self.api getLastQuestions];
    }
    else{
       
//        [self.tableOfInquirers setContentOffset:CGPointMake(0, 0)];
        [self.api getMyQuestionsWithOffset:0];
    }
    
    [self setSegmentControlColor];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(allInquirerMode)
    {
        return self.allQuestionsArray.count;
    }
    else{
        return self.questionCount;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MSInquirerCell *cell;
    static NSString* cellIdentifier = @"inquirerCellId";
    cell = [_tableOfInquirers dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell == nil) {
        cell = [[MSInquirerCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.titleLabel.numberOfLines = 2;
    if(allInquirerMode) {
        cell.titleLabel.text = [[self.allQuestionsArray objectAtIndex:indexPath.row] valueForKey:@"title"];
        if([[[self.allQuestionsArray objectAtIndex:indexPath.row] valueForKey:@"cnt"] integerValue]== 1){
         cell.typeImage.image = [UIImage imageNamed:@"likeForProduct1.png"];
        }
        else{
            cell.typeImage.image = [UIImage imageNamed:@"questionMark.png"];
        }
    }
    else{
        cell.titleLabel.text = [[self.myQuestionsArray objectAtIndex:indexPath.row] valueForKey:@"title"];
        
        
        if([[[self.myQuestionsArray objectAtIndex:indexPath.row] valueForKey:@"cnt"] integerValue]== 1){
            cell.typeImage.image = [UIImage imageNamed:@"likeForProduct1.png"];
        }
        else{
            cell.typeImage.image = [UIImage imageNamed:@"questionMark.png"];
        }
        
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    _selectedValue = cell.textLabel.text;
    if(allInquirerMode) {
        self.sendingID =  [[self.allQuestionsArray objectAtIndex:indexPath.row] valueForKey:@"id"];
        self.sendingName = [[self.allQuestionsArray objectAtIndex:indexPath.row] valueForKey:@"title"];
        [self performSegueWithIdentifier:@"toInquirerDetail" sender:self];

    }
    else{
        self.sendQuestionID = [[[self.myQuestionsArray objectAtIndex:indexPath.row] valueForKey:@"id"] intValue];
        self.sendingName = [[self.myQuestionsArray objectAtIndex:indexPath.row] valueForKey:@"title"];
        self.interfaceIndex = [[[self.myQuestionsArray objectAtIndex:indexPath.row]valueForKey:@"cnt"] intValue];
        [self performSegueWithIdentifier:@"toStat" sender:self];
    }
    NSLog(@"ID%@",  self.sendingID);
    NSLog (@"%@", self.sendingName);
   }

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"toInquirerDetail"]){
        MSInquirerDetailViewController *controller = (MSInquirerDetailViewController *)segue.destinationViewController;
        controller.inquirerType = [_selectedValue integerValue];
        controller.itemID = self.sendingID;
        controller.productName = self.sendingName;
        controller.ownerIndex = self.inquirerTypeSegment.selectedSegmentIndex;
        NSLog(@"ss %@", _selectedValue);
    }
    if([segue.identifier isEqualToString:@"toStat"]){
        MSStatisticViewController *controller = (MSStatisticViewController *)segue.destinationViewController;
        controller.questionID = self.sendQuestionID;
        controller.interfaceIndex = self.interfaceIndex;
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)inquirerTypeSwitch:(id)sender {
    NSLog(@"pressed %d", self.inquirerTypeSegment.selectedSegmentIndex);
    
    if(self.inquirerTypeSegment.selectedSegmentIndex == 0)
    {
        [SVProgressHUD showWithStatus:NSLocalizedString(@"DownloadInquirersKey",nil)];
        self.allInquirerMode = YES;
        self.myInquirerMode = NO;
        [self.api getLastQuestions];
        [self.tableOfInquirers reloadData];
        self.tableOfInquirers.tableFooterView = nil;
    }
    else
    {
       // [SVProgressHUD showWithStatus:NSLocalizedString(@"DownloadInquirersKey",nil)];
        self.allInquirerMode = NO;
        self.myInquirerMode = YES;
        if(_isFirstDownload){
        [self.api getMyQuestionsWithOffset:0];
        }
        [self.tableOfInquirers reloadData];
        self.tableOfInquirers.tableFooterView = self.footerButton;
    }
    [self setSegmentControlColor];
    // [_tableOfInquirers reloadData];
}

-(void)finishedWithDictionary:(NSDictionary *)dictionary withTypeRequest:(requestTypes)type{
    if (type == kLastQuest)
    {
        
        
        self.allQuestionsArray = [dictionary valueForKey:@"list"];
        if([[dictionary valueForKey:@"status"] isEqualToString:@"failed"])
        {
            UIAlertView *failmessage = [[UIAlertView alloc] initWithTitle:[[dictionary valueForKey:@"message"] valueForKey:@"title"] message:[[dictionary valueForKey:@"message"] valueForKey:@"text"] delegate:self cancelButtonTitle:@"Ок" otherButtonTitles:nil];
            [failmessage show];
            [self.tabBarController setSelectedViewController:[self.tabBarController.viewControllers objectAtIndex:0]];
        }

//        if([[dictionary valueForKey:@"status"] isEqualToString:@"failed"])
//        {
//           self.loginView = [[MSLogInView alloc]initWithOrigin:CGPointMake(25, self.view.frame.size.height/2 - 120)];
//           [self.view addSubview:self.loginView];
//           [self.loginView blackOutOfBackground];
//           [self.loginView attachPopUpAnimationForView:self.loginView.loginView];
//           self.loginView.delegate = self;
//        }
        // self.numberOfRows = [[self arrayOfCategories] count];
    }
    
    if (type == kMyQuestions)
    {
        self.lastDownloaded = [dictionary valueForKey:@"list"];
        self.counter = [[dictionary valueForKey:@"count"] integerValue];
        [self.myQuestionsArray addObjectsFromArray:[dictionary valueForKey:@"list"]];
        if(_isFirstDownload){
            self.questionCount   += self.myQuestionsArray.count;
            [self.tableOfInquirers reloadData];
        }
        else
        {
        for (int i  = 0; i<self.lastDownloaded.count; i++)
            {
            
            NSArray *insertIndexPath = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:self.questionCount inSection:0]];
            self.questionCount++;
           [self.tableOfInquirers insertRowsAtIndexPaths: insertIndexPath withRowAnimation:NO];
            }
        }
        if([[dictionary valueForKey:@"status"] isEqualToString:@"failed"])
        {
            UIAlertView *failmessage = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"Пожалуйста перезайдите в систему!" delegate:self cancelButtonTitle:@"Ок" otherButtonTitles:nil];
            [failmessage show];
            [self.tabBarController setSelectedViewController:[self.tabBarController.viewControllers objectAtIndex:0]];
        }

        _isFirstDownload = NO;
        self.loaded = YES;

    }
       [[self tableOfInquirers] reloadData];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(self.loaded){
    if(self.questionCount < self.counter){
        if (self.tableOfInquirers.contentOffset.y + 300 > self.tableOfInquirers.contentSize.height)
        {
            [self.footerButton setTitle:NSLocalizedString(@"DownloadProductsKey", nil) forState:UIControlStateNormal];
            [self downloadMoreQuestions];
            self.loaded = NO;
            NSLog(@"NOT");

        }
    }
    else{
        [self.footerButton setTitle:NSLocalizedString(@"AllProductsDownloadedKey", nil) forState:UIControlStateNormal];
    }
    }
}
-(void)downloadMoreQuestions{
    //_isFirstDownload = NO;
    [self.api getMyQuestionsWithOffset:self.myQuestionsArray.count -1];
    NSLog(@"load more");
}

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
   
        [self.navigationController popViewControllerAnimated:YES];
        
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

- (void)viewDidUnload {
    [self setInquirersNavigationItem:nil];
    [super viewDidUnload];
}
@end
