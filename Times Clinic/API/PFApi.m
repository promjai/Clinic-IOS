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
        
        parameters = @{@"facebook_token":fb_token , @"ios_device_token[key]":@"" , @"ios_device_token[type]":@"dev"};
        
    } else {
        
        parameters = @{@"facebook_token":fb_token , @"ios_device_token":[self.userDefaults objectForKey:@"deviceToken"]};
        
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
    
    NSDictionary *parameters = @{@"username":username , @"password":password , @"ios_device_token":[self.userDefaults objectForKey:@"deviceToken"]};
    
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

#pragma mark - User
- (void)user {
    
    self.urlStr = [[NSString alloc] initWithFormat:@"%@user/%@",API_URL,[self getUserId]];
    
    [self.manager GET:self.urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self userResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self userErrorResponse:[error localizedDescription]];
    }];
    
}

- (void)userSwitch {
    
    self.urlStr = [[NSString alloc] initWithFormat:@"%@user/setting/%@",API_URL,[self getUserId]];
    
    [self.manager GET:self.urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self userSwitchResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self userSwitchErrorResponse:[error localizedDescription]];
    }];

}

- (void)userSetting:(NSString *)parameter value:(NSString *)value {
    
    NSDictionary *parameters;
    
    if ([parameter isEqualToString:@"picture"]) {
        
        parameters = @{@"picture":value , @"access_token":[self getAccessToken]};
        
    } else if ([parameter isEqualToString:@"display_name"]) {
        
        parameters = @{@"display_name":value , @"access_token":[self getAccessToken]};
        
    } else if ([parameter isEqualToString:@"hn_number"]) {
        
        parameters = @{@"hn_number":value , @"access_token":[self getAccessToken]};
        
    } else if ([parameter isEqualToString:@"fb_name"]) {
        
        parameters = @{@"fb_name":value , @"access_token":[self getAccessToken]};
        
    } else if ([parameter isEqualToString:@"email"]) {
        
        parameters = @{@"email":value , @"access_token":[self getAccessToken]};
        
    } else if ([parameter isEqualToString:@"website"]) {
        
        parameters = @{@"website":value , @"access_token":[self getAccessToken]};
        
    } else if ([parameter isEqualToString:@"mobile"]) {
        
        parameters = @{@"mobile":value , @"access_token":[self getAccessToken]};
        
    } else if ([parameter isEqualToString:@"gender"]) {
        
        parameters = @{@"gender":value , @"access_token":[self getAccessToken]};
        
    } else if ([parameter isEqualToString:@"birth_date"]) {
        
        parameters = @{@"birth_date":value , @"access_token":[self getAccessToken]};
        
    }
    
    self.urlStr = [[NSString alloc] initWithFormat:@"%@user/profile",API_URL];
    
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [self.manager.requestSerializer setValue:nil forHTTPHeaderField:@"X-Auth-Token"];
    
    [self.manager PUT:self.urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self userSettingResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self userSettingErrorResponse:[error localizedDescription]];
    }];
    
}

- (void)userswitchOnOff:(NSString *)parameter value:(NSString *)value {
    
    self.urlStr = [[NSString alloc] initWithFormat:@"%@user/setting/%@/%@",API_URL,[self getUserId],parameter];
    
    NSDictionary *parameters = @{@"enable":value};
    
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [self.manager.requestSerializer setValue:nil forHTTPHeaderField:@"X-Auth-Token"];
    [self.manager PUT:self.urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self userSwitchOnOffResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self userSwitchOnOffErrorResponse:[error localizedDescription]];
    }];
    
}

- (void)changePassword:(NSString *)password new_password:(NSString *)new_password confirm_password:(NSString *)confirm_password {
    
    self.urlStr = [[NSString alloc] initWithFormat:@"%@user/profile/password",API_URL];
    
    NSDictionary *parameters = @{@"password":password , @"new_password":new_password ,@"confirm_password":confirm_password , @"access_token":[self getAccessToken]};
    
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [self.manager.requestSerializer setValue:nil forHTTPHeaderField:@"X-Auth-Token"];
    [self.manager PUT:self.urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self changPasswordResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self changPasswordErrorResponse:[error localizedDescription]];
    }];
    
}

#pragma mark - Feed
- (void)getOverview {
    
    self.urlStr = [[NSString alloc] initWithFormat:@"%@feed/overview",API_URL];
    
    [self.manager GET:self.urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self getOverviewResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self getOverviewErrorResponse:[error localizedDescription]];
    }];
    
}

- (void)getFeed {
    
    self.urlStr = [[NSString alloc] initWithFormat:@"%@feed",API_URL];
    
    [self.manager GET:self.urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self getFeedResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self getFeedErrorResponse:[error localizedDescription]];
    }];

}

- (void)getNotification:(NSString *)limit link:(NSString *)link {
    
    if ([link isEqualToString:@"NO"] ) {
        self.urlStr = [[NSString alloc] initWithFormat:@"%@user/notify?limit=%@",API_URL,limit];
    } else if ([limit isEqualToString:@"NO"]) {
        self.urlStr = link;
    }
    
    NSDictionary *parameters = @{@"access_token":[self getAccessToken]};
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [self.manager.requestSerializer setValue:nil forHTTPHeaderField:@"X-Auth-Token"];
    [self.manager GET:self.urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self getNotificationResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self getNotificationErrorResponse:[error localizedDescription]];
    }];
    
}

- (void)deleteNotification:(NSString *)notify_id {
    
    self.urlStr = [[NSString alloc] initWithFormat:@"%@user/notify/%@",API_URL,notify_id];
    
    [self.manager DELETE:self.urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self deleteNotificationResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self deleteNotificationErrorResponse:[error localizedDescription]];
    }];
    
}

- (void)clearBadge {
    
    self.urlStr = [[NSString alloc] initWithFormat:@"%@user/notify/clear_badge",API_URL];
    
    NSDictionary *parameters = @{@"access_token":[self getAccessToken]};
    
    [self.manager GET:self.urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"clear : %@",responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

#pragma mark - Service
- (void)getService:(NSString *)limit link:(NSString *)link {

    if ([link isEqualToString:@"NO"] ) {
        self.urlStr = [[NSString alloc] initWithFormat:@"%@service?limit=%@",API_URL,limit];
    } else if ([limit isEqualToString:@"NO"]) {
        self.urlStr = link;
    }
    
    [self.manager GET:self.urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self getServiceResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self getServiceErrorResponse:[error localizedDescription]];
    }];
    
}

- (void)getServiceByURL:(NSString *)url {

    self.urlStr = [[NSString alloc] initWithFormat:@"%@",url];
    
    [self.manager GET:self.urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self getServiceResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self getServiceErrorResponse:[error localizedDescription]];
    }];
    
}

- (void)getServiceByID:(NSString *)service_id {

    self.urlStr = [[NSString alloc] initWithFormat:@"%@service/%@/picture",API_URL,service_id];
    
    [self.manager GET:self.urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self getServiceResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self getServiceErrorResponse:[error localizedDescription]];
    }];

}

- (void)getPromotion:(NSString *)limit link:(NSString *)link {
    
    if ([link isEqualToString:@"NO"] ) {
        self.urlStr = [[NSString alloc] initWithFormat:@"%@coupon?limit=%@",API_URL,limit];
    } else if ([limit isEqualToString:@"NO"]) {
        self.urlStr = link;
    }
    
    NSDictionary *parameters;
    
    if ([self checkLogin] == false) {
        
        parameters = nil;
        
    } else {
        
        parameters = @{@"access_token":[self getAccessToken]};
        
    }
    
    [self.manager GET:self.urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self getPromotionResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self getPromotionErrorResponse:[error localizedDescription]];
    }];

}

- (void)getPromotionByID:(NSString *)promotion_id {

    self.urlStr = [[NSString alloc] initWithFormat:@"%@coupon/%@",API_URL,promotion_id];
    
    NSDictionary *parameters;
    
    if ([self checkLogin] == false) {
        
        parameters = nil;
        
    } else {
        
        parameters = @{@"access_token":[self getAccessToken]};
        
    }
    
    [self.manager GET:self.urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self getPromotionResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self getPromotionErrorResponse:[error localizedDescription]];
    }];
    
}

- (void)getPromotionRequest:(NSString *)promotion_id {
    
    self.urlStr = [[NSString alloc] initWithFormat:@"%@coupon/request/%@",API_URL,promotion_id];
    
    NSDictionary *parameters = @{@"access_token":[self getAccessToken]};
    
    [self.manager POST:self.urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self getPromotionRequestResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self getPromotionRequestErrorResponse:[error localizedDescription]];
    }];
    
}

#pragma mark - Times
- (void)getTimes {

    self.urlStr = [[NSString alloc] initWithFormat:@"%@appoint",API_URL];
    
    NSDictionary *parameters = @{@"access_token":[self getAccessToken]};
    
    [self.manager GET:self.urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self getTimesResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self getTimesErrorResponse:[error localizedDescription]];
    }];
    
}

- (void)checkPassword:(NSString *)password {

    self.urlStr = [[NSString alloc] initWithFormat:@"%@appoint/password",API_URL];
    
    NSDictionary *parameters = @{@"password":password , @"access_token":[self getAccessToken]};
    
    [self.manager POST:self.urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self checkPasswordResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self checkPasswordErrorResponse:[error localizedDescription]];
    }];
    
}

- (void)getDateTimes {

    self.urlStr = [[NSString alloc] initWithFormat:@"%@appoint/datetime",API_URL];
    
    [self.manager GET:self.urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self getDateTimesResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self getDateTimesErrorResponse:[error localizedDescription]];
    }];
    
}

- (void)appoint:(NSString *)date time:(NSString *)time name:(NSString *)name phone:(NSString *)phone detail:(NSString *)detail status:(NSString *)status {

    self.urlStr = [[NSString alloc] initWithFormat:@"%@appoint",API_URL];
    
    NSDictionary *parameters = @{@"date_add":date , @"time_add":time , @"detail":detail , @"name":name , @"phone":phone , @"status":status , @"access_token":[self getAccessToken]};
    
    [self.manager POST:self.urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self apppointResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self apppointErrorResponse:[error localizedDescription]];
    }];

}

- (void)appointById:(NSString *)appoint_id {

    self.urlStr = [[NSString alloc] initWithFormat:@"%@appoint/%@",API_URL,appoint_id];
    
    NSDictionary *parameters = @{@"access_token":[self getAccessToken]};
    
    [self.manager GET:self.urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self apppointByIdResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self apppointByIdErrorResponse:[error localizedDescription]];
    }];

}

- (void)appointStatus:(NSString *)status appoint_id:(NSString *)appoint_id {

    self.urlStr = [[NSString alloc] initWithFormat:@"%@appoint/status/%@",API_URL,appoint_id];
    
    NSDictionary *parameters = @{@"status":status , @"access_token":[self getAccessToken]};
    
    [self.manager PUT:self.urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self apppointStatusResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self apppointStatusErrorResponse:[error localizedDescription]];
    }];

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
    
    NSDictionary *parameters;
    
    if ([self checkLogin] == false) {
    
        parameters = @{@"message":comment};
        
    } else {
    
        parameters = @{@"message":comment , @"access_token":[self getAccessToken]};
    
    }
    
    [self.manager POST:self.urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self sendCommentResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self sendCommentErrorResponse:[error localizedDescription]];
    }];
    
}

@end
