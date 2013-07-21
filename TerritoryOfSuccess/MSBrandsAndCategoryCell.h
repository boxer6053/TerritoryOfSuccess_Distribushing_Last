//
//  MSBrandsAndCategoryCell.h
//  TerritoryOfSuccess
//
//  Created by matrixsoft on 28.01.13.
//  Copyright (c) 2013 Matrix Soft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSBrandsAndCategoryCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *categoryOrBrandImage;
@property (strong, nonatomic) IBOutlet UILabel *categoryOrBrandName;
@property (strong, nonatomic) IBOutlet UILabel *categoryOrBrandAvailable;
@property (strong, nonatomic) IBOutlet UILabel *categoryOrBrandNumber;

@end
