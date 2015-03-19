//
//  PFEditProfileViewController.h
//  Times Clinic
//
//  Created by Pariwat Promjai on 3/14/2558 BE.
//  Copyright (c) 2558 Pariwat Promjai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLImageLoader.h"

#import "PFApi.h"

#import "PFEditDetailProfileViewController.h"

@protocol PFEditProfileViewControllerDelegate <NSObject>

- (void)PFEditProfileViewControllerBack;

@end

@interface PFEditProfileViewController : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) PFApi *Api;
@property (strong, nonatomic) NSDictionary *obj;

@property NSUserDefaults *meOffline;

@property (strong, nonatomic) IBOutlet UINavigationController *navController;
@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;
@property (strong, nonatomic  ) IBOutlet UINavigationItem *navItem;

@property (strong, nonatomic) IBOutlet UIView *waitView;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *headerView;

@property (strong, nonatomic) IBOutlet UIImageView *img_thumUser;
@property (strong, nonatomic) IBOutlet UILabel *lb_display_name;

@property (strong, nonatomic) IBOutlet UITextField *txt_display_name;

@property (strong, nonatomic) IBOutlet UIButton *bt_password;
@property (strong, nonatomic) IBOutlet UIImageView *img_password;

@property (strong, nonatomic) IBOutlet UITextField *txt_facebook;
@property (strong, nonatomic) IBOutlet UITextField *txt_email;
@property (strong, nonatomic) IBOutlet UITextField *txt_website;
@property (strong, nonatomic) IBOutlet UITextField *txt_tel;
@property (strong, nonatomic) IBOutlet UITextField *txt_gender;
@property (strong, nonatomic) IBOutlet UITextField *txt_birthday;

//button Tap
- (IBAction)uploadPictureTapped:(id)sender;
- (IBAction)displaynameTapped:(id)sender;
- (IBAction)passwordTapped:(id)sender;
- (IBAction)facebookTapped:(id)sender;
- (IBAction)emailTapped:(id)sender;
- (IBAction)websiteTapped:(id)sender;
- (IBAction)telTapped:(id)sender;
- (IBAction)genderTapped:(id)sender;
- (IBAction)birthdayTapped:(id)sender;

@end
