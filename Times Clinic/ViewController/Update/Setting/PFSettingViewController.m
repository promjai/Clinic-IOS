//
//  PFSettingViewController.m
//  Times Clinic
//
//  Created by Pariwat Promjai on 3/14/2558 BE.
//  Copyright (c) 2558 Pariwat Promjai. All rights reserved.
//

#import "PFSettingViewController.h"

@interface PFSettingViewController ()

@end

@implementation PFSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.0f/255.0f green:175.0f/255.0f blue:0.0f/255.0f alpha:1.0f]];
        self.meOffline = [NSUserDefaults standardUserDefaults];
        self.settingOffline = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.obj = [[NSDictionary alloc] init];
    
    [self.view addSubview:self.waitView];
    
    self.Api = [[PFApi alloc] init];
    self.Api.delegate = self;
    
    /* NavigationBar */
    [self setNavigationBar];
    
    /* View */
    [self setView];
    
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;
    
    /* API */
    [self.Api user];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

/* Set NavigationBar */

- (void)setNavigationBar {
    
    self.navigationItem.title = @"ตั้งค่า";
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    
}

/* Set View */

- (void)setView {
    
    [self.logoutButton.layer setMasksToBounds:YES];
    [self.logoutButton.layer setCornerRadius:5.0f];
    
}

/* User API */

- (void)PFApi:(id)sender userResponse:(NSDictionary *)response {
    NSLog(@"%@",response);
    
    self.obj = response;
    
    [self.waitView removeFromSuperview];
    
    [self.meOffline setObject:response forKey:@"meOffline"];
    [self.meOffline synchronize];
    
    self.display_name.text = [response objectForKey:@"display_name"];
    
    NSString *picStr = [[response objectForKey:@"picture"] objectForKey:@"url"];
    self.thumUser.layer.masksToBounds = YES;
    self.thumUser.contentMode = UIViewContentModeScaleAspectFill;
    
    [DLImageLoader loadImageFromURL:picStr
                          completed:^(NSError *error, NSData *imgData) {
                              self.thumUser.image = [UIImage imageWithData:imgData];
                          }];
    
    [self.Api userSwitch];
    
}

- (void)PFApi:(id)sender userErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
    
    [self.waitView removeFromSuperview];
    
    self.display_name.text = [[self.meOffline objectForKey:@"meOffline"] objectForKey:@"display_name"];
    
    NSString *picStr = [[[self.meOffline objectForKey:@"meOffline"] objectForKey:@"picture"] objectForKey:@"url"];
    self.thumUser.layer.masksToBounds = YES;
    self.thumUser.contentMode = UIViewContentModeScaleAspectFill;
    
    [DLImageLoader loadImageFromURL:picStr
                          completed:^(NSError *error, NSData *imgData) {
                              self.thumUser.image = [UIImage imageWithData:imgData];
                          }];
    
    [self.Api userSwitch];
    
}

/* User Switch API */

- (void)PFApi:(id)sender userSwitchResponse:(NSDictionary *)response {
    NSLog(@"%@",response);
    
    [self.settingOffline setObject:response forKey:@"settingOffline"];
    [self.settingOffline synchronize];
    
    //switch
    
    if ([[response objectForKey:@"notify_update"] intValue] == 1) {
        self.switchNews.on = YES;
    } else {
        self.switchNews.on = NO;
    }
    
    if ([[response objectForKey:@"notify_message"] intValue] == 1) {
        self.switchMessage.on = YES;
    } else {
        self.switchMessage.on = NO;
    }
    
}


- (void)PFApi:(id)sender userSwitchErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
    
    if ([[[self.settingOffline objectForKey:@"settingOffline"] objectForKey:@"notify_update"] intValue] == 1) {
        self.switchNews.on = YES;
    } else {
        self.switchNews.on = NO;
    }
    
    if ([[[self.settingOffline objectForKey:@"settingOffline"] objectForKey:@"notify_message"] intValue] == 1) {
        self.switchMessage.on = YES;
    } else {
        self.switchMessage.on = NO;
    }
    
}

/* User Switch On/Off API */

- (void)PFApi:(id)sender userSwitchOnOffResponse:(NSDictionary *)response {
    NSLog(@"%@",response);
    
    [self.Api userSwitch];
    
}

- (void)PFApi:(id)sender userSwitchOnOffErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
}

/* Full Image Tap */

- (IBAction)fullimage:(id)sender {
    
    [self.delegate PFImageViewController:self viewPicture:self.thumUser.image];
    
}

/* Edit Profile Tap */

- (IBAction)editProfile:(id)sender {

    PFEditProfileViewController *editprofileView = [[PFEditProfileViewController alloc] init];
    if(IS_WIDESCREEN) {
        editprofileView = [[PFEditProfileViewController alloc] initWithNibName:@"PFEditProfileViewController_Wide" bundle:nil];
    } else {
        editprofileView = [[PFEditProfileViewController alloc] initWithNibName:@"PFEditProfileViewController" bundle:nil];
    }
    editprofileView.delegate = self;
    [self presentModalViewController:editprofileView animated:YES];
    
}

/* Switch New Tap */

- (IBAction)switchNewsonoff:(id)sender{
    
    if(self.switchNews.on) {
        [self.Api userswitchOnOff:@"update" value:@"1"];
    } else {
        [self.Api userswitchOnOff:@"update" value:@"0"];
    }
    
}

/* Switch Message Tap */

- (IBAction)switchMessageonoff:(id)sender{
    
    if(self.switchMessage.on) {
        [self.Api userswitchOnOff:@"message" value:@"1"];
    } else {
        [self.Api userswitchOnOff:@"message" value:@"0"];
    }
    
}

/* Log Out Tap */

- (IBAction)logoutTapped:(id)sender {
    
    [FBSession.activeSession closeAndClearTokenInformation];
    [self.Api logOut];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)PFEditProfileViewControllerBack {
    
    [self viewDidLoad];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        // 'Back' button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        if([self.delegate respondsToSelector:@selector(PFSettingViewControllerBack)]){
            [self.delegate PFSettingViewControllerBack];
        }
    }
    
}

@end
