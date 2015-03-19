//
//  PFEditDetailProfileViewController.h
//  Times Clinic
//
//  Created by Pariwat Promjai on 3/16/2558 BE.
//  Copyright (c) 2558 Pariwat Promjai. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PFApi.h"

@protocol PFEditDetailProfileViewControllerDelegate <NSObject>

- (void)PFEditDetailProfileViewControllerBack;

@end

@interface PFEditDetailProfileViewController : UIViewController

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) PFApi *Api;
@property (strong, nonatomic) NSDictionary *obj;
@property (strong, nonatomic) NSString *checkstatus;
@property (strong, nonatomic) NSString *checkgender;

@property (strong, nonatomic) NSString *titlename;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *displaynameView;
@property (strong, nonatomic) IBOutlet UIView *passwordView;
@property (strong, nonatomic) IBOutlet UIView *facebookView;
@property (strong, nonatomic) IBOutlet UIView *emailView;
@property (strong, nonatomic) IBOutlet UIView *websiteView;
@property (strong, nonatomic) IBOutlet UIView *phoneView;
@property (strong, nonatomic) IBOutlet UIView *genderView;
@property (strong, nonatomic) IBOutlet UIView *birthdayView;

@property (strong, nonatomic) IBOutlet UITextField *txt_displayname;
@property (strong, nonatomic) IBOutlet UITextField *txt_facebook;
@property (strong, nonatomic) IBOutlet UITextField *txt_email;
@property (strong, nonatomic) IBOutlet UITextField *txt_password;
@property (strong, nonatomic) IBOutlet UITextField *txt_newpassword;
@property (strong, nonatomic) IBOutlet UITextField *txt_confirmpassword;
@property (strong, nonatomic) IBOutlet UITextField *txt_website;
@property (strong, nonatomic) IBOutlet UITextField *txt_phone;

@property (strong, nonatomic) IBOutlet UIButton *bt_displayname;
@property (strong, nonatomic) IBOutlet UIButton *bt_password;
@property (strong, nonatomic) IBOutlet UIButton *bt_facebook;
@property (strong, nonatomic) IBOutlet UIButton *bt_email;
@property (strong, nonatomic) IBOutlet UIButton *bt_website;
@property (strong, nonatomic) IBOutlet UIButton *bt_phone;
@property (strong, nonatomic) IBOutlet UIButton *bt_gender;
@property (strong, nonatomic) IBOutlet UIButton *bt_birthday;

@property (strong, nonatomic) IBOutlet UIImageView *img_male;
@property (strong, nonatomic) IBOutlet UIImageView *img_female;

@property (strong, nonatomic) IBOutlet UIDatePicker *Date;

//Button Tap
- (IBAction)maleTapped:(id)sender;
- (IBAction)femaleTapped:(id)sender;

- (IBAction)displaynameTapped:(id)sender;
- (IBAction)facebookTapped:(id)sender;
- (IBAction)passwordTapped:(id)sender;
- (IBAction)emailTapped:(id)sender;
- (IBAction)websiteTapped:(id)sender;
- (IBAction)phoneTapped:(id)sender;
- (IBAction)genderTapped:(id)sender;
- (IBAction)birthdayTapped:(id)sender;

- (IBAction)closedisplaynameTapped:(id)sender;
- (IBAction)closefacebookTapped:(id)sender;
- (IBAction)closeemailTapped:(id)sender;
- (IBAction)closewebsiteTapped:(id)sender;
- (IBAction)closephoneTapped:(id)sender;

@end
