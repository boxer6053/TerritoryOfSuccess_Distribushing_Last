//
//  MSTabBarController.m
//  TerritoryOfSuccess
//
//  Created by Matrix Soft on 08.01.13.
//  Copyright (c) 2013 Matrix Soft. All rights reserved.
//

#import "MSTabBarController.h"

@interface MSTabBarController ()

@end

@implementation MSTabBarController

@synthesize myTabBarController = _myTabBarController;
@synthesize receivedData = _receivedData;

@synthesize iteamSelectedTag = _iteamSelectedTag;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self.tabBar.items objectAtIndex:0] setTitle:NSLocalizedString(@"MainTabBarItemKey", nil)];
    [[self.tabBar.items objectAtIndex:1] setTitle:NSLocalizedString(@"CatalogueTabBarItemKey", nil)];
    [[self.tabBar.items objectAtIndex:2] setTitle:NSLocalizedString(@"InquirerTabBarItemKey", nil)];
    [[self.tabBar.items objectAtIndex:3] setTitle:NSLocalizedString(@"NewsTabBarItemKey", nil)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{

}

@end
