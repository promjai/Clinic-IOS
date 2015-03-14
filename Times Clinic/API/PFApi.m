//
//  PFApi.m
//  PFApi
//
//  Created by Pariwat Promjai on 3/11/2558 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import "PFApi.h"

@implementation PFApi

- (id) init
{
    if (self = [super init])
    {
        self.manager = [AFHTTPRequestOperationManager manager];
        self.userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

#pragma mark - Access Token
- (void)saveAccessToken:(NSString *)access_token {
    [self.userDefaults setObject:access_token forKey:@"access_token"];
}

- (NSString *)getAccessToken {
    return [self.userDefaults objectForKey:@"access_token"];
}

#pragma mark - User ID
- (void)saveUserId:(NSString *)user_id {
    [self.userDefaults setObject:user_id forKey:@"user_id"];
}

- (NSString *)getUserId {
    return [self.userDefaults objectForKey:@"user_id"];
}

#pragma mark - Check Log in
- (BOOL)checkLogin {
    if ([self.userDefaults objectForKey:@"user_id"] != nil || [self.userDefaults objectForKey:@"access_token"] != nil) {
        return true;
    } else {
        return false;
    }
}

#pragma mark - Register
- (void)registerWithUsername:(NSString *)username email:(NSString *)email password:(NSString *)password gender:(NSString *)gender birth_date:(NSString *)birth_date {
    
    self.urlStr = [[NSString alloc] initWithFormat:@"%@register",API_URL];
    NSDictionary *parameters = @{@"username":username , @"password":password , @"email":email ,@"birth_date":birth_date , @"gender":gender};
    [self.manager POST:self.urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self registerWithUsernameResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self registerWithUsernameErrorResponse:[error localizedDescription]];
    }];
    
}

#pragma mark - Login facebook token
- (void)loginWithFacebookToken:(NSString *)fb_token {
    
    self.urlStr = [[NSString alloc] initWithFormat:@"%@oauth/facebook",API_URL];
    
    NSDictionary *parameters;
    
    if ([[self.userDefaults objectForKey:@"deviceToken"] isEqualToString:@""] || [[self.userDefaults objectForKey:@"deviceToken"] isEqualToString:@"(null)"]) {
        
        parameters = @{@"facebook_token":fb_token , @"ios_device_token[key]":@"" , @"ios_device_token[type]":@"product"};
        
    } else {
        
        parameters = @{@"facebook_token":fb_token , @"ios_device_token[key]":[self.userDefaults objectForKey:@"deviceToken"] , @"ios_device_token[type]":@"product"};
        
    }
    
    [self.manager POST:self.urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self loginWithFacebookTokenResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self loginWithFacebookTokenErrorResponse:[error localizedDescription]];
    }];
    
}

#pragma mark - Login by Username
- (void)loginWithUsername:(NSString *)username password:(NSString *)password {
    
    self.urlStr = [[NSString alloc] initWithFormat:@"%@oauth/password",API_URL];
    
    NSDictionary *parameters = @{@"username":username , @"password":password , @"ios_device_token[key]":[self.userDefaults objectForKey:@"deviceToken"] , @"ios_device_token[type]":@"product"};
    
    [self.manager POST:self.urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self loginWithUsernameResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self loginWithUsernameErrorResponse:[error localizedDescription]];
    }];
    
}

#pragma mark - Log out
- (void)logOut {
    
    [self.userDefaults removeObjectForKey:@"type"];
    [self.userDefaults removeObjectForKey:@"access_token"];
    [self.userDefaults removeObjectForKey:@"user_id"];
    
}

#pragma mark - Contact
- (void)getContact {
    
    self.urlStr = [[NSString alloc] initWithFormat:@"%@contact",API_URL];
    
    [self.manager GET:self.urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self getContactResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self getContactErrorResponse:[error localizedDescription]];
    }];
    
}

- (void)sendComment:(NSString *)comment {
    
    self.urlStr = [[NSString alloc] initWithFormat:@"%@contact/comment",API_URL];
    
    NSLog(@"%@",[self getAccessToken]);
    
    NSDictionary *parameters = @{ @"message":comment , @"access_token":[self getAccessToken] };
    [self.manager POST:self.urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self sendCommentResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self sendCommentErrorResponse:[error localizedDescription]];
    }];
    
}

@end
