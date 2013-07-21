//
//  MSPickerView.h
//  TerritoryOfSuccess
//
//  Created by Alex on 2/19/13.
//  Copyright (c) 2013 Matrix Soft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MSPickerView;

@protocol MSPickerViewDelegate

-(void)msPickerViewDoneButtonPressed:(MSPickerView *)pickerView;
-(void)msPickerViewCancelButtonPressed:(MSPickerView *)pickerView;

@end

@interface MSPickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) UIToolbar *pickerToolBar;
@property (strong, nonatomic) UIBarButtonItem *cancelButton;
@property (strong, nonatomic) UIBarButtonItem *spacer;
@property (strong, nonatomic) UIBarButtonItem *doneButton;

@property (strong, nonatomic) id<MSPickerViewDelegate> delegate;
@property (strong, nonatomic) UITextField *target;
@property (strong, nonatomic) NSArray *dataSource;
@property (strong, nonatomic) id selectedItem;

@end
