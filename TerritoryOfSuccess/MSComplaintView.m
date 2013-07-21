//
//  MSComplaintView.m
//  TerritoryOfSuccess
//
//  Created by Matrix Soft on 11.02.13.
//  Copyright (c) 2013 Matrix Soft. All rights reserved.
//

#import "MSComplaintView.h"

@interface MSComplaintView()

@property (nonatomic) CGRect selfRect;

@end

@implementation MSComplaintView

@synthesize contentView = _contentView;
@synthesize mainFishkaImageView = _mainFishkaImageView;
@synthesize mainFishkaLabel = _mainFishkaLabel;
@synthesize productLabel = _productLabel;
@synthesize productTextField = _productTextField;
@synthesize codeLabel = _codeLabel;
@synthesize codeTextField = _codeTextField;
@synthesize locationLabel = _locationLabel;
@synthesize locationTextField = _locationTextField;
@synthesize commentTextView = _commentTextView;
@synthesize sendComplaintButton = _sendComplaintButton;
@synthesize cancelButton = _cancelButton;
@synthesize closeButton = _closeButton;
@synthesize productImageButton = _productImageButton;
@synthesize delegate = _delegate;
@synthesize imagePickerController = _imagePickerController;
@synthesize selfRect = _selfRect;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.selfRect = self.frame;
        
        //колір фонової view
        [self setBackgroundColor:[UIColor clearColor]];
        
        //вікно complaint
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 4, self.frame.size.width, self.frame.size.height - 4)];
        [self.contentView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"dialogViewGradient.png"]]];
        [self.contentView.layer setCornerRadius:10.0];
        [self.contentView.layer setBorderColor:[UIColor colorWithWhite:0.5 alpha:1.0].CGColor];
        [self.contentView.layer setBorderWidth:2.0];
        [self.contentView setClipsToBounds:YES];
        [self addSubview:self.contentView];
        
        //малюнок TOS
        self.mainFishkaImageView = [[UIImageView alloc] initWithFrame:CGRectMake(56, 0, 198, 33)];
        [self.mainFishkaImageView setImage:[UIImage imageNamed:@"TOS cap.png"]];
        [self addSubview:self.mainFishkaImageView];
        
        //мітка в TOS
        self.mainFishkaLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 178, 20)];
        self.mainFishkaLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0];
        [self.mainFishkaLabel setTextColor:[UIColor whiteColor]];
        [self.mainFishkaLabel setBackgroundColor:[UIColor clearColor]];
        [self.mainFishkaLabel setTextAlignment:NSTextAlignmentCenter];
        [self.mainFishkaLabel setText:NSLocalizedString(@"ComplaintSendingKey",nil)];
        [self.mainFishkaImageView addSubview:self.mainFishkaLabel];
        
        //кнопка Close
        self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.closeButton setFrame:CGRectMake(287, 8, 15, 15)];
        [self.closeButton setBackgroundImage:[UIImage imageNamed:@"closeIcon.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.closeButton];
                
        //productImageButton
        self.productImageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.productImageButton setFrame:CGRectMake(10, 40, 100, 100)];
        [self.productImageButton setClipsToBounds:YES];
        [self.productImageButton.layer setCornerRadius:10.0];
        [self.productImageButton.layer setBorderColor:[UIColor colorWithWhite:0.5 alpha:1.0].CGColor];
        [self.productImageButton.layer setBorderWidth:1.0];
        [self.productImageButton setBackgroundColor:[UIColor whiteColor]];
        [self.productImageButton setBackgroundImage:[UIImage imageNamed:@"photoPlaceholder1.png"] forState:UIControlStateNormal];
        [self.productImageButton addTarget:self action:@selector(takeProductPhoto) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.productImageButton];
        
        //textField назви продукта
        self.productTextField = [[UITextField alloc] initWithFrame:CGRectMake(120, self.productImageButton.frame.origin.y, self.frame.size.width - 120 - 10, 30)];
        [self.productTextField setBorderStyle:UITextBorderStyleRoundedRect];
        self.productTextField.font = [UIFont fontWithName:@"Helvetica" size:12.0];
        [self.productTextField setContentVerticalAlignment:UIControlContentHorizontalAlignmentCenter];
        [self.productTextField setPlaceholder:NSLocalizedString(@"ProductNameKey",nil)];
        [self.productTextField setTag:1];
        [self.contentView addSubview:self.productTextField];
                
        //textField коду
        self.codeTextField = [[UITextField alloc] initWithFrame:CGRectMake(120, self.productTextField.frame.origin.y + self.productTextField.frame.size.height + 5, self.frame.size.width - 120 - 10, 30)];
        [self.codeTextField setBorderStyle:UITextBorderStyleRoundedRect];
        self.codeTextField.font = [UIFont fontWithName:@"Helvetica" size:12.0];
        [self.codeTextField setContentVerticalAlignment:UIControlContentHorizontalAlignmentCenter];
        [self.codeTextField setPlaceholder:NSLocalizedString(@"CodeOnThePackageKey",nil)];
        [self.codeTextField setTag:2];
        [self.contentView addSubview:self.codeTextField];
                
        //textField location
        self.locationTextField = [[UITextField alloc] initWithFrame:CGRectMake(120, self.codeTextField.frame.origin.y + self.codeTextField.frame.size.height + 5, self.frame.size.width - 120 - 10, 30)];
        [self.locationTextField setBorderStyle:UITextBorderStyleRoundedRect];
        self.locationTextField.font = [UIFont fontWithName:@"Helvetica" size:12.0];
        [self.locationTextField setContentVerticalAlignment:UIControlContentHorizontalAlignmentCenter];
        [self.locationTextField setPlaceholder:NSLocalizedString(@"PurhasePlaceKey",nil)];
        [self.locationTextField setTag:3];
        [self.contentView addSubview:self.locationTextField];
        
        //comment textView
        self.commentTextView = [[UITextView alloc] initWithFrame:CGRectMake(self.productImageButton.frame.origin.x, self.productImageButton.frame.origin.y + self.productImageButton.frame.size.height + 10, 290, 100)];
        [self.commentTextView.layer setCornerRadius:10.0];
        [self.commentTextView.layer setBorderWidth:1.0];
        [self.commentTextView.layer setBorderColor:[[UIColor colorWithWhite:0.5 alpha:1.0] CGColor]];
        [self.commentTextView setText:NSLocalizedString(@"WriteACommentForComplaintKey",nil)];
        [self.commentTextView setTextColor:[UIColor lightGrayColor]];
//        [self.commentTextView setDelegate:self];
        self.commentTextView.returnKeyType = UIReturnKeyDone;
        [self.contentView addSubview:self.commentTextView];
                
        //send button
        self.sendComplaintButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.sendComplaintButton setFrame:CGRectMake(10, self.commentTextView.frame.origin.y + self.commentTextView.frame.size.height + 10, 140, 35)];
        [self.sendComplaintButton setBackgroundImage:[UIImage imageNamed:@"button_140*35.png"] forState:UIControlStateNormal];
        [self.sendComplaintButton setTitle:NSLocalizedString(@"SendKey", nil) forState:UIControlStateNormal];
        [self.sendComplaintButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.sendComplaintButton.titleLabel.font
        = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
        [self.contentView addSubview:self.sendComplaintButton];
        
        //cancel button
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.cancelButton setFrame:CGRectMake(160, self.commentTextView.frame.origin.y + self.commentTextView.frame.size.height + 10, 140, 35)];
        [self.cancelButton setBackgroundImage:[UIImage imageNamed:@"button_140*35.png"] forState:UIControlStateNormal];
        [self.cancelButton setTitle:NSLocalizedString(@"Отмена", nil) forState:UIControlStateNormal];
        [self.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.cancelButton.titleLabel.font
        = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
        [self.contentView addSubview:self.cancelButton];
    }
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
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

//зробити фто продукта
- (void)takeProductPhoto
{
    //перевірка наявності камери на девайсі
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        //якщо є
        self.imagePickerController = [[UIImagePickerController alloc] init];
        [self.imagePickerController setDelegate:self];
        [self.imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self.imagePickerController setAllowsEditing:YES];
        
        [self.delegate startCameraWithImagePickerController:self.imagePickerController];
        
    }
    else
    {
        //якщо нема
        UIAlertView *cameraNotAvailableMessage = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Ошибка камеры",nil) message:NSLocalizedString(@"Камера не доступна",nil) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [cameraNotAvailableMessage show];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *editedProductImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    NSLog(@"Picture width: %f", editedProductImage.size.width);
    NSLog(@"Picture hight: %f", editedProductImage.size.height);
    
    CGSize sizeToScale;
    sizeToScale.width = 320.0;
    sizeToScale.height = 320.0;
    
    //зміна розміру фото
    editedProductImage = [self scalingImage:editedProductImage toSize:sizeToScale];
    
    NSLog(@"Picture width: %f", editedProductImage.size.width);
    NSLog(@"Picture hight: %f", editedProductImage.size.height);
    
    //стискання фото
    NSData *data = UIImageJPEGRepresentation(editedProductImage, 0.5);
    UIImage *compressedImage = [UIImage imageWithData:data];
            
    [self.productImageButton setBackgroundImage:compressedImage forState:UIControlStateNormal];
    
    [self.delegate closeCameraWithImagePickerController:self.imagePickerController];
}

static inline double radians (double degrees) {return degrees * M_PI/180;}

//зміна розміру фото
- (UIImage *)scalingImage:(UIImage *)image toSize:(CGSize)targetSize
{
    CGFloat targetWidth = targetSize.width;
	CGFloat targetHeight = targetSize.height;
    
    CGImageRef imageRef = [image CGImage];
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
    
    if (bitmapInfo == kCGImageAlphaNone)
    {
        bitmapInfo = kCGImageAlphaNoneSkipLast;
    }
    
    CGContextRef bitmap;
    
    if (image.imageOrientation == UIImageOrientationUp || image.imageOrientation == UIImageOrientationDown)
    {
		bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
        
	}
    else
    {
		bitmap = CGBitmapContextCreate(NULL, targetHeight, targetWidth, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
        
	}
    
    if (image.imageOrientation == UIImageOrientationLeft) {
		CGContextRotateCTM (bitmap, radians(90));
		CGContextTranslateCTM (bitmap, 0, -targetHeight);
        
	} else if (image.imageOrientation == UIImageOrientationRight) {
		CGContextRotateCTM (bitmap, radians(-90));
		CGContextTranslateCTM (bitmap, -targetWidth, 0);
        
	} else if (image.imageOrientation == UIImageOrientationUp) {
		// NOTHING
	} else if (image.imageOrientation == UIImageOrientationDown) {
		CGContextTranslateCTM (bitmap, targetWidth, targetHeight);
		CGContextRotateCTM (bitmap, radians(-180.));
	}
    
    CGContextDrawImage(bitmap, CGRectMake(0, 0, targetWidth, targetHeight), imageRef);
	CGImageRef ref = CGBitmapContextCreateImage(bitmap);
	UIImage *newImage = [UIImage imageWithCGImage:ref];
        
	CGContextRelease(bitmap);
	CGImageRelease(ref);
    
	return newImage;
    
}

@end
