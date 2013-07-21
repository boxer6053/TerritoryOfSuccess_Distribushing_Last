//
//  MSBonusSubCatalogViewController.h
//  TerritoryOfSuccess
//
//  Created by Alex on 2/28/13.
//  Copyright (c) 2013 Matrix Soft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSAPI.h"

@interface MSBonusSubCatalogViewController : UITableViewController <WsCompleteDelegate>

@property (strong, nonatomic) IBOutlet UITableView *subCatalogTableView;

- (void)setSubCategories:(NSArray *)subCategoriesList andCategoryId:(int)categoryId;

@end
