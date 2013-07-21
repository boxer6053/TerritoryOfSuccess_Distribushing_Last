//
//  MSComplaintView.h
//  TerritoryOfSuccess
//
//  Created by Matrix Soft on 11.02.13.
//  Copyright (c) 2013 Matrix Soft. All rights reserved.
//

#import "MSAnimationView.h"
#import <QuartzCore/QuartzCore.h>

@protocol MSComplaintViewDelegate

- (void)startCameraWithImagePickerController:(UIImagePickerController *)pickerController;
- (void)closeCameraWithImagePickerController:(UIImagePickerController *)pickerController;

@end

@interface MSComplaintView : MSAnimationView<UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) id<MSComplaintViewDelegate> delegate;

@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIImageView *mainFishkaImageView;
@property (strong, nonatomic) UILabel *mainFishkaLabel;
@property (strong, nonatomic) UILabel *productLabel;
@property (strong, nonatomic) UITextField *productTextField;
@property (strong, nonatomic) UILabel *codeLabel;
@property (strong, nonatomic) UITextField *codeTextField;
@property (strong, nonatomic) UILabel *locationLabel;
@property (strong, nonatomic) UITextField *locationTextField;
@property (strong, nonatomic) UITextView *commentTextView;
@property (strong, nonatomic) UIButton *sendComplaintButton;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIButton *closeButton;
@property (strong, nonatomic) UIButton *productImageButton;

@property (strong, nonatomic) UIImagePickerController *imagePickerController;

@end
