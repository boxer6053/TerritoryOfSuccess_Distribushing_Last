//
//  MSDatePickerView.m
//  TerritoryOfSuccess
//
//  Created by Alex on 2/20/13.
//  Copyright (c) 2013 Matrix Soft. All rights reserved.
//

#import "MSDatePickerView.h"

@implementation MSDatePickerView

@synthesize datePickerView = _datePickerView;
@synthesize pickerToolBar = _pickerToolBar;
@synthesize cancelButton = _cancelButton;
@synthesize spacer = _spacer;
@synthesize doneButton = _doneButton;
@synthesize target = _target;
@synthesize selectedDate = _selectedDate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.datePickerView = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 44, self.frame.size.width, self.frame.size.height - 44)];
        self.datePickerView.datePickerMode = UIDatePickerModeDate;
        
        self.pickerToolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
        self.pickerToolBar.barStyle = UIBarStyleBlackTranslucent;
        self.doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(pickerViewDonePressed)];
        [self.doneButton setTintColor:[UIColor orangeColor]];
        self.cancelButton = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(pickerViewCancelPressed)];
        [self.cancelButton setTintColor:[UIColor orangeColor]];
        self.spacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        self.pickerToolBar.items = [NSArray arrayWithObjects:self.cancelButton, self.spacer, self.doneButton, nil];
        
        [self addSubview:self.pickerToolBar];
        [self addSubview:self.datePickerView];
    }
    return self;
}

- (void)pickerViewDonePressed
{
    NSDate *date = [self.datePickerView date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormat stringFromDate:date];
    self.selectedDate = dateString;
    [self.delegate msDatePickerViewDoneButtonPressed:self];
}

- (void)pickerViewCancelPressed
{
    [self.delegate msDatePickerViewCancelButtonPressed:self];
}

@end
