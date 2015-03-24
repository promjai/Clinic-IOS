//
//  PFApi.h
//  PFApi
//
//  Created by Pariwat Promjai on 3/11/2558 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@protocol PFApiDelegate <NSObject>

#pragma mark - Register
- (void)PFApi:(id)sender registerWithUsernameResponse:(NSDictionary *)response;
- (void)PFApi:(id)sender registerWithUsernameErrorResponse:(NSString *)errorResponse;

#pragma mark - Login facebook token
- (void)PFApi:(id)sender loginWithFacebookTokenResponse:(NSDictionary *)response;
- (void)PFApi:(id)sender loginWithFacebookTokenErrorResponse:(NSString *)errorResponse;

#pragma mark - login with username password
- (void)PFApi:(id)sender loginWithUsernameResponse:(NSDictionary *)response;
- (void)PFApi:(id)sender loginWithUsernameErrorResponse:(NSString *)errorResponse;

#pragma mark - User
- (void)PFApi:(id)sender userResponse:(NSDictionary *)response;
- (void)PFApi:(id)sender userErrorResponse:(NSString *)errorResponse;

- (void)PFApi:(id)sender userSettingResponse:(NSDictionary *)response;
- (void)PFApi:(id)sender userSettingErrorResponse:(NSString *)errorResponse;

- (void)PFApi:(id)sender userSwitchResponse:(NSDictionary *)response;
- (void)PFApi:(id)sender userSwitchErrorResponse:(NSString *)errorResponse;

- (void)PFApi:(id)sender userSwitchOnOffResponse:(NSDictionary *)response;
- (void)PFApi:(id)sender userSwitchOnOffErrorResponse:(NSString *)errorResponse;

- (void)PFApi:(id)sender changPasswordResponse:(NSDictionary *)response;
- (void)PFApi:(id)sender changPasswordErrorResponse:(NSString *)errorResponse;

#pragma mark - Feed Protocal Delegate
- (void)PFApi:(id)sender getOverviewResponse:(NSDictionary *)response;
- (void)PFApi:(id)sender getOverviewErrorResponse:(NSString *)errorResponse;

- (void)PFApi:(id)sender getFeedResponse:(NSDictionary *)response;
- (void)PFApi:(id)sender getFeedErrorResponse:(NSString *)errorResponse;

#pragma mark - Service Protocal Delegate
- (void)PFApi:(id)sender getServiceResponse:(NSDictionary *)response;
- (void)PFApi:(id)sender getServiceErrorResponse:(NSString *)errorResponse;

- (void)PFApi:(id)sender getPromotionResponse:(NSDictionary *)response;
- (void)PFApi:(id)sender getPromotionErrorResponse:(NSString *)errorResponse;

- (void)PFApi:(id)sender getPromotionRequestResponse:(NSDictionary *)response;
- (void)PFApi:(id)sender getPromotionRequestErrorResponse:(NSString *)errorResponse;

#pragma mark - Times Protocal Delegate
- (void)PFApi:(id)sender getTimesResponse:(NSDictionary *)response;
- (void)PFApi:(id)sender getTimesErrorResponse:(NSString *)errorResponse;

- (void)PFApi:(id)sender checkPasswordResponse:(NSDictionary *)response;
- (void)PFApi:(id)sender checkPasswordErrorResponse:(NSString *)errorResponse;

- (void)PFApi:(id)sender getDateTimesResponse:(NSDictionary *)response;
- (void)PFApi:(id)sender getDateTimesErrorResponse:(NSString *)errorResponse;

#pragma mark - Contact Protocal Delegate
- (void)PFApi:(id)sender getContactResponse:(NSDictionary *)response;
- (void)PFApi:(id)sender getContactErrorResponse:(NSString *)errorResponse;

- (void)PFApi:(id)sender sendCommentResponse:(NSDictionary *)response;
- (void)PFApi:(id)sender sendCommentErrorResponse:(NSString *)errorResponse;

@end

@interface PFApi : NSObject

#pragma mark - Property
@property (assign, nonatomic) id delegate;
@property AFHTTPRequestOperationManager *manager;
@property NSUserDefaults *userDefaults;
@property NSString *urlStr;

#pragma mark - User_id
- (void)saveUserId:(NSString *)user_id;
- (void)saveAccessToken:(NSString *)access_token;

- (NSString *)getUserId;
- (NSString *)getAccessToken;

#pragma mark - Check Login
- (BOOL)checkLogin;

#pragma mark - Register
- (void)registerWithUsername:(NSString *)username email:(NSString *)email password:(NSString *)password gender:(NSString *)gender birth_date:(NSString *)birth_date;

#pragma mark - Login facebook token
- (void)loginWithFacebookToken:(NSString *)fb_token;

#pragma mark - Login by Username
- (void)loginWithUsername:(NSString *)username password:(NSString *)passeord;

#pragma mark - Log out
- (void)logOut;

#pragma mark - User
- (void)user;
- (void)userSwitch;
- (void)userSetting:(NSString *)parameter value:(NSString *)value;
- (void)changePassword:(NSString *)password new_password:(NSString *)new_password confirm_password:(NSString *)confirm_password;
- (void)userswitchOnOff:(NSString *)parameter value:(NSString *)value;

#pragma mark - Feed
- (void)getOverview;
- (void)getFeed;

- (void)checkBadge;
- (void)clearBadge;

#pragma mark - Service
- (void)getService:(NSString *)limit link:(NSString *)link;
- (void)getServiceByURL:(NSString *)url;
- (void)getServiceByID:(NSString *)service_id;

- (void)getPromotion:(NSString *)limit link:(NSString *)link;
- (void)getPromotionByID:(NSString *)promotion_id;
- (void)getPromotionRequest:(NSString *)promotion_id;

#pragma mark - Times
- (void)getTimes;
- (void)checkPassword:(NSString *)password;
- (void)getDateTimes;

#pragma mark - Contact
- (void)getContact;
- (void)sendComment:(NSString *)comment;

@end
