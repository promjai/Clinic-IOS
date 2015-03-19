//
//  PFContactViewController.h
//  Times Clinic
//
//  Created by Pariwat Promjai on 2/27/2558 BE.
//  Copyright (c) 2558 Pariwat Promjai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "DLImageLoader.h"

#import "PFApi.h"

#import "PFMapViewController.h"
#import "PFCommentViewController.h"

@interface PFContactViewController : UIViewController <MFMailComposeViewControllerDelegate,UIActionSheetDelegate>

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) PFApi *Api;
@property (strong, nonatomic) NSDictionary *obj;

@property NSUserDefaults *contactOffline;

@property (strong, nonatomic) IBOutlet UIView *waitView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@property (strong, nonatomic) IBOutlet UIView *NoInternetView;
@property (strong, nonatomic) NSString *checkinternet;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIImageView *img_map;
@property (strong, nonatomic) IBOutlet UIView *bg_buttonView;
@property (strong, nonatomic) IBOutlet UIButton *bt_comment;

@property (strong, nonatomic) IBOutlet UILabel *txt_phone;
@property (strong, nonatomic) IBOutlet UILabel *txt_website;
@property (strong, nonatomic) IBOutlet UILabel *txt_email;
@property (strong, nonatomic) IBOutlet UILabel *txt_facebook;
@property (strong, nonatomic) IBOutlet UILabel *txt_line;

// button Tap
- (IBAction)mapTapped:(id)sender;
- (IBAction)phoneTapped:(id)sender;
- (IBAction)websiteTapped:(id)sender;
- (IBAction)emailTapped:(id)sender;
- (IBAction)facebookTapped:(id)sender;
- (IBAction)lineTapped:(id)sender;
- (IBAction)commentTapped:(id)sender;
- (IBAction)powerbyTapped:(id)sender;

@end
