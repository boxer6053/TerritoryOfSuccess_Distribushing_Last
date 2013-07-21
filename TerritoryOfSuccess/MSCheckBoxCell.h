//
//  MSCheckBoxCell.h
//  TerritoryOfSuccess
//
//  Created by Alex on 2/15/13.
//  Copyright (c) 2013 Matrix Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSCheckBoxCell :  UITableViewCell

@property (nonatomic) BOOL isChecked;

@property (weak, nonatomic) IBOutlet UIButton *checkboxButton;
@property (weak, nonatomic) IBOutlet UILabel *checkboxLabel;

- (IBAction)checkboxButtonPressed:(id)sender;

- (void)setSelection;
@end
