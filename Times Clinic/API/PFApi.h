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

#pragma mark - Contact
- (void)getContact;
- (void)sendComment:(NSString *)comment;

@end
