//
//  MSTipsCell.m
//  TerritoryOfSuccess
//
//  Created by Matrix Soft on 4/17/13.
//  Copyright (c) 2013 Matrix Soft. All rights reserved.
//

#import "MSTipsCell.h"

@implementation MSTipsCell
@synthesize tipsButton = _tipsButton;
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
