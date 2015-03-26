//
//  PFUpdateViewController.h
//  Times Clinic
//
//  Created by Pariwat Promjai on 2/27/2558 BE.
//  Copyright (c) 2558 Pariwat Promjai. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PFApi.h"

#import "PFUpdateCell.h"
#import "PFLoginViewController.h"
#import "PFSettingViewController.h"
#import "PFNotificationViewController.h"
#import "PFUpdateDetailViewController.h"
#import "PFPromotionDetailViewController.h"

@protocol PFUpdateViewControllerDelegate <NSObject>

- (void)PFImageViewController:(id)sender viewPicture:(UIImage *)image;

@end

@interface PFUpdateViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) PFApi *Api;
@property (strong, nonatomic) NSMutableArray *arrObj;

@property (strong, nonatomic) NSString *paging;

@property (strong, nonatomic) PFLoginViewController *loginView;

@property (strong, nonatomic) NSString *checkinternet;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *headerView;

@end
