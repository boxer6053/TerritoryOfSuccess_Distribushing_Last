//
//  MSFirstNavigationController.m
//  TerritoryOfSuccess
//
//  Created by Matrix Soft on 08.01.13.
//  Copyright (c) 2013 Matrix Soft. All rights reserved.
//

#import "MSFirstNavigationController.h"
#import "MSiOSVersionControlHeader.h"

@interface MSFirstNavigationController ()

@end

@implementation MSFirstNavigationController

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
//        [self.mainNavigationBar setFrame:CGRectMake(0, 0, 320, 64)];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}
@end
