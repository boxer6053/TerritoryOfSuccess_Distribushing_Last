//
//  MSDetailViewNavigationController.m
//  TerritoryOfSuccess
//
//  Created by matrixsoft on 17.01.13.
//  Copyright (c) 2013 Matrix Soft. All rights reserved.
//

#import "MSDetailViewNavigationController.h"

@implementation MSDetailViewNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
       [self.detailNavigationBar setBackgroundImage:[UIImage imageNamed:@"logoDetailBackground.png"] forBarMetrics:UIBarMetricsDefault];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
