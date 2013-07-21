#import "MSAddingCommentViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface MSAddingCommentViewController ()
@property (nonatomic) int starsCounter;
@property (nonatomic) NSArray *arrayOfStars;
@property (strong, nonatomic) MSAPI *api;
@end

@implementation MSAddingCommentViewController
//@synthesize delegate = _delegate;
@synthesize sentArray = _sentArray;
@synthesize starsCounter = _starsCounter;
@synthesize arrayOfStars = _arrayOfStars;
@synthesize api = _api;


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.starsCounter = 0;
    self.arrayOfStars = [[NSArray alloc] initWithObjects:self.starButton1,self.starButton2,self.starButton3,self.starButton4, self.starButton5, nil];
    
    if ([[UIScreen mainScreen] bounds].size.height == 568)
    {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
    }
    else
    {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
        self.inputText.frame = CGRectMake(self.inputText.frame.origin.x, self.inputText.frame.origin.y - 20, self.inputText.frame.size.width, self.inputText.frame.size.width);
        self.containView.frame = CGRectMake(self.containView.frame.origin.x, self.containView.frame.origin.y, self.containView.frame.size.width, self.containView.frame.size.height - 88);
    }
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],UITextAttributeTextColor, nil]];
    
    self.containView.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1].CGColor;
    self.containView.layer.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.3].CGColor;
    
    self.inputText.returnKeyType = UIReturnKeyDone;
    self.inputText.delegate = self;
    self.inputText.layer.cornerRadius = 10;
    self.inputText.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.inputText.layer.borderWidth = 1.0f;
    self.inputText.layer.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1].CGColor;
    
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPressed:)];
    [self.view addGestureRecognizer:self.tap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)save:(id)sender {
    //self.sentArray = [[NSMutableArray alloc]init];
    [self.api sentCommentWithProductId:12 andText:self.inputText.text];
    //NSString *name = @"Egor";
    //NSString *comment = self.inputText.text;
    //NSNumber *starsNumber = [NSNumber numberWithInt:self.starsCounter];
    //[[self sentArray] addObject:name];
    //[[self sentArray] addObject:comment];
    //[[self sentArray] addObject:starsNumber];
    
    //[self.delegate addNewComment:[self sentArray]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)starButtonPressed:(UIButton *)sender
{
    self.starsCounter = sender.tag;
    
    for (int i = 0; i < self.starsCounter; i++) {
        [[[self arrayOfStars] objectAtIndex:i] setBackgroundImage:[UIImage imageNamed:@"bigStar.png"] forState:UIControlStateNormal];
    }
    for (int j = 4; j >= self.starsCounter; j--) {
        [[[self arrayOfStars] objectAtIndex:j] setBackgroundImage:[UIImage imageNamed:@"bigStarBlack.png"] forState:UIControlStateNormal];
    }
}

#pragma mark Text View
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if([self.inputText.text isEqualToString:@"Напишите, что Вы думаете об этом товаре..."])
    self.inputText.text = @"";
    self.inputText.textColor = [UIColor blackColor];
    return YES;
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if ([self.inputText.text isEqualToString:@""]){
        self.inputText.text = @"Напишите, что Вы думаете об этом товаре...";
        self.inputText.textColor = [UIColor lightGrayColor];
    }
}
// ввод текста комментария
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSCharacterSet *doneButtonCharacterSet = [NSCharacterSet newlineCharacterSet];
    NSRange replacementTextRange = [text rangeOfCharacterFromSet:doneButtonCharacterSet];
    NSUInteger location = replacementTextRange.location;
    
    if (textView.text.length + text.length > 140)
    {
        if (location != NSNotFound)
        {
            [textView resignFirstResponder];
        }
        return NO;
    }
    
    else if (location != NSNotFound)
    {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}
// нажатие в любой точке экрана для отмены ввода комментария
-(void)tapPressed:(UITapGestureRecognizer *)recognizer{
    [self.inputText resignFirstResponder];
}

- (MSAPI *)api
{
    if(!_api){
        _api = [[MSAPI alloc]init];
        [_api setDelegate:self];
    }
    return _api;
}

- (void)finishedWithDictionary:(NSDictionary *)dictionary withTypeRequest:(requestTypes)type
{
    if (type  == kComment)
        NSLog(@"trololo");
}
@end
