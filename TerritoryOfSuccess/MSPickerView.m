//
//  MSPickerView.m
//  TerritoryOfSuccess
//
//  Created by Alex on 2/19/13.
//  Copyright (c) 2013 Matrix Soft. All rights reserved.
//

#import "MSPickerView.h"

@implementation MSPickerView

@synthesize pickerView = _pickerView;
@synthesize pickerToolBar = _pickerToolBar;
@synthesize cancelButton = _cancelButton;
@synthesize spacer = _spacer;
@synthesize doneButton = _doneButton;
@synthesize target = _target;
@synthesize dataSource = _dataSource;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 44, self.frame.size.width, self.frame.size.height - 44)];
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        self.pickerView.showsSelectionIndicator = YES;
        
        self.pickerToolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
        self.pickerToolBar.barStyle = UIBarStyleBlackTranslucent;
        self.doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(pickerViewDonePressed)];
        [self.doneButton setTintColor:[UIColor orangeColor]];
        self.cancelButton = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(pickerViewCancelPressed)];
        [self.cancelButton setTintColor:[UIColor orangeColor]];
        self.spacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        self.pickerToolBar.items = [NSArray arrayWithObjects:self.cancelButton, self.spacer, self.doneButton, nil];
        
        [self addSubview:self.pickerToolBar];
        [self addSubview:self.pickerView];
    }
    return self;
}

-(void)pickerViewCancelPressed
{
    [self.delegate msPickerViewCancelButtonPressed:self];
}

-(void)pickerViewDonePressed
{
    [self.delegate msPickerViewDoneButtonPressed:self];
}

#pragma mark - UIPickerView Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.dataSource.count;
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[self.dataSource objectAtIndex:row ] valueForKey:@"value"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectedItem = [self.dataSource objectAtIndex:row];
}

@end
