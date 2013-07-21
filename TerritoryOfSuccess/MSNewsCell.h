//
//  MSNewsCell.h
//  TerritoryOfSuccess
//
//  Created by Alex on 1/25/13.
//  Copyright (c) 2013 Matrix Soft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSNewsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *newsImageView;
@property (weak, nonatomic) IBOutlet UILabel *newsTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *newsDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *newsDateLabel;

@end
