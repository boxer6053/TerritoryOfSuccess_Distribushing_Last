//
//  MSDatePickerView.h
//  TerritoryOfSuccess
//
//  Created by Alex on 2/20/13.
//  Copyright (c) 2013 Matrix Soft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MSDatePickerView;

@protocol MSDatePickerViewDelegate

-(void)msDatePickerViewDoneButtonPressed:(MSDatePickerView *)pickerView;
-(void)msDatePickerViewCancelButtonPressed:(MSDatePickerView *)pickerView;

@end

@interface MSDatePickerView : UIView

@property (strong, nonatomic) UIDatePicker *datePickerView;
@property (strong, nonatomic) UIToolbar *pickerToolBar;
@property (strong, nonatomic) UIBarButtonItem *cancelButton;
@property (strong, nonatomic) UIBarButtonItem *spacer;
@property (strong, nonatomic) UIBarButtonItem *doneButton;

@property (strong, nonatomic) id<MSDatePickerViewDelegate> delegate;
@property (strong, nonatomic) UITextField *target;
@property (strong, nonatomic) NSString *selectedDate;

@end
