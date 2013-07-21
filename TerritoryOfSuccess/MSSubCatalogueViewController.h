#import <UIKit/UIKit.h>
#import "MSAPI.h"
@interface MSSubCatalogueViewController : UITableViewController <UITableViewDataSource,UIScrollViewDelegate, UITableViewDelegate, WsCompleteDelegate>

@property (strong, nonatomic) IBOutlet UITableView *productsTableView;
@property (strong, nonatomic) IBOutlet UINavigationItem *productsNavigationItem;

-(void) sentWithBrandId:(int)brandId withCategoryId:(int)categoryId;
- (void) sentWithBonusCategoryId:(int)categoryId;

@end
