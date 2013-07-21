//
//  MSAPI.h
//  TerritoryOfSuccess
//
//  Created by Matrix Soft on 21.01.13.
//  Copyright (c) 2013 Matrix Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONParserForDataEntenties.h"

typedef enum {kAuth, kRegist, kNews, kNewsWithId, kCode, kBrands, kCategories, kCatalog, kQuestCateg, kComment, kComplaint, kQuestions, kCreateQuest, kMyQuestions, kQuestDetail, kQuestStat, kLastQuest,kSendAnswer, kComments, kProfileEdit, kProfileInfo, kProfileChange, kRate, kRecommend, kBonusCategories, kBonusSubCategories, kBonusComment, kBonusComments, kBonusRate, kBonusRecommend, kOrderBonus, kCustomProduct} requestTypes;

@protocol WsCompleteDelegate

- (void)finishedWithDictionary:(NSDictionary *)dictionary
               withTypeRequest:(requestTypes)type;
@optional
- (void)finishedWithError:(NSError *)error TypeRequest:(requestTypes)type;

@end

@interface MSAPI : NSObject<NSURLConnectionDelegate, NSURLConnectionDataDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) id<WsCompleteDelegate> delegate;

@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) NSMutableURLRequest *request;
@property (strong, nonatomic) NSURLConnection *connection;
@property (strong, nonatomic) NSMutableString *params;
@property (strong, nonatomic) NSMutableData *receivedData;
@property requestTypes checkRequest;
@property (nonatomic) CFMutableDictionaryRef connectionToInfoMapping;
@property (strong, nonatomic) NSMutableDictionary *connectionInfo;

- (void)getFiveNewsWithOffset:(int)offset;
- (void)getNewsWithId:(NSString *)newsId;
- (void)getTopNews;
- (void)checkCode:(NSString *)code;

- (void)getFiveBrandsWithOffset:(int)offset;
- (void)getCategories;
- (void)getProductsWithOffset:(int)offset withBrandId:(int)brandId withCategoryId:(int)categoryId;
- (void)getQuestionsWithParentID:(int)parentId;
- (void)logInWithMail:(NSString *)email Password:(NSString *)password;
- (void)registrationWithEmail:(NSString *)email Password:(NSString *)password ConfirmPassword:(NSString *)confirmPassword;
- (void)getLastQuestions;
- (void)sentCommentWithProductId:(int)productId andText:(NSString *)text;
- (void)getMyQuestionsWithOffset:(int)offset;
- (void)createQuestionWithItems:(NSMutableString *)string;
- (void)getDetailQuestionWithID:(NSInteger)questionId;
- (void)getStatisticQuestionWithID:(NSInteger)questionId;
- (void)getCommentsWithProductId:(int)productId andOffset:(int)offset;
- (void)answerToQuestionWithID:(NSInteger)questionID andOptionID:(NSInteger)optionID;
- (void)sendComplaintForProduct:(NSString *)product
                       withCode:(NSString *)code
                   withLocation:(NSString *)location
                    withComment:(NSString *)comment
                  withImage:(UIImage *)image
                  withImageName:(NSString *)imageName;
- (void)getProfileDataForEdit;
- (void)getProfileData;
- (void)sentRate:(int)rate withProductId:(int)productId;
- (void)recommendWithProductId:(int)productId;
- (void)sendProfileChanges:(NSString *)changedString;
- (void)getBonusCategories;
- (void)getBonusSubCategories:(int)categoryId withOffset:(int)offset;
- (void)getBonusProduct:(int)productId;

- (void)sentBonusRate:(int)rate withProductId:(int)productId;
- (void)recommendBonusWithProductId:(int)productId;
- (void)getBonusCommentsWithProductId:(int)productId andOffset:(int)offset;
- (void)sentBonusCommentWithProductId:(int)productId andText:(NSString *)text;
- (void)orderBonusProductWithProductId:(int)productId andPhoneNumber:(NSString *)phone;
-(void)sendCustomProductWithImage:(UIImage *)image
                         withName:(NSString *)name
                    withImageName:(NSString *)imageName
                     withParentID:(NSInteger)parentID;
@end
