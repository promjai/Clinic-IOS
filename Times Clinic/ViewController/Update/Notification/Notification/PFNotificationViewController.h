//
//  PFNotificationViewController.h
//  Times Clinic
//
//  Created by Pariwat Promjai on 3/24/2558 BE.
//  Copyright (c) 2558 Pariwat Promjai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "PFNotificationCell.h"

#import "PFApi.h"

@protocol PFNotificationViewControllerDelegate <NSObject>

- (void)PFImageViewController:(id)sender viewPicture:(UIImage *)image;
- (void)PFNotificationViewControllerBack;

@end

@interface PFNotificationViewController : UIViewController

@property AFHTTPRequestOperationManager *manager;
@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) PFApi *Api;

@property NSUserDefaults *notifyOffline;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *waitView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@property (strong, nonatomic) NSMutableArray *arrObj;

@property (retain, nonatomic) NSString *paging;
@property (strong, nonatomic) NSString *checkinternet;

@end
