//
//  MSBonusCatalogViewController.m
//  TerritoryOfSuccess
//
//  Created by Alex on 2/27/13.
//  Copyright (c) 2013 Matrix Soft. All rights reserved.
//

#import "MSBonusCatalogViewController.h"
#import "MSBrandsAndCategoryCell.h"
#import <QuartzCore/QuartzCore.h>
#import "MSBonusSubCatalogViewController.h"
#import "MSDetailViewController.h"
#import "MSSubCatalogueCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MSBonusCatalogViewController ()
{
}

@property (strong, nonatomic) MSAPI *api;
@property (strong, nonatomic) NSArray *categoriesList;
@property (strong, nonatomic) NSArray *subCategoriesList;
@property int selectedCategoryId;
@property BOOL thisIsProducts;


@property (strong, nonatomic) NSString *sendingName;
@property int sendingID;
@property int sendingRating;
@property int sendingComments;
@property int sendingAdvices;
@property (strong, nonatomic) NSString *sendingURL;
@property (strong, nonatomic) NSString *sendingText;
@property int sendingNumberInList;
@property int sendingCategoryID;
@property int sendingPrice;
@property int sendingOffset;
@property (strong, nonatomic) NSMutableArray *backIds;
@property BOOL isButtonCloseAvailable;
@property BOOL isSelectedItem;

@end

@implementation MSBonusCatalogViewController
@synthesize backIds = _backIds;
@synthesize backButton = _backButton;
@synthesize api = _api;
@synthesize thisIsProducts = _thisIsProducts;
@synthesize categoriesList = _categoriesList;
@synthesize subCategoriesList = _subCategoriesList;
@synthesize selectedCategoryId = _selectedCategoryId;
@synthesize isSelectedItem = _isSelectedItem;

@synthesize sendingPrice = _sendingPrice;
@synthesize sendingCategoryID = _sendingCategoryID;
@synthesize sendingNumberInList = _sendingNumberInList;
@synthesize sendingText = _sendingText;
@synthesize sendingAdvices = _sendingAdvices;
@synthesize sendingComments = _sendingComments;
@synthesize sendingRating = _sendingRating;
@synthesize sendingID = _sendingID;
@synthesize sendingName = _sendingName;
@synthesize sendingURL = _sendingURL;
@synthesize sendingOffset   = _sendingOffset;
@synthesize isButtonCloseAvailable = _isButtonCloseAvailable;

- (MSAPI *)api
{
    if(!_api)
    {
        _api = [[MSAPI alloc]init];
        _api.delegate = self;
    }
    return _api;
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
    [self.backButton setTitle:NSLocalizedString(@"BackKey", nil)];

    self.backIds = [NSMutableArray new];
    self.sendingOffset = 0;
    self.thisIsProducts = NO;
    //[self.api getBonusCategories];
    [self.bonusCatalog setBackgroundView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg.png"]]];
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bonusCatalog.frame.size.width, 1)];
    self.bonusCatalog.tableFooterView = footerView;
    self.bonusCatalog.tableFooterView.hidden = YES;
    self.bonusCatalog.tableFooterView.userInteractionEnabled = NO;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonPressed:(id)sender {
    
    self.thisIsProducts = NO;
   // [SVProgressHUD showWithStatus:NSLocalizedString(@"DownloadingInquirerListKey",nil)];
    //[self.headerButton removeFromSuperview];
    [self.backIds removeLastObject];
    //[self.backTitles removeLastObject];
   // self.tableView.tableHeaderView = nil;
   // NSLog(@"Last object %@", [self.backTitles lastObject]);
//    if(self.backTitles.count !=0){
//        [self.navigationBar.topItem setTitle:[self.backTitles lastObject]];
//        
//    }
//    else{
//        [self.navigationBar.topItem setTitle:@""];
//    }
    
    
    if(self.backIds.count != 0)
    {
        self.isButtonCloseAvailable = YES;
        NSInteger lastId = [[self.backIds objectAtIndex:(self.backIds.count-1)] integerValue];
        //[SVProgressHUD showWithStatus:NSLocalizedString(@"DownloadingInquirerListKey",nil)];
        [self.tableView setUserInteractionEnabled:NO];
        [self.api getBonusSubCategories:lastId withOffset:0];
        [self.tableView setUserInteractionEnabled:YES];
    }
    else
    {
        self.isButtonCloseAvailable = !self.isButtonCloseAvailable;
        [self.api getBonusSubCategories:0 withOffset:0];
        [self.tableView setUserInteractionEnabled:YES];
//        [self.backButton setEnabled:NO];
        
//        [self.navigationController popViewControllerAnimated:YES];
        
//        self.navigationItem.leftBarButtonItem.enabled=NO;
//        self.navigationItem.leftBarButtonItem=nil;
//        self.navigationController.navigationBar.backItem.hidesBackButton=YES;
        
        if (self.isButtonCloseAvailable)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)setCategoriesList:(NSArray *)categoriesList
{
    _categoriesList = categoriesList;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"toBonusSubCatalog"])
    {
        [segue.destinationViewController setSubCategories:self.subCategoriesList andCategoryId:self.selectedCategoryId];
    }
    if([segue.identifier isEqualToString:@"toDetail1"]){
        [segue.destinationViewController sentBonusProductName:self.sendingName andId:self.sendingID andRating:self.sendingRating andCommentsNumber:self.sendingComments andAdvisesNumber:self.sendingAdvices andImageURL:self.sendingURL andDescriptionText:self.sendingText andNumberInList:self.sendingNumberInList andCategoryId:self.sendingCategoryID andOffset:self.sendingOffset andPrice:self.sendingPrice ];
            }
}   
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.categoriesList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!self.thisIsProducts){
    NSString *CellIdentifier = @"bonusCatalogCell";
    MSBrandsAndCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [cell.categoryOrBrandAvailable setText:NSLocalizedString(@"AvailableKey:", nil)];
    cell.categoryOrBrandName.text = [[self.categoriesList objectAtIndex:indexPath.row] valueForKey:@"title"];
    cell.categoryOrBrandNumber.text = [[self.categoriesList objectAtIndex:indexPath.row] valueForKey:@"cnt"];
    cell.categoryOrBrandImage.image = [UIImage imageNamed:@"bag.png"];
        return cell;

    }
    else{
        NSString *CellIdentifier = @"productCellIdentifier";
        
        MSSubCatalogueCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
               cell.productName.text = [[self.categoriesList objectAtIndex:indexPath.row] valueForKey:@"title"];
        
        [cell.productSmallImage setImageWithURL:[[[self.categoriesList objectAtIndex:indexPath.row] valueForKey:@"image"] valueForKey:@"small"] placeholderImage:[UIImage imageNamed:@"placeholder_622*415.png"]];
         cell.productRatingImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%dstar.png",[[[self.categoriesList objectAtIndex:indexPath.row] valueForKey:@"rating"]integerValue]]];
        //cell.productBrandName.text = [[[self.categoriesList objectAtIndex:indexPath.row] valueForKey:@"brand"] valueForKey:@"title"];
        [cell.prodactBrandLabel setHidden:YES];
        return cell;
        }
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.backButton setEnabled:YES];
//    MSBrandsAndCategoryCell *cell = (MSBrandsAndCategoryCell *)[tableView cellForRowAtIndexPath:indexPath];
  if(self.thisIsProducts==NO){
        self.selectedCategoryId = [[[self.categoriesList objectAtIndex:indexPath.row] valueForKey:@"id"] integerValue];
        [self.backIds addObject:[[self.categoriesList objectAtIndex:indexPath.row] valueForKey:@"id"]];
       
            [self.api getBonusSubCategories:self.selectedCategoryId withOffset:0];
        }
        else{
            NSLog(@"Now must go to detail");
            self.sendingID = [[[self.categoriesList objectAtIndex:indexPath.row] valueForKey:@"id"] integerValue];
            self.sendingName = [[self.categoriesList objectAtIndex:indexPath.row] valueForKey:@"title"];
            self.sendingURL = [[[self.categoriesList objectAtIndex:indexPath.row] valueForKey:@"image"] valueForKey:@"big"];
            self.sendingRating = [[self.categoriesList objectAtIndex:indexPath.row] valueForKey:@"rating"];
            self.sendingComments = [[self.categoriesList objectAtIndex:indexPath.row] valueForKey:@"comments"];
            self.sendingAdvices = [[self.categoriesList objectAtIndex:indexPath.row] valueForKey:@"advices"];
            self.sendingText = [[self.categoriesList objectAtIndex:indexPath.row] valueForKey:@"content"];
            self.sendingNumberInList = indexPath.row;
            self.sendingCategoryID = self.selectedCategoryId   ;
            self.sendingPrice = [[self.categoriesList objectAtIndex:indexPath.row] valueForKey:@"price"];
            
            
            [self performSegueWithIdentifier:@"toDetail1" sender:self];
        }
    }
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height;
    if(!self.thisIsProducts){
        height = 64.0f;
    }
    else{
        height = 93.0f;
    }
    return height;
}

-(void)finishedWithDictionary:(NSDictionary *)dictionary withTypeRequest:(requestTypes)type
{
    if(type == kBonusSubCategories)
    {
        
        if([[dictionary valueForKey:@"status"] isEqualToString:@"ok"])
        {
           // if([[dictionary valueForKey:@"listtype"] isEqualToString:@"categories"]){
            self.categoriesList = [dictionary objectForKey:@"list"];
            //[self performSegueWithIdentifier:@"toBonusSubCatalog" sender:self];
        
                      
            if([[dictionary valueForKey:@"listtype"] isEqualToString:@"products"]){
                self.thisIsProducts = YES;
                NSLog(@"ThisISProducts");
            }
        }
        [self.tableView reloadData];
    }
}

- (void)viewDidUnload {
    [self setBackButton:nil];
    [super viewDidUnload];
}
@end
