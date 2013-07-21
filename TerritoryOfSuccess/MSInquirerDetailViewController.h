//
//  MSInquirerDetailViewController.h
//  TerritoryOfSuccess
//
//  Created by Matrix Soft on 1/28/13.
//  Copyright (c) 2013 Matrix Soft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSAPI.h"

@interface MSInquirerDetailViewController : UIViewController <WsCompleteDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *inquirerTitle;
@property (nonatomic) NSInteger inquirerType;
@property (nonatomic) NSString * itemID;
@property (strong, nonatomic) NSArray *arrayOfProducts;
@property (nonatomic) int count;
@property (strong, nonatomic) NSString *productName;
@property (nonatomic) NSInteger optionForAnswer;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *toStatButton;

@property (nonatomic) NSInteger ownerIndex;

@end

