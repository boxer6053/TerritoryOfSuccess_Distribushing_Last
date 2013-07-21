//
//  MSStatisticCell.m
//  TerritoryOfSuccess
//
//  Created by Matrix Soft on 2/22/13.
//  Copyright (c) 2013 Matrix Soft. All rights reserved.
//

#import "MSStatisticCell.h"

@implementation MSStatisticCell
@synthesize titleLabel = _titleLabel;
@synthesize rateView = _rateView;
@synthesize answerLabel = _answerLabel  ;
@synthesize productImageView = _productImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
