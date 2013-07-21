#import <UIKit/UIKit.h>
#import "MSAPI.h"

@interface MSCatalogueViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, WsCompleteDelegate>

@property (strong, nonatomic) IBOutlet UISegmentedControl *categoryAndBrandsControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UINavigationItem *catalogueNavigationItem;

- (IBAction)segmentPressed:(id)sender;
@end
