//
//  MSLogInView.m
//  TerritoryOfSuccess
//
//  Created by Alex on 2/1/13.
//  Copyright (c) 2013 Matrix Soft. All rights reserved.
//

#import "MSLogInView.h"
#import <QuartzCore/QuartzCore.h>
#import "SVProgressHUD.h"

@implementation MSLogInView

@synthesize emailLabel = _emailLabel;
@synthesize emailTextField = _emailTextField;
@synthesize passwordLabel = _passwordLabel;
@synthesize passwordTextField = _passwordTextField;
@synthesize passwordConfirmLabel = _passwordConfirmLabel;
@synthesize passwordConfirmTextField = _passwordConfirmTextField;
@synthesize loginButton = _loginButton;
@synthesize cancelButton = _cancelButton;
@synthesize registrationButton = _registrationButton;
@synthesize registrationMode = _registrationMode;
@synthesize backToLoginButton = _backToLoginButton;
@synthesize loginView = _loginView;
@synthesize api =_api;
@synthesize tapRecognizer = _tapRecognizer;
@synthesize nc = _nc;

- (MSAPI *)api
{
    if(!_api)
    {
        _api = [[MSAPI alloc]init];
        _api.delegate = self;
    }
    return _api;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self = [self init];
    }
    return self;
}

- (id)initWithOrigin:(CGPoint)origin
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self)
    {
        self.registrationMode = NO;
        
        [self setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];

        self.loginView = [[UIView alloc]initWithFrame:CGRectMake(origin.x, origin.y, 270, 180)];
        [self.loginView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"dialogViewGradient.png"]]];
        [self.loginView.layer setCornerRadius:10.0];
        [self.loginView.layer setBorderColor:[UIColor colorWithWhite:0.5 alpha:1.0].CGColor];
        [self.loginView.layer setBorderWidth:2.0];
        [self.loginView setClipsToBounds:YES];
        [self addSubview:self.loginView];
        
        //email input
        self.emailLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 70, 21)];
        self.emailLabel.text = @"e-mail:";
        self.emailLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
        self.emailLabel.textColor = [UIColor whiteColor];
        self.emailLabel.backgroundColor = [UIColor clearColor];
        [self.loginView addSubview:self.emailLabel];
        
        self.emailTextField = [[UITextField alloc]initWithFrame:CGRectMake(85, 15, 175, 30)];
        self.emailTextField.borderStyle = UITextBorderStyleRoundedRect;
        self.emailTextField.clearButtonMode = YES;
        self.emailTextField.delegate = self;
        self.emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
        [self.loginView addSubview:self.emailTextField];
        
        //password input
        self.passwordLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 56, 70, 21)];
        self.passwordLabel.text = NSLocalizedString(@"пароль:", nil);
        self.passwordLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
        self.passwordLabel.textColor = [UIColor whiteColor];
        self.passwordLabel.backgroundColor = [UIColor clearColor];
        [self.loginView addSubview:self.passwordLabel];
        
        self.passwordTextField = [[UITextField alloc]initWithFrame:CGRectMake(85, 51, 175, 30)];
        self.passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
        self.passwordTextField.secureTextEntry = YES;
        self.passwordTextField.delegate = self;
        [self.loginView addSubview:self.passwordTextField];
        
        //confrim password input for registration
        self.passwordConfirmLabel = [[UILabel alloc]initWithFrame:CGRectMake(280, 92, 70, 21)];
        self.passwordConfirmLabel.text = NSLocalizedString(@"пароль:", nil);
        self.passwordConfirmLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
        self.passwordConfirmLabel.textColor = [UIColor whiteColor];
        self.passwordConfirmLabel.backgroundColor = [UIColor clearColor];
        [self.loginView addSubview:self.passwordConfirmLabel];
        
        self.passwordConfirmTextField = [[UITextField alloc]initWithFrame:CGRectMake(355, 87, 125, 30)];
        self.passwordConfirmTextField.borderStyle = UITextBorderStyleRoundedRect;
        self.passwordConfirmTextField.secureTextEntry = YES;
        self.passwordConfirmTextField.delegate = self;
        [self.loginView addSubview:self.passwordConfirmTextField];
        
        self.backToLoginButton = [[UIButton alloc]initWithFrame:CGRectMake(485, 87, 45, 30)];
        [self.backToLoginButton setBackgroundColor:[UIColor clearColor]];
        self.backToLoginButton.titleLabel.textColor = [UIColor orangeColor];
        [self.backToLoginButton setTitle:@">" forState:UIControlStateNormal];
        [self.backToLoginButton addTarget:self action:@selector(backToLoginButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.loginView addSubview:self.backToLoginButton];
        
        //buttons
        self.cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 131, 120, 35)];
        [self.cancelButton setBackgroundImage:[UIImage imageNamed:@"button_120*35_new.png"] forState:UIControlStateNormal];
        self.cancelButton.titleLabel.textColor = [UIColor whiteColor];
        self.cancelButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
        [self.cancelButton setTitle:NSLocalizedString(@"Отмена", nil) forState:UIControlStateNormal];
        [self.cancelButton addTarget:self action:@selector(cancelPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.loginView addSubview:self.cancelButton];
        
        self.loginButton = [[UIButton alloc]initWithFrame:CGRectMake(140, 131, 120, 35)];
        [self.loginButton setBackgroundImage:[UIImage imageNamed:@"button_120*35_new.png"] forState:UIControlStateNormal];
        self.loginButton.titleLabel.textColor = [UIColor whiteColor];
        self.loginButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
        [self.loginButton setTitle:NSLocalizedString(@"Войти", nil) forState:UIControlStateNormal];
        [self.loginButton addTarget:self action:@selector(loginPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.loginView addSubview:self.loginButton];
        
        self.registrationButton = [[UIButton alloc]initWithFrame:CGRectMake(60, 91, 200, 30)];
        [self.registrationButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [self.registrationButton setBackgroundColor:[UIColor clearColor]];
        [self.registrationButton.titleLabel setTextColor:[UIColor orangeColor]];
        self.registrationButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
        [self.registrationButton setTitle:NSLocalizedString(@"Зарегестрироваться", nil) forState:UIControlStateNormal];
        [self.registrationButton addTarget:self action:@selector(registrationPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.loginView addSubview:self.registrationButton];
//        self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapAnywhere:)];
        
        self.nc = [NSNotificationCenter defaultCenter];
        
        [self.nc addObserver:self selector:@selector(keyboardWillShow:) name:
         UIKeyboardWillShowNotification object:nil];
        
        [self.nc addObserver:self selector:@selector(keyboardWillHide:) name:
         UIKeyboardWillHideNotification object:nil];

        [self loadLatestEmail];
    }
    return self;
}

-(void)blackOutOfBackground
{
    [UIView animateWithDuration:0.2 animations:^
    {
        [self setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.7]];
    }];
}

- (void)didTapAnywhere:(UITapGestureRecognizer*)recognizer
{
    [self.emailTextField resignFirstResponder];
    [self.passwordConfirmTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

-(void)cancelPressed
{
    [self.nc removeObserver:self];
    self.nc = nil;
    [self dismissLoginViewWithResult:NO];
}

-(void)loginPressed
{
    if(self.registrationMode)
    {
        if ([self.passwordConfirmTextField.text isEqualToString:self.passwordTextField.text])
        {
            //[SVProgressHUD showWithStatus:NSLocalizedString(@"Регистрация...", nil)];
            [self.api registrationWithEmail:self.emailTextField.text Password:self.passwordTextField.text ConfirmPassword:self.passwordConfirmTextField.text];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Ошибка", nil) message:NSLocalizedString(@"Поля пароль и подтверждение пароля неодинаковые", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
        
    }
    else
    {
        //[SVProgressHUD showWithStatus:NSLocalizedString(@"Авторизация",nil)];
        [self.api logInWithMail:self.emailTextField.text Password:self.passwordTextField.text];
    }
}

- (void)keyboardWillShow:(NSNotification *)note
{
    if (!([[UIScreen mainScreen] bounds].size.height == 568))
    {
        [UIView animateWithDuration:0.2 animations:
         ^{
             self.loginView.frame = CGRectMake(self.loginView.frame.origin.x, self.loginView.frame.origin.y - 50, self.loginView.frame.size.width, self.loginView.frame.size.height);
        }];
    }
//    [self addGestureRecognizer:self.tapRecognizer];
}

- (void)keyboardWillHide:(NSNotification *)note
{
    if (!([[UIScreen mainScreen] bounds].size.height == 568))
    {
        [UIView animateWithDuration:0.2 animations:
         ^{
             self.loginView.frame = CGRectMake(self.loginView.frame.origin.x, self.loginView.frame.origin.y + 50, self.loginView.frame.size.width, self.loginView.frame.size.height);
         }];
    }
//    [self removeGestureRecognizer:self.tapRecognizer];
}

-(void)registrationPressed
{
    [UIView animateWithDuration:1.0 animations:^
     {
         self.registrationButton.frame = CGRectMake(-210, 91, self.registrationButton.frame.size.width, self.registrationButton.frame.size.height);
         self.passwordConfirmLabel.frame = CGRectMake(10, self.passwordConfirmLabel.frame.origin.y, self.passwordConfirmLabel.frame.size.width, self.passwordConfirmLabel.frame.size.height);
         self.passwordConfirmTextField.frame = CGRectMake(85, self.passwordConfirmTextField.frame.origin.y, self.passwordConfirmTextField.frame.size.width, self.passwordConfirmTextField.frame.size.height);
         self.backToLoginButton.frame = CGRectMake(215, self.backToLoginButton.frame.origin.y, self.backToLoginButton.frame.size.width, self.backToLoginButton.frame.size.height);
         [self.loginButton setTitle:NSLocalizedString(@"Зарегестрироваться",nil) forState:UIControlStateNormal];
     }];
    self.registrationMode = YES;
}
-(void)backToLoginButtonPressed
{
    [UIView animateWithDuration:1.0 animations:^
     {
         self.registrationButton.frame = CGRectMake(60, 91, self.registrationButton.frame.size.width, self.registrationButton.frame.size.height);
         self.passwordConfirmLabel.frame = CGRectMake(280, self.passwordConfirmLabel.frame.origin.y, self.passwordConfirmLabel.frame.size.width, self.passwordConfirmLabel.frame.size.height);
         self.passwordConfirmTextField.frame = CGRectMake(355, self.passwordConfirmTextField.frame.origin.y, self.passwordConfirmTextField.frame.size.width, self.passwordConfirmTextField.frame.size.height);
         self.backToLoginButton.frame = CGRectMake(455, self.backToLoginButton.frame.origin.y, self.backToLoginButton.frame.size.width, self.backToLoginButton.frame.size.height);
         [self.loginButton setTitle:NSLocalizedString(@"Войти",nil) forState:UIControlStateNormal];
     }];
    self.registrationMode = NO;
}

-(void)finishedWithDictionary:(NSDictionary *)dictionary withTypeRequest:(requestTypes)type
{
    if (type == kAuth)
    {
        if ([[dictionary valueForKey:@"status"] isEqualToString:@"ok"])
        {
            if ([dictionary valueForKey:@"token"] == nil)
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Ошибка",nil) message:NSLocalizedString(@"Ошибка на сервере",nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
                //[SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Ошибка на сервере",nil)];
            }
            else
            {
                [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Авторизация прошла успешно.",nil)];
                NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
                [userDefults setObject:[dictionary valueForKey:@"token"] forKey:@"authorization_Token"];
                [userDefults synchronize];
                [userDefults setObject:self.emailTextField.text forKey:@"latestEmail"];
                [self dismissLoginViewWithResult:YES];
            }
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Ошибка",nil) message:NSLocalizedString(@"Неправильный пароль или email",nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
    }
    if (type == kRegist)
    {
        if ([[dictionary valueForKey:@"status"] isEqualToString:@"ok"])
        {
            //[SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Регистрация прошла успешно.",nil)];
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Регистрация",nil) message:[dictionary valueForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            [self dismissLoginViewWithResult:YES];
        }
        else //if([[dictionary valueForKey:@"message"] isEqualToString:@"!-- is_unique --!"])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Ошибка",nil) message:NSLocalizedString(@"Такой email уже используется",nil)delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            //[SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Ошибка",nil)];
            //[SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Такой email уже используется",nil)];
        }
    }
}

-(void)finishedWithError:(NSError *)error TypeRequest:(requestTypes)type
{
    if (type == kRegist)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Ошибка",nil) message:error.localizedDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

-(void)dismissLoginViewWithResult:(BOOL)result
{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0.0;
    }
    completion:^(BOOL finished)
    {
        [self removeFromSuperview];
        [self.delegate dismissPopView:result];
    }];
}

-(void)loadLatestEmail
{
    NSString *latestEmail = [[NSUserDefaults standardUserDefaults] objectForKey:@"latestEmail"];
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"latestEmail"]);
    if(latestEmail.length != 0)
        self.emailTextField.text = latestEmail;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
