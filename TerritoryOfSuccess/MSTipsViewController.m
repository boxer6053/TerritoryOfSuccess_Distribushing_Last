//
//  MSTipsViewController.m
//  TerritoryOfSuccess
//
//  Created by Matrix Soft on 4/17/13.
//  Copyright (c) 2013 Matrix Soft. All rights reserved.
//

#import "MSTipsViewController.h"
#import "MSiOSVersionControlHeader.h"

@interface MSTipsViewController ()

@end

@implementation MSTipsViewController
@synthesize tipsScrollView = _tipsScrollView;
@synthesize navigationBar = _navigationBar;
@synthesize tipsPageControl = _tipsPageControl;

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
        [self.navigationBar setFrame:CGRectMake(0, 0, 320, 64)];
    }
    self.navigationBar.topItem.title = NSLocalizedString(@"TipsKey", nil);
  NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSLog(@"lang = %@",language);
      [self.tipsScrollView setContentSize:CGSizeMake(320*9
                                                   , [[UIScreen mainScreen] bounds].size.height - 64)];
    [self.tipsScrollView setDelegate:self];
    for(int i=0;i<=8;i++){
//        UIImageView *view = [[UIImageView alloc] initWithFrame:(CGRectMake(i*320, 0, 320, 416))];
        UIImageView *view = [[UIImageView alloc] initWithFrame:(CGRectMake(i*320, 0, 320, [[UIScreen mainScreen] bounds].size.height - 64))];
        if ([[UIScreen mainScreen] bounds].size.height == 568)
        {
            [view setContentMode:UIViewContentModeCenter];
        }
        
        NSString *imageName = [NSString stringWithFormat:@"%d",i+1];
        NSString *newName = [imageName stringByAppendingString:@"_"];
        NSString *newName1 = [newName stringByAppendingString:imageName];
        NSString *newName2 = [newName1 stringByAppendingString:@"_"];
        NSString *newName3 = [newName2 stringByAppendingString:language];
        NSString *newName4 = [newName3 stringByAppendingString:@".png"];
        NSLog(@"%@",newName4);
        
        [view setImage:[UIImage imageNamed:newName4]];
        [self.tipsScrollView addSubview:view];
        
    }
    
    self.tipsScrollView.pagingEnabled = YES;
    
    [self.tipsPageControl setCurrentPage:0];
    [self.tipsPageControl setNumberOfPages:9];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTipsScrollView:nil];
    [self setNavigationBar:nil];
    [self setTipsPageControl:nil];
      [super viewDidUnload];
}
- (IBAction)closeButton:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float pageWidth = self.tipsScrollView.frame.size.width;
    int page = floor((self.tipsScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.tipsPageControl.currentPage = page;
}
@end
