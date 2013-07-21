//
//  MSDialogView.m
//  TerritoryOfSuccess
//
//  Created by Matrix Soft on 26.01.13.
//  Copyright (c) 2013 Matrix Soft. All rights reserved.
//

#import "MSDialogView.h"

@implementation MSDialogView

@synthesize closeButton = _closeButton;
@synthesize captionLabel = _captionLabel;
@synthesize productImageView = _productImageView;
@synthesize productLabel = _productLabel;
@synthesize categoryLabel = _categoryLabel;
@synthesize productDescriptionView = _productDescriptionView;
@synthesize productDescripptionLabel = _productDescripptionLabel;
@synthesize categoryDescriptionView = _categoryDescriptionView;
@synthesize categoryDescripptionLabel = _categoryDescripptionLabel;
@synthesize messageView = _messageView;
//@synthesize mainFishkaImageView = _mainFishkaImageView;
@synthesize okButton = _okButton;
@synthesize complaint = _complaint;
@synthesize bonusLabel = _bonusLabel;
@synthesize bonusValueLabel = _bonusValueLabel;
@synthesize bonusNameLabel = _bonusNameLabel;
@synthesize mainFishkaImageView = _mainFishkaImageView;
@synthesize mainFishkaLabel = _mainFishkaLabel;
@synthesize contentView = _contentView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 4, self.frame.size.width, self.frame.size.height - 4)];
        [self.contentView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"dialogViewGradient.png"]]];
        //    [contentView setBackgroundColor:[UIColor colorWithWhite:1 alpha:0]];
        [self.contentView.layer setCornerRadius:10.0];
        [self.contentView.layer setBorderColor:[UIColor colorWithWhite:0.5 alpha:1.0].CGColor];
        [self.contentView.layer setBorderWidth:2.0];
        [self.contentView setClipsToBounds:YES];
        [self addSubview:self.contentView];
        
        self.mainFishkaImageView = [[UIImageView alloc] initWithFrame:CGRectMake(56, 0, 198, 33)];
        [self.mainFishkaImageView setImage:[UIImage imageNamed:@"TOS cap.png"]];
        [self addSubview:self.mainFishkaImageView];
        
        self.mainFishkaLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 178, 20)];
        self.mainFishkaLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
        [self.mainFishkaLabel setTextColor:[UIColor whiteColor]];
        [self.mainFishkaLabel setBackgroundColor:[UIColor clearColor]];
        [self.mainFishkaLabel setTextAlignment:NSTextAlignmentCenter];
        [self.mainFishkaLabel setText:NSLocalizedString(@"ПРОВЕРКА КОДА",nil)];
        [self.mainFishkaImageView addSubview:self.mainFishkaLabel];
        
        //кнопка Close
        self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.closeButton setFrame:CGRectMake(287, 8, 15, 15)];
        [self.closeButton setBackgroundImage:[UIImage imageNamed:@"closeIcon.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.closeButton];
        
        //мітка стану коду
        self.captionLabel = [[UILabel alloc] init];
        [self.captionLabel setFrame:CGRectMake(93, 40, 124, 21)];
        self.captionLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.0];
        [self.captionLabel setTextColor:[UIColor colorWithRed:255.0 green:102/255.0 blue:0 alpha:1.0]];
        [self.captionLabel setBackgroundColor:[UIColor clearColor]];
        [self.captionLabel setTextAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:self.captionLabel];
        
        //product imageView
        self.productImageView = [[UIImageView alloc] init];
        [self.productImageView setFrame:CGRectMake(10, 71, 100, 100)];
        [self.productImageView setClipsToBounds:YES];
        [self.productImageView.layer setCornerRadius:7.0];
        [self.productImageView.layer setBorderWidth:1.0];
        [self.productImageView.layer setBorderColor:[[UIColor colorWithWhite:0.5 alpha:1.0] CGColor]];
        [self.contentView addSubview:self.productImageView];
        
        //мітка заголовку продукта
        self.productLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, self.productImageView.frame.origin.y, 50, 11)];
        self.productLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:11.0];
        [self.productLabel setTextColor:[UIColor colorWithRed:255.0 green:102/255.0 blue:0 alpha:1.0]];
        [self.productLabel setBackgroundColor:[UIColor clearColor]];
        [self.productLabel setTextAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.productLabel];
        
        //View опису продукта
        self.productDescriptionView = [[UIView alloc] initWithFrame:CGRectMake(120, self.productLabel.frame.origin.y + self.productLabel.frame.size.height, self.frame.size.width - 10 - 120, 14)];
        [self.productDescriptionView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
        [self.productDescriptionView setClipsToBounds:YES];
        [self.productDescriptionView.layer setCornerRadius:5.0];
        [self.contentView addSubview:self.productDescriptionView];
        
        //мітка опису продукта
        self.productDescripptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.productDescriptionView.frame.size.width - 6, self.productDescriptionView.frame.size.height)];
        [self.productDescripptionLabel setNumberOfLines:0];
        [self.productDescripptionLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self.productDescripptionLabel setBackgroundColor:[UIColor clearColor]];
        self.productDescripptionLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:11.0];
        [self.productDescripptionLabel setTextColor:[UIColor whiteColor]];
        [self.productDescriptionView addSubview:self.productDescripptionLabel];
        
        //мітка заголовку категорії
        self.categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, self.productDescriptionView.frame.origin.y + self.productDescriptionView.frame.size.height + 6, 65, 11)];
        self.categoryLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:11.0];
        [self.categoryLabel setTextColor:[UIColor colorWithRed:255.0 green:102/255.0 blue:0 alpha:1.0]];
        [self.categoryLabel setBackgroundColor:[UIColor clearColor]];
        [self.categoryLabel setTextAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.categoryLabel];
        
        //View опису категорії
        self.categoryDescriptionView = [[UIView alloc] initWithFrame:CGRectMake(120, self.categoryLabel.frame.origin.y + self.categoryLabel.frame.size.height, self.frame.size.width - 10 - 120, 14)];
        [self.categoryDescriptionView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
        [self.categoryDescriptionView setClipsToBounds:YES];
        [self.categoryDescriptionView.layer setCornerRadius:5.0];
        [self.contentView addSubview:self.categoryDescriptionView];
        
        //мітка опису категорії
        self.categoryDescripptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.categoryDescriptionView.frame.size.width - 6, self.categoryDescriptionView.frame.size.height)];
        [self.categoryDescripptionLabel setNumberOfLines:0];
        [self.categoryDescripptionLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self.categoryDescripptionLabel setBackgroundColor:[UIColor clearColor]];
        self.categoryDescripptionLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:11.0];
        [self.categoryDescripptionLabel setTextColor:[UIColor whiteColor]];
        [self.categoryDescriptionView addSubview:self.categoryDescripptionLabel];
        
        //бонус label
        self.bonusLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, self.categoryDescriptionView.frame.origin.y + self.categoryDescriptionView.frame.size.height + 6, 120, 11)];
        self.bonusLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:11.0];
        [self.bonusLabel setTextColor:[UIColor colorWithRed:255.0 green:102/255.0 blue:0 alpha:1.0]];
        [self.bonusLabel setBackgroundColor:[UIColor clearColor]];
        [self.bonusLabel setTextAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.bonusLabel];
        
        //bonus value label
        self.bonusValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, self.bonusLabel.frame.origin.y + self.bonusLabel.frame.size.height, 120, 22)];
        self.bonusValueLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:25.0];
        [self.bonusValueLabel setTextColor:[UIColor whiteColor]];
        [self.bonusValueLabel setBackgroundColor:[UIColor clearColor]];
        [self.bonusValueLabel setTextAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.bonusValueLabel];
        
        //bonus name label
        self.bonusNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, self.bonusValueLabel.frame.origin.y + self.bonusValueLabel.frame.size.height, 120, 12)];
        self.bonusNameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
        [self.bonusNameLabel setTextColor:[UIColor whiteColor]];
        [self.bonusNameLabel setBackgroundColor:[UIColor clearColor]];
        [self.bonusNameLabel setTextAlignment:NSTextAlignmentLeft];
        [self.bonusNameLabel setText:NSLocalizedString(@"баллов",nil)];
        [self.contentView addSubview:self.bonusNameLabel];
        
        //View message
        self.messageView = [[UIView alloc] initWithFrame:CGRectMake(10, self.bonusNameLabel.frame.origin.y + self.bonusNameLabel.frame.size.height + 10, 290, 50)];
        [self.messageView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
        [self.messageView setClipsToBounds:YES];
        [self.messageView.layer setCornerRadius:5.0];
        [self.contentView addSubview:self.messageView];
        
        //label message
        self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, 0, self.messageView.frame.size.width - 6, self.messageView.frame.size.height)];
        [self.messageLabel setNumberOfLines:0];
        [self.messageLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self.messageLabel setBackgroundColor:[UIColor clearColor]];
        self.messageLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:11.0];
        [self.messageLabel setTextColor:[UIColor whiteColor]];
        [self.messageView addSubview:self.messageLabel];
        
        //        self.mainFishkaImageView = [[UIImageView alloc] initWithFrame:CGRectMake(56, -4, 198, 33)];
        //        [self.mainFishkaImageView setImage:[UIImage imageNamed:@"TOS cap.png"]];
        //
        //        [self addSubview:self.mainFishkaImageView];
        
        self.okButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.okButton setFrame:CGRectMake(10, self.messageView.frame.origin.y + self.messageView.frame.size.height + 5, 140, 35)];
        [self.okButton setBackgroundImage:[UIImage imageNamed:@"button_140*35.png"] forState:UIControlStateNormal];
        [self.okButton setTitle:@"OK" forState:UIControlStateNormal];
        [self.okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.okButton.titleLabel.font
        = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
        [self.contentView addSubview:self.okButton];
        
        self.complaint = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.complaint setFrame:CGRectMake(160, self.messageView.frame.origin.y + self.messageView.frame.size.height + 5, 140, 35)];
        [self.complaint setBackgroundImage:[UIImage imageNamed:@"button_140*35.png"] forState:UIControlStateNormal];
        [self.complaint setTitle:NSLocalizedString(@"Отправить жалобу", nil) forState:UIControlStateNormal];
        [self.complaint setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.complaint.titleLabel.font
        = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
        [self.contentView addSubview:self.complaint];
    }
    return self;
}

@end
