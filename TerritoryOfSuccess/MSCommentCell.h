//
//  MSCommentCell.h
//  TerritoryOfSuccess
//
//  Created by matrixsoft on 19.01.13.
//  Copyright (c) 2013 Matrix Soft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSCommentCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *commentatorName;
@property (strong, nonatomic) IBOutlet UITextView *commentText;
@property (strong, nonatomic) IBOutlet UILabel *commentdate;

@end
