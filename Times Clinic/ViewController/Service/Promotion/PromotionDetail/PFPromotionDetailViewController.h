//
//  PFPromotionDetailViewController.h
//  Times Clinic
//
//  Created by Pariwat Promjai on 3/18/2558 BE.
//  Copyright (c) 2558 Pariwat Promjai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <FacebookSDK/FacebookSDK.h>
#import "DLImageLoader.h"
#import "UILabel+UILabelDynamicHeight.h"

#import "PFApi.h"

#import "PFLoginViewController.h"

@protocol PFPromotionDetailViewControllerDelegate <NSObject>

- (void)PFImageViewController:(id)sender viewPicture:(UIImage *)image;

@end

@interface PFPromotionDetailViewController : UIViewController

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) PFApi *Api;
@property (strong, nonatomic) NSMutableArray *arrObj;
@property (strong, nonatomic) NSDictionary *obj;

@property NSUserDefaults *promotionDetailOffline;

@property (strong, nonatomic) NSString *checkinternet;

@property (strong, nonatomic) PFLoginViewController *loginView;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *headerView;

@property (strong, nonatomic) IBOutlet UIImageView *img_thumbnails;
@property (strong, nonatomic) IBOutlet UILabel_UILabelDynamicHeight *lb_name;
@property (strong, nonatomic) IBOutlet UILabel *lb_condition;
@property (strong, nonatomic) IBOutlet UILabel_UILabelDynamicHeight *lb_detail;

@property (strong, nonatomic) IBOutlet UIView *redeemView;
@property (strong, nonatomic) IBOutlet UIButton *bt_redeem;

@property (strong, nonatomic) IBOutlet UIView *usedView;
@property (strong, nonatomic) IBOutlet UIButton *bt_used;

@property (strong, nonatomic) IBOutlet UIView *codeView;
@property (strong, nonatomic) IBOutlet UILabel *lb_code;
@property (strong, nonatomic) IBOutlet UILabel *lb_time;

//Button Tap
- (IBAction)fullimgTapped:(id)sender;
- (IBAction)redeemTapped:(id)sender;

@end
