//
//  MSTipsViewController.h
//  TerritoryOfSuccess
//
//  Created by Matrix Soft on 4/17/13.
//  Copyright (c) 2013 Matrix Soft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSTipsViewController : UIViewController<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *tipsScrollView;
- (IBAction)closeButton:(id)sender;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UIPageControl *tipsPageControl;

@end
