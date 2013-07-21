//
//  MSAPI.m
//  TerritoryOfSuccess
//
//  Created by Matrix Soft on 21.01.13.
//  Copyright (c) 2013 Matrix Soft. All rights reserved.
//

#import "MSAPI.h"
#import "checkConnection.h"
#import "SVProgressHUD.h"


@implementation MSAPI

@synthesize url = _url;
@synthesize request =_request;
@synthesize connection = _connection;
@synthesize params = _params;
@synthesize receivedData = _receivedData;
@synthesize delegate = _delegate;
@synthesize checkRequest = _checkRequest;
@synthesize connectionToInfoMapping = _connectionToInfoMapping;
@synthesize connectionInfo = _connectionInfo;

- (CFMutableDictionaryRef)connectionToInfoMapping
{
    if (!_connectionToInfoMapping) {
        _connectionToInfoMapping = CFDictionaryCreateMutable(kCFAllocatorDefault, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    }
    
    return _connectionToInfoMapping;
}

- (void)sendComplaintForProduct:(NSString *)product withCode:(NSString *)code withLocation:(NSString *)location withComment:(NSString *)comment withImage:(UIImage *)image withImageName:(NSString *)imageName
{    
    self.url = [NSURL URLWithString:@"http://id-bonus.com/api/app/complaint"];
    
    self.checkRequest = kComplaint;
        
    //створюемо запит
    self.request = [NSMutableURLRequest requestWithURL:self.url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    
    NSString *boundary = @"MY_BOUNDARY_STRING";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    
    [self.request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"photo\"; filename=\"%@.jpg\"\r\n", imageName] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"product\"\r\n\r\n%@", product] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"location\"\r\n\r\n%@", location] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"comment\"\r\n\r\n%@", comment] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"code\"\r\n\r\n%@", code] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"lang\"\r\n\r\n%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"currentLanguage"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"token\"\r\n\r\n%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"authorization_Token"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //вказуэм тіло запиту
    [self.request setHTTPBody:body];
    
    //вказуэм протокол доступу
    [self.request setHTTPMethod:@"POST"];
        
    [self connectionVerification];
}

-(void)sendCustomProductWithImage:(UIImage *)image withName:(NSString *)name withImageName:(NSString *)imageName
 withParentID:(NSInteger)parentID{
    self.url = [NSURL URLWithString:@"http://id-bonus.com/api/app/question/add"];
    
    self.checkRequest = kCustomProduct;
    
    //створюемо запит
    self.request = [NSMutableURLRequest requestWithURL:self.url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    
    NSString *boundary = @"MY_BOUNDARY_STRING";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    
    
    //NSData *parentData = [NSData dataWithBytes: &parentID length: sizeof(parentID)];
    [self.request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"foto\"; filename=\"%@.jpg\"\r\n", imageName] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    
     [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
     [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"parent_id\"\r\n\r\n%d", parentID] dataUsingEncoding:NSUTF8StringEncoding]];

    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"title\"\r\n\r\n%@", name] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"lang\"\r\n\r\n%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"currentLanguage"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"token\"\r\n\r\n%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"authorization_Token"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //вказуэм тіло запиту
    [self.request setHTTPBody:body];
    
    //вказуэм протокол доступу
    [self.request setHTTPMethod:@"POST"];
    
    [self connectionVerification];
}

- (void)checkCode:(NSString *)code
{
    self.url = [NSURL URLWithString:@"http://id-bonus.com/api/app/code"];
    
    self.checkRequest = kCode;
    
    //створюемо запит
    self.request = [NSMutableURLRequest requestWithURL:self.url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    
    //вказуэм протокол доступу
    [self.request setHTTPMethod:@"POST"];
    
    //вказуэм параметри POST запиту
    self.params = [NSMutableString stringWithFormat:@"code=%@", code];
    [self.params appendFormat:@"&lang=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"currentLanguage"]];
    [self.params appendFormat:@"&token=%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"authorization_Token"]];
    
    //вказуэм тіло запиту
    [self.request setHTTPBody:[self.params dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self connectionVerification];
}

- (void)getFiveNewsWithOffset:(int)offset
{
    self.url = [NSURL URLWithString:@"http://id-bonus.com/api/app/news"];
    
    self.checkRequest = kNews;
    
    //створюемо запит
    self.request = [NSMutableURLRequest requestWithURL:self.url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    
    //вказуэм протокол доступу
    [self.request setHTTPMethod:@"POST"];
    
    self.params = [NSMutableString stringWithFormat:@"offset=%d", offset];
    [self.params appendFormat:@"&lang=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"currentLanguage"]];
    
    [self.request setHTTPBody:[self.params dataUsingEncoding:NSUTF8StringEncoding]];

    [self connectionVerification];
}

- (void)getTopNews
{
    self.url = [NSURL URLWithString:@"http://id-bonus.com/api/app/news/top"];
    
    self.checkRequest = kNews;
    
    //створюемо запит
    self.request = [NSMutableURLRequest requestWithURL:self.url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    
    //вказуэм протокол доступу
    [self.request setHTTPMethod:@"POST"];
    
    [self.params appendFormat:@"&lang=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"currentLanguage"]];
    
    [self.request setHTTPBody:[self.params dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self connectionVerification];
}

- (void)getNewsWithId:(NSString *)newsId
{
    self.url = [NSURL URLWithString:@"http://id-bonus.com/api/app/news"];
    
    self.checkRequest = kNewsWithId;
    
    //створюемо запит
    self.request = [NSMutableURLRequest requestWithURL:self.url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    
    //вказуэм протокол доступу
    [self.request setHTTPMethod:@"POST"];
    
    //вказуэм параметри POST запиту
    self.params = [NSMutableString stringWithFormat:@"news_id=%@", newsId];
    [self.params appendFormat:@"&lang=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"currentLanguage"]];
    
    //вказуэм тіло запиту
    [self.request setHTTPBody:[self.params dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self connectionVerification];
}

- (void)getFiveBrandsWithOffset:(int)offset
{
    self.url = [NSURL URLWithString:@"http://id-bonus.com/api/app/brands"];
    self.checkRequest = kBrands;
    
    self.request  = [NSMutableURLRequest requestWithURL:self.url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    [self.request setHTTPMethod:@"POST"];
    
    self.params = [NSMutableString stringWithFormat:@"offset=%d",offset];
    [self.params appendFormat:@"&lang=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"currentLanguage"]];
    [self.request setHTTPBody:[self.params dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self connectionVerification];
}

- (void)getQuestionsWithParentID:(int)parentId{
    self.url = [NSURL URLWithString:@"http://id-bonus.com/api/app/subjects"];
    self.checkRequest = kQuestCateg;
    
    self.request  = [NSMutableURLRequest requestWithURL:self.url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    [self.request setHTTPMethod:@"POST"];
    
    self.params = [NSMutableString stringWithFormat:@"parent_id=%d",parentId];
    [self.request setHTTPBody:[self.params dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self connectionVerification];
}

- (void)getCategories
{
    self.url = [NSURL URLWithString:@"http://id-bonus.com/api/app/categories"];
    self.checkRequest = kCategories;
    
    self.request  = [NSMutableURLRequest requestWithURL:self.url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    [self.request setHTTPMethod:@"POST"];
    self.params = [NSString stringWithFormat:@"&lang=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"currentLanguage"]];
    [self.request setHTTPBody:[self.params dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self connectionVerification];
}

- (void)getBonusCategories
{
    self.url = [NSURL URLWithString:@"http://id-bonus.com/api/app/bonus"];
    self.checkRequest = kBonusCategories;
    
    self.request  = [NSMutableURLRequest requestWithURL:self.url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    [self.request setHTTPMethod:@"POST"];
    self.params = [NSString stringWithFormat:@"lang=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"currentLanguage"]];
    [self.request setHTTPBody:[self.params dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self connectionVerification];
}

- (void)getBonusSubCategories:(int)categoryId withOffset:(int)offset
{
    self.url = [NSURL URLWithString:@"http://id-bonus.com/api/app/bonus"];
    self.checkRequest = kBonusSubCategories;
    
    self.request  = [NSMutableURLRequest requestWithURL:self.url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    [self.request setHTTPMethod:@"POST"];
    self.params = [NSMutableString stringWithFormat:@"lang=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"currentLanguage"]];
    [self.params appendFormat:@"&category_id=%d",categoryId];
    [self.params appendFormat:@"&offset=%d",offset];
    [self.request setHTTPBody:[self.params dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self connectionVerification];
}

- (void)getBonusProduct:(int)productId
{
    self.url = [NSURL URLWithString:@"http://id-bonus.com/api/app/bonus"];
    self.checkRequest = kBonusSubCategories;
    
    self.request  = [NSMutableURLRequest requestWithURL:self.url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    [self.request setHTTPMethod:@"POST"];
    self.params = [NSMutableString stringWithFormat:@"lang=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"currentLanguage"]];
    [self.params appendFormat:@"&product_id=%d",productId];
    [self.request setHTTPBody:[self.params dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self connectionVerification];
}

- (void)getProductsWithOffset:(int)offset withBrandId:(int)brandId withCategoryId:(int)categoryId{
    self.url = [NSURL URLWithString:@"http://id-bonus.com/api/app/catalog"];
    self.checkRequest = kCatalog;
    
    self.request = [NSMutableURLRequest requestWithURL:self.url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    [self.request setHTTPMethod:@"POST"];
    
    self.params = [NSMutableString stringWithFormat:@"offset=%d",offset];
    if (brandId == 0){
        [self.params appendFormat:@"&category_id=%d",categoryId];
    } else if (categoryId == 0){
        [self.params appendFormat:@"&brand_id=%d",brandId];
    }
    [self.params appendFormat:@"&lang=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"currentLanguage"]];
    [self.request setHTTPBody:[self.params dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self connectionVerification];

}

- (void)sentCommentWithProductId:(int)productId andText:(NSString *)text
{
    self.url = [NSURL URLWithString:@"http://id-bonus.com/api/app/catalog/comment"];
    self.checkRequest = kComment;
    
    self.request  = [NSMutableURLRequest requestWithURL:self.url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    [self.request setHTTPMethod:@"POST"];
    self.params = [NSMutableString stringWithFormat:@"product_id=%d",productId];
    [self.params appendFormat:@"&text=%@",text];
    [[self params]appendFormat:@"&lang=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"currentLanguage"]];
    [[self params] appendFormat:@"&token=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"authorization_Token"]];
    [self.request setHTTPBody:[self.params dataUsingEncoding:NSUTF8StringEncoding]];
    [self connectionVerification];
}

- (void)getCommentsWithProductId:(int)productId andOffset:(int)offset
{
    self.url = [NSURL URLWithString:@"http://id-bonus.com/api/app/catalog/comments"];
    self.checkRequest = kComments;
    
    self.request  = [NSMutableURLRequest requestWithURL:self.url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    [self.request setHTTPMethod:@"POST"];
    self.params = [NSMutableString stringWithFormat:@"product_id=%d",productId];
    [self.params appendFormat:@"&offset=%d",offset];
    [[self params]appendFormat:@"&lang=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"currentLanguage"]];
    //[[self params] appendFormat:@"&token=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"authorization_Token"]];
    [self.request setHTTPBody:[self.params dataUsingEncoding:NSUTF8StringEncoding]];
    [self connectionVerification];
}

- (void)sentRate:(int)rate withProductId:(int)productId
{
    self.url = [NSURL URLWithString:@"http://id-bonus.com/api/app/catalog/rate"];
    self.checkRequest = kRate;
    
    self.request  = [NSMutableURLRequest requestWithURL:self.url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    [self.request setHTTPMethod:@"POST"];
    self.params = [NSMutableString stringWithFormat:@"product_id=%d",productId];
    [self.params appendFormat:@"&rate=%d",rate];
    [[self params]appendFormat:@"&lang=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"currentLanguage"]];
    [[self params] appendFormat:@"&token=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"authorization_Token"]];
    [self.request setHTTPBody:[self.params dataUsingEncoding:NSUTF8StringEncoding]];
    [self connectionVerification];
}

- (void)recommendWithProductId:(int)productId
{
    self.url = [NSURL URLWithString:@"http://id-bonus.com/api/app/catalog/recomend"];
    self.checkRequest = kRecommend;
    
    self.request  = [NSMutableURLRequest requestWithURL:self.url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    [self.request setHTTPMethod:@"POST"];
    self.params = [NSMutableString stringWithFormat:@"product_id=%d",productId];
    [[self params]appendFormat:@"&lang=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"currentLanguage"]];
    [[self params] appendFormat:@"&token=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"authorization_Token"]];
    [self.request setHTTPBody:[self.params dataUsingEncoding:NSUTF8StringEncoding]];
    [self connectionVerification];
}

- (void)logInWithMail:(NSString *)email Password:(NSString *)password
{
    self.url = [NSURL URLWithString:@"http://id-bonus.com/api/app/auth"];
    
    self.checkRequest = kAuth;
    
    //створюемо запит
    self.request = [NSMutableURLRequest requestWithURL:self.url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    
    //вказуэм протокол доступу
    [self.request setHTTPMethod:@"POST"];
    
    self.params = [NSMutableString stringWithFormat:@"email=%@", email];
    [self.params appendFormat:@"&password=%@",password];

    [self.request setHTTPBody:[self.params dataUsingEncoding:NSUTF8StringEncoding]];

    
    [self connectionVerification];
}

- (void)getLastQuestions{
    self.url = [NSURL URLWithString:@"http://id-bonus.com/api/app/question/list"];
    self.checkRequest = kLastQuest;
    
    self.request  = [NSMutableURLRequest requestWithURL:self.url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    [self.request setHTTPMethod:@"POST"];
    
    self.params = [NSMutableString stringWithFormat:@"&lang=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"currentLanguage"]];
    //[self.params appendFormat:@"&lang=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"currentLanguage"]];
    [self.params appendFormat:@"&token=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"authorization_Token"]];
    [self.request setHTTPBody:[self.params dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"Body %@",self.params);
    if (checkConnection.hasConnectivity) {
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self];
        
        if(connection){
            self.receivedData = [[NSMutableData alloc]init];
            
            CFDictionaryAddValue(self.connectionToInfoMapping, CFBridgingRetain(connection), CFBridgingRetain([NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:self.checkRequest] forKey:@"requestType"]));
        }else{
            UIAlertView *failmessage = [[UIAlertView alloc] initWithTitle:@"URL Connection" message:@"Not seccess URL Connection" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [failmessage show];
        }
    }else{
        UIAlertView *failmessage = [[UIAlertView alloc] initWithTitle:@"Internet Connection" message:@"Not seccess Internet Connection" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [failmessage show];
    }
}

-(void)createQuestionWithItems:(NSMutableString *)string{
    self.url = [NSURL URLWithString:@"http://id-bonus.com/api/app/question/create"];
    self.checkRequest = kCreateQuest;
    
    self.request  = [NSMutableURLRequest requestWithURL:self.url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    [self.request setHTTPMethod:@"POST"];
    
    self.params = [NSMutableString stringWithString:string];
    [self.params appendFormat:@"&lang=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"currentLanguage"]];
    [self.params appendFormat:@"&token=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"authorization_Token"]];
    //[self.params appendFormat:@"&items=%@", @"(5927)"];
    [self.request setHTTPBody:[self.params dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"Body %@",self.params);
    if (checkConnection.hasConnectivity) {
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self];
        
        if(connection){
            self.receivedData = [[NSMutableData alloc]init];
            
            CFDictionaryAddValue(self.connectionToInfoMapping, CFBridgingRetain(connection), CFBridgingRetain([NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:self.checkRequest] forKey:@"requestType"]));
        }else{
            UIAlertView *failmessage = [[UIAlertView alloc] initWithTitle:@"URL Connection" message:@"Not seccess URL Connection" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [failmessage show];
        }
    }else{
        UIAlertView *failmessage = [[UIAlertView alloc] initWithTitle:@"Internet Connection" message:@"Not seccess Internet Connection" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [failmessage show];
    }
    
    
}

- (void)getMyQuestionsWithOffset:(int)offset
{
    self.url = [NSURL URLWithString:@"http://id-bonus.com/api/app/question/mylist"];
    
    self.checkRequest = kMyQuestions;
    
    //створюемо запит
    self.request = [NSMutableURLRequest requestWithURL:self.url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    
    //вказуэм протокол доступу
    [self.request setHTTPMethod:@"POST"];
    
    self.params = [NSMutableString stringWithFormat:@"offset=%d", offset];
    [self.params appendFormat:@"&lang=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"currentLanguage"]];
    [self.params appendFormat:@"&token=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"authorization_Token"]];
    NSLog(@"Body %@",self.params);
    
    [self.request setHTTPBody:[self.params dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    //перевірка наявності інету
    if (checkConnection.hasConnectivity) {
        //створюєм з'єднання і начинаєм загрузку
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self];
        //перевірка з'єднання
        if (connection) {
            NSLog(@"З'єднання почалось");
            self.receivedData = [[NSMutableData alloc] init];
            
            CFDictionaryAddValue(self.connectionToInfoMapping, CFBridgingRetain(connection), CFBridgingRetain([NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:self.checkRequest] forKey:@"requestType"]));
        }
        else
        {
            //якщо з'єднання нема
            // Inform the user that the connection failed.
            NSLog(@"Помилка з'єднання");
            UIAlertView *connectFailMessage = [[UIAlertView alloc] initWithTitle:@"URL Connection"
                                                                         message:@"Not success URL connection"
                                                                        delegate:self
                                                               cancelButtonTitle:@"Ok"
                                                               otherButtonTitles:nil];
            [connectFailMessage show];
        }
    }
    else
    {
        //якщо інету нема
        UIAlertView *connectFailMessage = [[UIAlertView alloc] initWithTitle:@"Internet Connection"
                                                                     message:@"Not success Internet connection"
                                                                    delegate:self
                                                           cancelButtonTitle:@"Ok"
                                                           otherButtonTitles:nil];
        [connectFailMessage show];
    }
}
- (void)getDetailQuestionWithID:(NSInteger)questionId
{
    self.url = [NSURL URLWithString:@"http://id-bonus.com/api/app/question/view"];
    
    self.checkRequest = kQuestDetail;
    
    //створюемо запит
    self.request = [NSMutableURLRequest requestWithURL:self.url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    
    //вказуэм протокол доступу
    [self.request setHTTPMethod:@"POST"];
    
    self.params = [NSMutableString stringWithFormat:@"item_id=%d", questionId];
    [self.params appendFormat:@"&lang=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"currentLanguage"]];
    [self.params appendFormat:@"&token=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"authorization_Token"]];
    NSLog(@"Body %@",self.params);
    
    [self.request setHTTPBody:[self.params dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    //перевірка наявності інету
    if (checkConnection.hasConnectivity) {
        //створюєм з'єднання і начинаєм загрузку
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self];
        //перевірка з'єднання
        if (connection) {
            NSLog(@"З'єднання почалось");
            self.receivedData = [[NSMutableData alloc] init];
            
            CFDictionaryAddValue(self.connectionToInfoMapping, CFBridgingRetain(connection), CFBridgingRetain([NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:self.checkRequest] forKey:@"requestType"]));
        }
        else
        {
            //якщо з'єднання нема
            // Inform the user that the connection failed.
            NSLog(@"Помилка з'єднання");
            UIAlertView *connectFailMessage = [[UIAlertView alloc] initWithTitle:@"URL Connection"
                                                                         message:@"Not success URL connection"
                                                                        delegate:self
                                                               cancelButtonTitle:@"Ok"
                                                               otherButtonTitles:nil];
            [connectFailMessage show];
        }
    }
    else
    {
        //якщо інету нема
        UIAlertView *connectFailMessage = [[UIAlertView alloc] initWithTitle:@"Internet Connection"
                                                                     message:@"Not success Internet connection"
                                                                    delegate:self
                                                           cancelButtonTitle:@"Ok"
                                                           otherButtonTitles:nil];
        [connectFailMessage show];
    }
}

- (void)getStatisticQuestionWithID:(NSInteger)questionId
{
    self.url = [NSURL URLWithString:@"http://id-bonus.com/api/app/question/stat"];
    
    self.checkRequest = kQuestStat;
    
    //створюемо запит
    self.request = [NSMutableURLRequest requestWithURL:self.url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    
    //вказуэм протокол доступу
    [self.request setHTTPMethod:@"POST"];
    
    self.params = [NSMutableString stringWithFormat:@"item_id=%d", questionId];
    [self.params appendFormat:@"&lang=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"currentLanguage"]];
    [self.params appendFormat:@"&token=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"authorization_Token"]];
    NSLog(@"Body %@",self.params);
    
    [self.request setHTTPBody:[self.params dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    //перевірка наявності інету
    if (checkConnection.hasConnectivity) {
        //створюєм з'єднання і начинаєм загрузку
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self];
        //перевірка з'єднання
        if (connection) {
            NSLog(@"З'єднання почалось");
            self.receivedData = [[NSMutableData alloc] init];
            
            CFDictionaryAddValue(self.connectionToInfoMapping, CFBridgingRetain(connection), CFBridgingRetain([NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:self.checkRequest] forKey:@"requestType"]));
        }
        else
        {
            //якщо з'єднання нема
            // Inform the user that the connection failed.
            NSLog(@"Помилка з'єднання");
            UIAlertView *connectFailMessage = [[UIAlertView alloc] initWithTitle:@"URL Connection"
                                                                         message:@"Not success URL connection"
                                                                        delegate:self
                                                               cancelButtonTitle:@"Ok"
                                                               otherButtonTitles:nil];
            [connectFailMessage show];
        }
    }
    else
    {
        //якщо інету нема
        UIAlertView *connectFailMessage = [[UIAlertView alloc] initWithTitle:@"Internet Connection"
                                                                     message:@"Not success Internet connection"
                                                                    delegate:self
                                                           cancelButtonTitle:@"Ok"
                                                           otherButtonTitles:nil];
        [connectFailMessage show];
    }
}


-(void)answerToQuestionWithID:(NSInteger)questionID andOptionID:(NSInteger)optionID
{
    self.url = [NSURL URLWithString:@"http://id-bonus.com/api/app/question/vote"];
    self.checkRequest = kSendAnswer;
    //створюемо запит
    self.request = [NSMutableURLRequest requestWithURL:self.url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    
    //вказуэм протокол доступу
    [self.request setHTTPMethod:@"POST"];
    
    self.params = [NSMutableString stringWithFormat:@"item_id=%d", questionID];
    if(optionID !=0)
    {
        [self.params appendFormat:@"&option_id=%d", optionID];
    }
    [self.params appendFormat:@"&lang=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"currentLanguage"]];
    [self.params appendFormat:@"&token=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"authorization_Token"]];
    NSLog(@"Body %@",self.params);
    
    [self.request setHTTPBody:[self.params dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    //перевірка наявності інету
    if (checkConnection.hasConnectivity) {
        //створюєм з'єднання і начинаєм загрузку
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self];
        //перевірка з'єднання
        if (connection) {
            NSLog(@"З'єднання почалось");
            self.receivedData = [[NSMutableData alloc] init];
            
            CFDictionaryAddValue(self.connectionToInfoMapping, CFBridgingRetain(connection), CFBridgingRetain([NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:self.checkRequest] forKey:@"requestType"]));
        }
        else
        {
            //якщо з'єднання нема
            // Inform the user that the connection failed.
            NSLog(@"Помилка з'єднання");
            UIAlertView *connectFailMessage = [[UIAlertView alloc] initWithTitle:@"URL Connection"
                                                                         message:@"Not success URL connection"
                                                                        delegate:self
                                                               cancelButtonTitle:@"Ok"
                                                               otherButtonTitles:nil];
            [connectFailMessage show];
        }
    }
    else
    {
        //якщо інету нема
        UIAlertView *connectFailMessage = [[UIAlertView alloc] initWithTitle:@"Internet Connection"
                                                                     message:@"Not success Internet connection"
                                                                    delegate:self
                                                           cancelButtonTitle:@"Ok"
                                                           otherButtonTitles:nil];
        [connectFailMessage show];
    }
    
}

- (void)registrationWithEmail:(NSString *)email Password:(NSString *)password ConfirmPassword:(NSString *)confirmPassword
{
    self.url = [NSURL URLWithString:@"http://id-bonus.com/api/app/register"];
    
    self.checkRequest = kRegist;
    
    //створюемо запит
    self.request = [NSMutableURLRequest requestWithURL:self.url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    
    //вказуэм протокол доступу
    [self.request setHTTPMethod:@"POST"];
    
    self.params = [NSMutableString stringWithFormat:@"email=%@", email];
    [self.params appendFormat:@"&password=%@",password];
    [self.params appendFormat:@"&repassword=%@",confirmPassword];
    
    [self.request setHTTPBody:[self.params dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self connectionVerification];
}

- (void)getProfileData
{
    self.url = [NSURL URLWithString:@"http://id-bonus.com/api/app/profile"];
    
    self.checkRequest = kProfileInfo;
    
    //створюемо запит
    self.request = [NSMutableURLRequest requestWithURL:self.url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    
    //вказуэм протокол доступу
    [self.request setHTTPMethod:@"POST"];
    
    self.params = [NSMutableString stringWithFormat:@"token=%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"authorization_Token"]];
    [self.params appendFormat:@"&lang=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"currentLanguage"]];
    
    [self.request setHTTPBody:[self.params dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self connectionVerification];
}

- (void)getProfileDataForEdit
{
    self.url = [NSURL URLWithString:@"http://id-bonus.com/api/app/profile/edit"];
    
    self.checkRequest = kProfileEdit;
    
    //створюемо запит
    self.request = [NSMutableURLRequest requestWithURL:self.url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    
    //вказуэм протокол доступу
    [self.request setHTTPMethod:@"POST"];
    
    self.params = [NSMutableString stringWithFormat:@"token=%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"authorization_Token"]];
    [self.params appendFormat:@"&lang=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"currentLanguage"]];
    
    [self.request setHTTPBody:[self.params dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self connectionVerification];
}

- (void)sendProfileChanges:(NSString *)changedString
{
    self.url = [NSURL URLWithString:@"http://id-bonus.com/api/app/profile/save"];
    self.checkRequest = kProfileChange;
    self.request = [NSMutableURLRequest requestWithURL:self.url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    
    [self.request setHTTPMethod:@"POST"];
    
    self.params = [NSMutableString stringWithFormat:@"token=%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"authorization_Token"]];
    [self.params appendString:changedString];
    [self.request setHTTPBody:[self.params dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self connectionVerification];
}

- (void)sentBonusRate:(int)rate withProductId:(int)productId
{
    self.url = [NSURL URLWithString:@"http://id-bonus.com/api/app/bonus/rate"];
    self.checkRequest = kBonusRate;
    
    self.request  = [NSMutableURLRequest requestWithURL:self.url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    [self.request setHTTPMethod:@"POST"];
    self.params = [NSMutableString stringWithFormat:@"product_id=%d",productId];
    [self.params appendFormat:@"&rate=%d",rate];
    [[self params]appendFormat:@"&lang=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"currentLanguage"]];
    [[self params] appendFormat:@"&token=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"authorization_Token"]];
    [self.request setHTTPBody:[self.params dataUsingEncoding:NSUTF8StringEncoding]];
    [self connectionVerification];
}

- (void)recommendBonusWithProductId:(int)productId
{
    self.url = [NSURL URLWithString:@"http://id-bonus.com/api/app/bonus/recomend"];
    self.checkRequest = kBonusRecommend;
    
    self.request  = [NSMutableURLRequest requestWithURL:self.url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    [self.request setHTTPMethod:@"POST"];
    self.params = [NSMutableString stringWithFormat:@"product_id=%d",productId];
    [[self params]appendFormat:@"&lang=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"currentLanguage"]];
    [[self params] appendFormat:@"&token=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"authorization_Token"]];
    [self.request setHTTPBody:[self.params dataUsingEncoding:NSUTF8StringEncoding]];
    [self connectionVerification];
}

- (void)getBonusCommentsWithProductId:(int)productId andOffset:(int)offset
{
    self.url = [NSURL URLWithString:@"http://id-bonus.com/api/app/bonus/comments"];
    self.checkRequest = kBonusComments;
    
    self.request  = [NSMutableURLRequest requestWithURL:self.url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    [self.request setHTTPMethod:@"POST"];
    self.params = [NSMutableString stringWithFormat:@"product_id=%d",productId];
    [self.params appendFormat:@"&offset=%d",offset];
    [[self params]appendFormat:@"&lang=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"currentLanguage"]];
    [self.request setHTTPBody:[self.params dataUsingEncoding:NSUTF8StringEncoding]];
    [self connectionVerification];
}

- (void)sentBonusCommentWithProductId:(int)productId andText:(NSString *)text
{
    self.url = [NSURL URLWithString:@"http://id-bonus.com/api/app/bonus/comment"];
    self.checkRequest = kBonusComment;
    
    self.request  = [NSMutableURLRequest requestWithURL:self.url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    [self.request setHTTPMethod:@"POST"];
    self.params = [NSMutableString stringWithFormat:@"product_id=%d",productId];
    [self.params appendFormat:@"&text=%@",text];
    [[self params]appendFormat:@"&lang=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"currentLanguage"]];
    [[self params] appendFormat:@"&token=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"authorization_Token"]];
    [self.request setHTTPBody:[self.params dataUsingEncoding:NSUTF8StringEncoding]];
    [self connectionVerification];

}

- (void)orderBonusProductWithProductId:(int)productId andPhoneNumber:(NSString *)phone
{
    self.url = [NSURL URLWithString:@"http://id-bonus.com/api/app/bonus/order"];
    self.checkRequest = kOrderBonus;
    
    self.request  = [NSMutableURLRequest requestWithURL:self.url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    [self.request setHTTPMethod:@"POST"];
    self.params = [NSMutableString stringWithFormat:@"product_id=%d",productId];
    [self.params appendFormat:@"&phone=%@",phone];
    [[self params]appendFormat:@"&lang=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"currentLanguage"]];
    [[self params] appendFormat:@"&token=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"authorization_Token"]];
    [self.request setHTTPBody:[self.params dataUsingEncoding:NSUTF8StringEncoding]];
    [self connectionVerification];

}


//check conection and send request
- (void)connectionVerification
{
    if (checkConnection.hasConnectivity) {
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self];
        
        if(connection){
            self.receivedData = [[NSMutableData alloc]init];
            
            CFDictionaryAddValue(self.connectionToInfoMapping, CFBridgingRetain(connection), CFBridgingRetain([NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:self.checkRequest] forKey:@"requestType"]));
        }else{
            UIAlertView *failmessage = [[UIAlertView alloc] initWithTitle:@"URL Connection" message:@"Not seccess URL Connection" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [failmessage show];
        }
    }else{
        UIAlertView *failmessage = [[UIAlertView alloc] initWithTitle:@"Internet Connection" message:@"Not seccess Internet Connection" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [failmessage show];
    }

}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //отримано відповідь від сервера
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self.receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //добавляєм отримані дані
    [self.receivedData appendData:data];    
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSString *errorString = [[NSString alloc] initWithFormat:@"Connection failed! Error - %@ %@ %@",
                             [error localizedDescription],
                             [error description],
                             [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]];
    NSLog(@"%@", errorString);
    
    self.connectionInfo = CFBridgingRelease(CFDictionaryGetValue(self.connectionToInfoMapping, CFBridgingRetain(connection)));
    @try {
        [self.delegate finishedWithError:error TypeRequest:[[self.connectionInfo objectForKey:@"requestType" ] integerValue]];
    }
    @catch (NSException *exception) {
        UIAlertView *connectFailMessage = [[UIAlertView alloc] initWithTitle:@"Internet Connection"
                                                                     message:@"Not success Internet connection"
                                                                    delegate:self
                                                           cancelButtonTitle:@"Ok"
                                                           otherButtonTitles:nil];
        [connectFailMessage show];
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    [SVProgressHUD showErrorWithStatus:@"Ошибка загрузки"];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSLog(@"Довжина отриманих даних: %u", [self.receivedData length]);
    
    NSString *text = [[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", text);
    
    self.connectionInfo = CFBridgingRelease(CFDictionaryGetValue(self.connectionToInfoMapping, CFBridgingRetain(connection)));
//    [[self.connectionInfo objectForKey:@"receivedData"] appendData:data];
    
    NSDictionary *receivedDictionary = [JSONParserForDataEntenties parseJSONDataWithData:self.receivedData];
    NSString *token = [receivedDictionary valueForKey:@"token"];
    if (token.length != 0) {
        NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
        [userDefults setObject:token forKey:@"authorization_Token"];
        [userDefults synchronize];
    }
    
    [self.delegate finishedWithDictionary:receivedDictionary withTypeRequest:[[self.connectionInfo objectForKey:@"requestType"] intValue]];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    [SVProgressHUD dismiss];

}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FailConnectionAllertClickedOK" object:self];
}

@end
