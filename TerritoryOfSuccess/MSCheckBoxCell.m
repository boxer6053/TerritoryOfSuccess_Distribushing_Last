//
//  MSCheckBoxCell.m
//  TerritoryOfSuccess
//
//  Created by Alex on 2/15/13.
//  Copyright (c) 2013 Matrix Soft. All rights reserved.
//

#import "MSCheckBoxCell.h"

@implementation MSCheckBoxCell

@synthesize checkboxButton =_checkboxButton;
@synthesize checkboxLabel = _checkboxLabel;
@synthesize isChecked = _isChecked;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {

    }
    return self;
}

- (void)setSelection
{
    if (!self.isChecked)
    {
        [self.checkboxButton setBackgroundImage:[UIImage imageNamed:@"checkbox_empty.png"] forState:UIControlStateNormal];
    }
    else
    {
        [self.checkboxButton setBackgroundImage:[UIImage imageNamed:@"checkbox_full.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)checkboxButtonPressed:(id)sender
{
    if (self.isChecked)
    {
        self.isChecked = NO;
        [self.checkboxButton setBackgroundImage:[UIImage imageNamed:@"checkbox_empty.png"] forState:UIControlStateNormal];
    }
    else
    {
        self.isChecked = YES;
        [self.checkboxButton setBackgroundImage:[UIImage imageNamed:@"checkbox_full.png"] forState:UIControlStateNormal];
    }
}
@end
