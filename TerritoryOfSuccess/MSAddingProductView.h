//
//  MSAddingProductView.h
//  TerritoryOfSuccess
//
//  Created by Matrix Soft on 3/18/13.
//  Copyright (c) 2013 Matrix Soft. All rights reserved.
//

#import "MSAnimationView.h"
#import "MSAPI.h"
@protocol dismissViewAdd

@required
-(void)dismissPopViewAdd:(BOOL)sendResult;
-(void)updateTable;

@end

@interface MSAddingProductView : MSAnimationView<UITextFieldDelegate, WsCompleteDelegate>
@property (strong, nonatomic) id <dismissViewAdd> delegate;
@property (nonatomic, strong) MSAPI *api;

@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIImageView *productImageView;
@property (strong, nonatomic) UITextField *productTextField;
@property (strong, nonatomic) UITextField *brandTextField;
@property (strong, nonatomic) UILabel *categoryLabel;
@property (strong, nonatomic) UILabel *brandLabel;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIButton *sendProductButton;

@property (strong, nonatomic) NSNotificationCenter *nc;

@property (strong, nonatomic) UIImage *sendingImage;
@property (strong, nonatomic) NSString *sendingText;
@property (nonatomic) NSInteger categoryID;
-(id)initWithOrigin:(CGPoint)origin;
-(void)blackOutOfBackground;
@end
