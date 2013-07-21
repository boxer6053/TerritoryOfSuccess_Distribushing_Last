#import "MSCommentsViewController.h"
#import "MSCommentCell.h"
#import <QuartzCore/QuartzCore.h>
#import "MSAddCommentView.h"
#import "SVProgressHUD.h"

@interface MSCommentsViewController ()
{
    BOOL isFromBonus;
}

@property (nonatomic, strong) MSAddCommentView *addCommentView;
@property (nonatomic) int prodId;
@property (nonatomic) MSAPI *api;
@property (strong, nonatomic) NSMutableArray *commentsArray;
@property (strong, nonatomic) NSArray *lastloadedCommentsArray;
@property (nonatomic) int commentsCounter;
@property (nonatomic) int tempCommentsCounter;
@property (nonatomic, strong) UIButton *footerButton;
@property (nonatomic) BOOL isFirstTime;
@property (nonatomic) BOOL insertedOperationFinishedTheyWork;
@property (strong, nonatomic) MSLogInView *loginView;
@property (strong, nonatomic) UIActivityIndicatorView *indicator;
@end

@implementation MSCommentsViewController
@synthesize commentsArray = _commentsArray;
@synthesize commentNew = _commentNew;
@synthesize addCommentView = _addCommentView;
@synthesize prodId = _prodId;
@synthesize api = _api;
@synthesize footerButton = _footerButton;
@synthesize lastloadedCommentsArray = _lastloadedCommentsArray;
@synthesize isFirstTime = _isFirstTime;
@synthesize tempCommentsCounter = _tempCommentsCounter;
@synthesize insertedOperationFinishedTheyWork = _insertedOperationFinishedTheyWork;
@synthesize loginView = _loginView;
@synthesize indicator = _indicator;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.commentsNavigationItem setTitle:NSLocalizedString(@"CommentsNavItemKey", nil)];
    [[self commentTableView] setBackgroundView:[[UIImageView alloc]
                                                initWithImage:[UIImage imageNamed:@"bg.png"]]];

    self.footerButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.commentTableView.frame.size.width, 35)];
    [[self commentTableView].tableFooterView setHidden:YES];
    [[self commentTableView].tableFooterView setUserInteractionEnabled:NO];
    self.footerButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
    [self.footerButton setTitleColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4] forState:UIControlStateNormal];
    [self commentTableView].tableFooterView = self.footerButton;
    [SVProgressHUD showWithStatus:NSLocalizedString(@"DownloadCommentsKey",nil)];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) moreComments
{
    if (self.commentsArray.count < self.commentsCounter)
    {
        self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.indicator.hidesWhenStopped = YES;
        self.commentTableView.tableFooterView = self.indicator;
        [self.indicator startAnimating];
        
        if (isFromBonus == YES)
            [self.api getBonusCommentsWithProductId:self.prodId andOffset:self.commentsArray.count];
        else
            [self.api getCommentsWithProductId:self.prodId andOffset:self.commentsArray.count];
    }
    else
    {
        [self commentTableView].tableFooterView = self.footerButton;
        [self.footerButton setTitle:NSLocalizedString(@"AllCommentsDownloadedKey",nil) forState:UIControlStateNormal];
        [[self commentTableView].tableFooterView setHidden:NO];

    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.insertedOperationFinishedTheyWork)
    {
        if (self.commentsCounter > 20)
        {
            if (self.commentTableView.contentOffset.y + 455 > self.commentTableView.contentSize.height)
            {
                [self moreComments];
                self.insertedOperationFinishedTheyWork = NO;
            }
        }
    }
}

#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellText = [NSString stringWithString:[[[self commentsArray] objectAtIndex:indexPath.row] valueForKey:@"text"]];
    
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:14.0];
    CGSize constraintSize = CGSizeMake(320, CGFLOAT_MAX);
    CGSize textViewSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize];
    
    return textViewSize.height + 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self tempCommentsCounter];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"commentsIdentifier";
    MSCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[MSCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSString *value = [[[self commentsArray] objectAtIndex:indexPath.row] valueForKey:@"name"];
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    if ([[value stringByTrimmingCharactersInSet:set] length] == 0)
    {
        cell.commentatorName.text = @"Noname";
    }
    else cell.commentatorName.text = [[[self commentsArray] objectAtIndex:indexPath.row] valueForKey:@"name"];
    
    [cell.commentText setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0]];
    cell.commentText.text = [[[self commentsArray] objectAtIndex:indexPath.row] valueForKey:@"text"];
    
    cell.commentdate.text = [[[self commentsArray] objectAtIndex:indexPath.row] valueForKey:@"date"];
    
    return cell;
}

-(void)sentProductId:(int)sentProductId isFromBonus:(BOOL)bonus
{
    self.prodId = sentProductId;
    self.isFirstTime = YES;
    isFromBonus = bonus;
    
    if (isFromBonus == YES)
        [self.api getBonusCommentsWithProductId:self.prodId andOffset:0];
    else
        [self.api getCommentsWithProductId:self.prodId andOffset:0];
}

- (IBAction)addComment:(id)sender
{
    if(![[NSUserDefaults standardUserDefaults] valueForKey:@"authorization_Token"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Ошибка", nil) message:NSLocalizedString(@"NeedToLoginKey", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Отмена", nil) otherButtonTitles:@"OK", nil];
        [alertView show];
    } else if(!self.addCommentView)
    {
        self.commentTableView.scrollEnabled = NO;
        self.addCommentView = [[MSAddCommentView alloc] initCommentAdder];
        [self.view.window addSubview:self.addCommentView];
        if (isFromBonus == YES)
            [self.addCommentView setProductId:self.prodId isFromBonus:YES];
        else
            [self.addCommentView setProductId:self.prodId isFromBonus:NO];
        [[self addCommentView] attachPopUpAnimationForView:self.addCommentView.containerView];
        self.addCommentView.delegate = self;
    }
}

- (void)closeAddingCommentSubviewWithAdditionalActions
{
    self.commentTableView.scrollEnabled = YES;
    self.addCommentView = nil;
    [self.commentTableView reloadData];
}

#pragma mark - Login popUp
- (void)viewDidDisappear:(BOOL)animated  {
    if(self.loginView)
    {
        [self.loginView removeFromSuperview];
    }
}

- (void)dismissPopView:(BOOL)result
{
    if(result)
    {
        [self viewDidAppear:YES];
    }
    self.loginView = nil;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        self.loginView = [[MSLogInView alloc]initWithOrigin:CGPointMake(25, self.view.frame.size.height/2 - 70)];
        [self.view.window addSubview:self.loginView];
        [self.loginView blackOutOfBackground];
        [self.loginView attachPopUpAnimationForView:self.loginView.loginView];
        self.loginView.delegate = self;
    }
}

#pragma mark Web Methods
- (MSAPI *) api
{
    if(!_api)
    {
        _api = [[MSAPI alloc]init];
        _api.delegate = self;
    }
    return _api;
}

-(void)finishedWithDictionary:(NSDictionary *)dictionary withTypeRequest:(requestTypes)type
{
    if ((type == kComments) || (type == kBonusComments))
    {
        if (self.isFirstTime)
        {
            self.commentsArray = [[dictionary valueForKey:@"list"] mutableCopy];
            self.tempCommentsCounter = self.commentsArray.count;
            self.commentsCounter = [[dictionary valueForKey:@"count"]integerValue];
            [[self commentTableView] reloadData];
            self.isFirstTime = NO;
        }
        else
        {
            [self.indicator stopAnimating];
            [self.commentsArray addObjectsFromArray:[dictionary valueForKey:@"list"]];
            self.lastloadedCommentsArray = [dictionary valueForKey:@"list"];
            for (int i  = 0; i < self.lastloadedCommentsArray.count; i++)
            {
                NSArray *insertIndexPath = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:self.tempCommentsCounter++  inSection:0]];
                [self.commentTableView insertRowsAtIndexPaths: insertIndexPath withRowAnimation:NO];
            }
        }
        self.insertedOperationFinishedTheyWork = YES;
    }
}
- (void)viewDidUnload {
    [self setCommentsNavigationItem:nil];
    [super viewDidUnload];
}
@end
