//
//  MSNewsViewController.h
//  TerritoryOfSuccess
//
//  Created by Alex on 1/14/13.
//  Copyright (c) 2013 Matrix Soft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSAPI.h"

@interface MSNewsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, WsCompleteDelegate>
@property (weak, nonatomic) IBOutlet UITableView *newsTableView;

@end
