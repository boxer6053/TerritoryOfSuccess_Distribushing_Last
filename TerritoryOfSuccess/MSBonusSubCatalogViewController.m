//
//  MSBonusSubCatalogViewController.m
//  TerritoryOfSuccess
//
//  Created by Alex on 2/28/13.
//  Copyright (c) 2013 Matrix Soft. All rights reserved.
//

#import "MSBonusSubCatalogViewController.h"
#import "MSBrandsAndCategoryCell.h"
#import "MSSubCatalogueViewController.h"

@interface MSBonusSubCatalogViewController ()
{
    BOOL _isDownloading;
}

@property (strong, nonatomic) NSMutableArray *subCategoriesList;
@property int selectedItemId;
@property (strong, nonatomic) UIButton *footerButton;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) MSAPI *dbApi;
@property (nonatomic) NSInteger totalCategoriesCount;
@property int subCategoriesCount;
@property int categoryId;

@end

@implementation MSBonusSubCatalogViewController

@synthesize subCategoriesList = _subCategoriesList;
@synthesize subCatalogTableView = _subCatalogTableView;
@synthesize selectedItemId = _selectedItemId;
@synthesize footerButton = _footerButton;
@synthesize activityIndicator = _activityIndicator;
@synthesize dbApi = _dbApi;
@synthesize totalCategoriesCount = _totalCategoriesCount;
@synthesize categoryId = _categoryId;
@synthesize subCategoriesCount = _subCategoriesCount;

-(MSAPI *)dbApi
{
    if(!_dbApi)
    {
        _dbApi = [[MSAPI alloc]init];
        _dbApi.delegate = self;
    }
    return _dbApi;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicator.hidesWhenStopped = YES;
    
    [self.subCatalogTableView setBackgroundView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg.png"]]];
    self.footerButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.subCatalogTableView.frame.size.width, 30)];
    [self.footerButton setTitle:NSLocalizedString(@"DownloadMoreKey",nil) forState:UIControlStateNormal];
    self.footerButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
    [self.footerButton setTitleColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4] forState:UIControlStateNormal];
    [self.footerButton addTarget:self action:@selector(moreCategories) forControlEvents:UIControlEventTouchDown];
    self.footerButton.userInteractionEnabled = NO;
    self.subCatalogTableView.tableFooterView = self.footerButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)moreCategories
{
    if (self.subCategoriesList.count < self.totalCategoriesCount)
    {
        _isDownloading = YES;
        self.subCatalogTableView.tableFooterView = self.activityIndicator;
        [self.activityIndicator startAnimating];
        [self.dbApi getBonusSubCategories:self.categoryId withOffset:self.subCategoriesList.count - 1];
    }
    else
    {
        [self.footerButton setTitle:NSLocalizedString(@"AllCategoriesDownloadedKey",nil) forState:UIControlStateNormal];
    }
}

#pragma mark - setter for subCategories array
- (void)setSubCategories:(NSArray *)subCategoriesList andCategoryId:(int)categoryId
{
    self.subCategoriesList = subCategoriesList.mutableCopy;
    self.categoryId = categoryId;
    self.subCategoriesCount = self.subCategoriesList.count;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.subCategoriesCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"bonusSubCategoryCell";
    MSBrandsAndCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.categoryOrBrandName.text = [[self.subCategoriesList objectAtIndex:indexPath.row] valueForKey:@"title"];
    cell.categoryOrBrandNumber.text = [[self.subCategoriesList objectAtIndex:indexPath.row] valueForKey:@"cnt"];
    cell.categoryOrBrandImage.image = [UIImage imageNamed:@"bag.png"];
    cell.categoryOrBrandAvailable.text = NSLocalizedString(@"AvailableKey:", nil);
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(!_isDownloading)
    {
        if(self.subCatalogTableView.contentOffset.y + 455 > self.subCatalogTableView.contentSize.height)
        {
            [self moreCategories];
        }
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MSBrandsAndCategoryCell *cell = (MSBrandsAndCategoryCell *)[tableView cellForRowAtIndexPath:indexPath];
    if(![cell.categoryOrBrandNumber.text isEqualToString:@"0"])
    {
        self.selectedItemId = [[[self.subCategoriesList objectAtIndex:indexPath.row] valueForKey:@"id"] integerValue];
        [self performSegueWithIdentifier:@"toProductList" sender:self];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"toProductList"])
    {
        [segue.destinationViewController sentWithBonusCategoryId:self.selectedItemId];
    }
}

-(void)finishedWithDictionary:(NSDictionary *)dictionary withTypeRequest:(requestTypes)typefinished
{
    [self.activityIndicator stopAnimating];
    _isDownloading = NO;
    self.subCatalogTableView.tableFooterView = self.footerButton;
    [self.subCategoriesList addObjectsFromArray: [dictionary valueForKey:@"list"]];
    
    NSArray *lastDownloadedNews = [[NSArray alloc]initWithArray:[dictionary valueForKey:@"list"]];
    for (int i  = 0; i<lastDownloadedNews.count; i++)
    {
        NSArray *insertIndexPath = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:self.subCategoriesCount inSection:0]];
        self.subCategoriesCount++;
        [self.subCatalogTableView insertRowsAtIndexPaths: insertIndexPath withRowAnimation:NO];
    }
    
    if (self.subCategoriesList.count < self.totalCategoriesCount)
    {
        [self.footerButton setTitle:NSLocalizedString(@"AllNewsDownloadedKey",nil) forState:UIControlStateNormal];
    }
}

@end
