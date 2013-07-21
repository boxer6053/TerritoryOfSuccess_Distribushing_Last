//
//  MSStatisticViewController.m
//  TerritoryOfSuccess
//
//  Created by Matrix Soft on 2/19/13.
//  Copyright (c) 2013 Matrix Soft. All rights reserved.
//

#import "MSStatisticViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SVProgressHUD.h"
#import "MSStatisticCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
@interface MSStatisticViewController ()
@property (strong, nonatomic) NSMutableData *receivedData;
@property (strong, nonatomic) MSAPI *api;
@property (strong, nonatomic) NSDictionary *questionDetailArray;
@property  (nonatomic) CGFloat totalVotes;
@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation MSStatisticViewController
@synthesize imageView = _imageView;
@synthesize questionDetailArray = _questionDetailArray;
@synthesize questionID = _questionID;
@synthesize interfaceIndex = _interfaceIndex;
@synthesize receivedData = _receivedData;
@synthesize receivedArray = _receivedArray;
@synthesize api = _api;
@synthesize tableView = _tableView;
@synthesize names = _names;
@synthesize votedLabel = _votedLabel;

- (MSAPI *) api{
    if(!_api){
        _api = [[MSAPI alloc]init];
        _api.delegate = self;
    }
    return _api;
}
- (void)viewDidLoad
{
    self.votedLabel.text = @"";
    [self.navigationItem setTitle:NSLocalizedString(@"AnswersKey", nil)];
    if (SYSTEM_VERSION_LESS_THAN(@"6.0")) {
        self.votedLabel.minimumFontSize = 10.0f;
       self.votedLabel.adjustsFontSizeToFitWidth = YES;
    }else{
        self.votedLabel.minimumScaleFactor = 0.8;
       self.votedLabel.adjustsFontSizeToFitWidth = YES;
    }
   // self.votedLabel = [[UILabel alloc] init];

    [super viewDidLoad];
//    [self.tableView setContentOffset:CGPointMake(5, 100)animated:YES];
    
    NSLog(@"TOTAL %f", self.totalVotes);
 
    if ([[UIScreen mainScreen] bounds].size.height == 568)
    {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
    }
    else
    {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
    }
//    self.tableView.layer.cornerRadius = 10.0f;
//    self.tableView.layer.borderWidth = 1.0f;
//    [self.tableView.layer setBorderColor:[[UIColor blackColor] CGColor]];
 [SVProgressHUD showWithStatus:NSLocalizedString(@"DownloadingInquirerStatKey",nil)];
   
    NSLog(@"id question %d", self.questionID);
    NSLog(@"interfaceIndex %d", self.interfaceIndex);
    [self.api getStatisticQuestionWithID:self.questionID];
    
    if(self.interfaceIndex == 1){
         if ([[UIScreen mainScreen] bounds].size.height == 568) {
    
             [self.tableView setFrame:CGRectMake(0, 310, self.tableView.frame.size.width, self.tableView.frame.size.height)];
             
             self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(35, 50, 250, 250)];
             

        
         }
         else{
             [self.tableView setFrame:CGRectMake(0, 210, self.tableView.frame.size.width, self.tableView.frame.size.height)];
             
             self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(85, 50, 150, 150)];
                     }
        self.imageView.layer.cornerRadius = 10.0f;
        self.imageView.clipsToBounds = YES;
        [self.imageView.layer setBorderWidth:1.0];
        [self.imageView.layer setBorderColor:[UIColor colorWithWhite:0.5 alpha:1].CGColor];
        [self.view addSubview:self.imageView];
       
    }
    
   
    

	// Do any additional setup after loading the view.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.interfaceIndex ==1){
        return self.receivedArray.count;
    }
    else{
        return self.receivedArray.count;
        NSLog(@"return %d", self.receivedArray.count);
    }
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView  {
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MSStatisticCell *cell;
    static NSString* cellIdentifier = @"statisticCellId";
    cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell == nil) {
        cell = [[MSStatisticCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    cell.rateView.layer.cornerRadius = 5.0f;
    cell.rateView.clipsToBounds = YES;
    if(self.interfaceIndex ==1){
        NSLog(@"TTOTAL %f",self.totalVotes);
        NSLog(@"count %d",self.receivedArray.count);
//        [self.tableView setFrame:CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.receivedArray.count*50)];
        
        NSString *value = [[self.receivedArray objectAtIndex:indexPath.row] valueForKey:@"cnt"];
        NSLog(@"value %f = ", [value floatValue]);
        CGFloat index = [value floatValue]/self.totalVotes;
        NSLog(@"index =%f",index);
        NSInteger heigh = (indexPath.row+1)*45+10;
        NSLog(@"height = %d", heigh);
        NSInteger percents = index*100;
      [cell.rateView setFrame:CGRectMake(20, 10, 0+index*260, 20)];
        NSString *answer = [NSString stringWithFormat:@"%d",percents];
        cell.answerLabel.text = [answer stringByAppendingString:@"%"];
        cell.rateView.image = [UIImage imageNamed:@"terrRate.png"];
        if (SYSTEM_VERSION_LESS_THAN(@"6.0")) {
            cell.titleLabel.minimumFontSize = 10.0f;
            cell.titleLabel.adjustsFontSizeToFitWidth = YES;
        }else{
            cell.titleLabel.minimumScaleFactor = 0.3f;
            cell.titleLabel.adjustsFontSizeToFitWidth = YES;
        }
        if([[[self.receivedArray objectAtIndex:indexPath.row] valueForKey:@"title"] isEqualToString:@"!-- like --!"]){
            cell.titleLabel.text = NSLocalizedString(@"LikeKey",nil);
                   }
        else{
            cell.titleLabel.text = NSLocalizedString(@"DislikeKey",nil);
                    }
       
    }
    else{
        
      //  CGFloat height = self.receivedArray.count;
//        [self.tableView setFrame:CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, height*50)];
        NSLog(@"count %d",self.receivedArray.count);
        NSLog(@"current row %d", indexPath.row);
        NSLog(@"title %@", [[self.receivedArray objectAtIndex:indexPath.row] valueForKey:@"title"]);
        if (SYSTEM_VERSION_LESS_THAN(@"6.0")) {
            cell.titleLabel.minimumFontSize = 8.0f;
            cell.titleLabel.adjustsFontSizeToFitWidth = YES;
        }else{
            cell.titleLabel.minimumScaleFactor = 0.7;
            cell.titleLabel.adjustsFontSizeToFitWidth = YES;
        }
        //NSString *number = [NSString stringWithFormat:@" %d",indexPath.row+1];
        cell.titleLabel.text = [[self.receivedArray objectAtIndex:indexPath.row] valueForKey:@"title"];
        [cell.productImageView setImageWithURL:[[self.receivedArray objectAtIndex:indexPath.row] valueForKey:@"image"] placeholderImage:[UIImage imageNamed:@"placeholder_415*415.png"]];
        //cell.titleLabel.text = [NSLocalizedString(@"ItemKey",nil) stringByAppendingString:number];
        NSString *value = [[self.receivedArray objectAtIndex:indexPath.row] valueForKey:@"cnt"];
       // NSLog(@"value %f = ", [value floatValue]);
        CGFloat index = [value floatValue]/self.totalVotes;
        //NSLog(@"index =%f",index);
        //NSInteger heigh = (indexPath.row+1)*50+10;
        //NSLog(@"height = %d", heigh);
        NSInteger percents;
        if(self.totalVotes==0){
            percents = 0;
        [cell.rateView setFrame:CGRectMake(70,10,0, 20)];
        }
        else{
            percents = index*100;
           [cell.rateView setFrame:CGRectMake(70, 10,0+index*210, 20)];
        }
        cell.rateView.image = [UIImage imageNamed:@"terrRate.png"];
        NSString *answer = [NSString stringWithFormat:@"%d",percents];
        cell.answerLabel.text = [answer stringByAppendingString:@"%"];

        
    }
    return cell;

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)finishedWithDictionary:(NSDictionary *)dictionary withTypeRequest:(requestTypes)type
{  
    if(type == kQuestStat){
        self.questionDetailArray = [dictionary valueForKey:@"question"];
    self.receivedArray = [dictionary valueForKey:@"options"];
        for(int i=0;i<self.receivedArray.count;i++){
            NSString *votesForProduct = [[self.receivedArray objectAtIndex:i] valueForKey:@"cnt"];
            //  NSLog(@" gg %d", [votesForProduct integerValue  ])   ;
            self.totalVotes = self.totalVotes + [votesForProduct integerValue] ;
         
            [self.imageView setImageWithURL:[self.questionDetailArray objectForKey:@"image"] placeholderImage:[UIImage imageNamed:@"placeholder_415*415.png"]];
       
            if(self.interfaceIndex ==1){
                [self.tableView setUserInteractionEnabled:NO];            }
            else{
                if ([[UIScreen mainScreen] bounds].size.height != 568){
                    if(self.receivedArray.count>5){
                        [self.tableView setUserInteractionEnabled:YES];
                        
                    }
                    else{
                        [self.tableView setUserInteractionEnabled:NO];
                    }
                }
            }


        }
       
        
    //[self buildView];
    }
    NSString *response = [[dictionary valueForKey:@"message"] valueForKey:@"text"];
    if([response isEqualToString:@"To get access to this page please log in to the system."]){
        UIAlertView *failmessage = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"Пожалуйста перезайдите в систему!" delegate:self cancelButtonTitle:@"Ок" otherButtonTitles:nil];
        [failmessage show];
        
    }
        NSInteger ttotal;
     ttotal = self.totalVotes;
    
    // [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"DownloadIsCompletedKey",nil)];
    NSLog(@"COUNT %d", self.receivedArray.count);
     [self.votedLabel setText:[NSLocalizedString(@"VotedKey", nil) stringByAppendingString:[NSString stringWithFormat:@"%d", ttotal]]];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView reloadData];

    
}



- (void)viewDidUnload {
    [self setVotedLabel:nil];
    [super viewDidUnload];
}
@end
