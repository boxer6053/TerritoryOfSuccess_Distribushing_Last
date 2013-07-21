//
//  MSLogInView.h
//  TerritoryOfSuccess
//
//  Created by Alex on 2/1/13.
//  Copyright (c) 2013 Matrix Soft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSAnimationView.h"
#import "MSAPI.h"
@protocol dismissView

@required
-(void)dismissPopView:(BOOL)loginResult;

@end

@interface MSLogInView : MSAnimationView <WsCompleteDelegate, UITextFieldDelegate>

@property (strong, nonatomic) id <dismissView> delegate;
@property (nonatomic) BOOL registrationMode;
@property (nonatomic, strong) MSAPI *api;

@property (strong, nonatomic) UILabel *emailLabel;
@property (strong, nonatomic) UITextField *emailTextField;
@property (strong, nonatomic) UILabel *passwordLabel;
@property (strong, nonatomic) UITextField *passwordTextField;
@property (strong, nonatomic) UILabel *passwordConfirmLabel;
@property (strong, nonatomic) UITextField *passwordConfirmTextField;
@property (strong, nonatomic) UIButton *loginButton;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIButton *registrationButton;
@property (strong, nonatomic) UIButton *backToLoginButton;
@property (strong, nonatomic) UIView *loginView;

@property (strong, nonatomic) UITapGestureRecognizer *tapRecognizer;
@property (strong, nonatomic) NSNotificationCenter *nc;

-(id)initWithOrigin:(CGPoint)origin;
-(void)blackOutOfBackground;

@end
