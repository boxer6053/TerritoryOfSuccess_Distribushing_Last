//
//  MSNewsViewController.m
//  TerritoryOfSuccess
//
//  Created by Alex on 1/14/13.
//  Copyright (c) 2013 Matrix Soft. All rights reserved.
//

#import "MSNewsViewController.h"
#import "MSNewsDetailsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "JSONParserForDataEntenties.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MSNewsCell.h"
#import "PrettyKit.h"

@interface MSNewsViewController ()
{
    BOOL _isFirstDownload;
    BOOL _isDownloading;
}

@property (nonatomic)  MSAPI *dbApi;
@property int newsCount;
@property NSMutableArray *arrayOfNews;
@property NSArray *lastDownloadedNews;
@property NSInteger totalNewsCount;
@property UIButton *footerButton;
@property UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UINavigationItem *newsNavigationItem;
@property BOOL isInternetConnectionFailed;

@end

@implementation MSNewsViewController

@synthesize newsTableView = _newsTableView;
@synthesize dbApi = _dbApi;
@synthesize arrayOfNews = _arrayOfNews;
@synthesize newsCount = _newsCount;
@synthesize lastDownloadedNews = _lastDownloadedNews;
@synthesize totalNewsCount = _totalNewsCount;
@synthesize footerButton = _footerButton;
@synthesize activityIndicator = _activityIndicator;
@synthesize isInternetConnectionFailed = _isInternetConnectionFailed;

-(MSAPI *)dbApi
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
    [self.newsNavigationItem setTitle:NSLocalizedString(@"NewsNavItemTitleKey", nil)];
    self.arrayOfNews = [[NSMutableArray alloc]init];
    _isFirstDownload = YES;
    [self.dbApi getFiveNewsWithOffset:0];
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
    }
    else
    {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
    }

    self.newsTableView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.0];
    self.footerButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.newsTableView.frame.size.width, 30)];
    [self.footerButton setTitle:NSLocalizedString(@"DownloadMoreKey",nil) forState:UIControlStateNormal];
    self.footerButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
    [self.footerButton setTitleColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4] forState:UIControlStateNormal];
    [self.footerButton addTarget:self action:@selector(moreNews) forControlEvents:UIControlEventTouchDown];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicator.hidesWhenStopped = YES;
    self.newsTableView.tableFooterView = self.activityIndicator;
    [self.activityIndicator startAnimating];
    
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
        [self.activityIndicator startAnimating];
        
        [self.dbApi getFiveNewsWithOffset:0];
    }
}

- (void)receiveOKClicked:(NSNotification *)notification
{
    self.isInternetConnectionFailed = YES;
    
    [self.activityIndicator stopAnimating];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)moreNews
{
    _isFirstDownload = NO;
    if (self.arrayOfNews.count < self.totalNewsCount)
    {
        _isDownloading = YES;
        self.newsTableView.tableFooterView = self.activityIndicator;
        [self.activityIndicator startAnimating];
        [self.dbApi getFiveNewsWithOffset:self.arrayOfNews.count - 1];
    }
    else
    {
        [self.footerButton setTitle:NSLocalizedString(@"AllNewsDownloadedKey",nil) forState:UIControlStateNormal];
    }
}

-(void)finishedWithDictionary:(NSDictionary *)dictionary withTypeRequest:(requestTypes)typefinished
{
    [self.activityIndicator stopAnimating];
    _isDownloading = NO;
    self.newsTableView.tableFooterView = self.footerButton;
    
    [self.arrayOfNews addObjectsFromArray: [dictionary valueForKey:@"list"]];
    self.lastDownloadedNews = [dictionary valueForKey:@"list"];
    if (!_isFirstDownload)
    {
        for (int i  = 0; i<self.lastDownloadedNews.count; i++)
        {
            NSArray *insertIndexPath = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:self.newsCount inSection:0]];
            self.newsCount++;
            [self.newsTableView insertRowsAtIndexPaths: insertIndexPath withRowAnimation:NO];
        }
    }
    else
    {
        self.newsCount += self.arrayOfNews.count;
        [self.newsTableView reloadData];
    }
    
    if (!(self.arrayOfNews.count < self.totalNewsCount))
    {
        [self.footerButton setTitle:NSLocalizedString(@"AllNewsDownloadedKey",nil) forState:UIControlStateNormal];
    }
}

#pragma mark Table View
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.newsCount;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* myIdentifier = @"newsCellIdentifier";
    MSNewsCell *cell = [self.newsTableView dequeueReusableCellWithIdentifier:myIdentifier];
    if (cell == nil) {
        cell = [[MSNewsCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:myIdentifier];
    }
    [cell.newsImageView setImageWithURL:[[self.arrayOfNews objectAtIndex:indexPath.row] valueForKey:@"image"]  placeholderImage:[UIImage imageNamed:@"placeholder_415*415.png"]];
    cell.newsTitleLabel.text = [[self.arrayOfNews objectAtIndex:indexPath.row] valueForKey:@"title"];
    cell.newsDetailLabel.text = [[self.arrayOfNews objectAtIndex:indexPath.row] valueForKey:@"brief"];
    cell.newsDateLabel.text = [[self.arrayOfNews objectAtIndex:indexPath.row] valueForKey:@"date"];
    cell.tag = [[[self.arrayOfNews objectAtIndex:indexPath.row] valueForKey:@"id"] integerValue];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * currentCell = [self.newsTableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"newsDetails" sender:currentCell];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(!_isDownloading)
    {
        if (self.newsTableView.contentOffset.y +455 > self.newsTableView.contentSize.height)
        {
            [self moreNews];
        }
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"newsDetails"])
    {
        UITableViewCell *currentCell = sender;
        [segue.destinationViewController setContentOfArticleWithId:[NSString stringWithFormat:@"%d",currentCell.tag]];
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
    [self setNewsNavigationItem:nil];
    [super viewDidUnload];
}
@end
