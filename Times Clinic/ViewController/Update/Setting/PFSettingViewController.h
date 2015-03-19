//
//  PFSettingViewController.h
//  Times Clinic
//
//  Created by Pariwat Promjai on 3/14/2558 BE.
//  Copyright (c) 2558 Pariwat Promjai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLImageLoader.h"
#import <FacebookSDK/FacebookSDK.h>

#import "PFApi.h"

#import "PFEditProfileViewController.h"

@protocol PFSettingViewControllerDelegate <NSObject>

- (void)PFImageViewController:(id)sender viewPicture:(UIImage *)image;
- (void)PFSettingViewControllerBack;

@end

@interface PFSettingViewController : UIViewController

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) PFApi *Api;
@property (strong, nonatomic) NSDictionary *obj;

@property NSUserDefaults *meOffline;
@property NSUserDefaults *settingOffline;

@property (strong, nonatomic) IBOutlet UIView *waitView;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *footerView;

@property (strong, nonatomic) IBOutlet UIImageView *thumUser;
@property (strong, nonatomic) IBOutlet UILabel *display_name;

@property (strong, nonatomic) IBOutlet UISwitch *switchNews;
@property (strong, nonatomic) IBOutlet UISwitch *switchMessage;

@property (strong, nonatomic) IBOutlet UIButton *logoutButton;

// button Tap
- (IBAction)fullimage:(id)sender;
- (IBAction)editProfile:(id)sender;
- (IBAction)switchNewsonoff:(id)sender;
- (IBAction)switchMessageonoff:(id)sender;
- (IBAction)logoutTapped:(id)sender;

@end
