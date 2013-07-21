//
//  MSProfileViewController.h
//  TerritoryOfSuccess
//
//  Created by Alex on 1/29/13.
//  Copyright (c) 2013 Matrix Soft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSPickerView.h"
#import "MSDatePickerView.h"
#import "MSAPI.h"

@interface MSProfileViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, WsCompleteDelegate, MSPickerViewDelegate, MSDatePickerViewDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *profileTableView;
@property (weak, nonatomic) IBOutlet UILabel *bonusPointsLabel;
@property (weak, nonatomic) IBOutlet UIView *bonusView;
@property (weak, nonatomic) IBOutlet UILabel *pressLabel;

- (IBAction)logoutButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *logoutButton;
@end
