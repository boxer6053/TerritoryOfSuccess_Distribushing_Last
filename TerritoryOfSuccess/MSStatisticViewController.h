//
//  MSStatisticViewController.h
//  TerritoryOfSuccess
//
//  Created by Matrix Soft on 2/19/13.
//  Copyright (c) 2013 Matrix Soft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSAPI.h"

@interface MSStatisticViewController : UIViewController <WsCompleteDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) NSInteger interfaceIndex;
@property (nonatomic) NSInteger questionID;
@property (strong, nonatomic) NSArray *receivedArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *names;
@property (weak, nonatomic) IBOutlet UILabel *votedLabel;

@end
