//
//  MSNewsCell.m
//  TerritoryOfSuccess
//
//  Created by Alex on 1/25/13.
//  Copyright (c) 2013 Matrix Soft. All rights reserved.
//

#import "MSNewsCell.h"

@implementation MSNewsCell

@synthesize newsDateLabel = _newsDateLabel;
@synthesize newsDetailLabel = _newsDetailLabel;
@synthesize newsImageView = _newsImageView;
@synthesize newsTitleLabel = _newsTitleLabel;

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
