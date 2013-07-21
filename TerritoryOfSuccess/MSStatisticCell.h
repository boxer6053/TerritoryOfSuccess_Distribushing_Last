//
//  MSStatisticCell.h
//  TerritoryOfSuccess
//
//  Created by Matrix Soft on 2/22/13.
//  Copyright (c) 2013 Matrix Soft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrettyTableViewCell.h"

@interface MSStatisticCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rateView;
@property (weak, nonatomic) IBOutlet UILabel *answerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;

@end
