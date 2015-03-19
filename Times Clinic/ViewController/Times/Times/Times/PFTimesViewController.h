//
//  PFTimesViewController.h
//  Times Clinic
//
//  Created by Pariwat Promjai on 2/27/2558 BE.
//  Copyright (c) 2558 Pariwat Promjai. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PFApi.h"

#import "PFTimesCell.h"
#import "PFLoginViewController.h"
#import "PFTimesDetailViewController.h"
#import "PFConsultViewController.h"
#import "PFEditCardViewController.h"

@interface PFTimesViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) PFApi *Api;
@property (strong, nonatomic) NSDictionary *obj;
@property (strong, nonatomic) NSMutableArray *arrObj;

@property NSUserDefaults *meOffline;
@property NSUserDefaults *timesOffline;

@property (strong, nonatomic) NSString *paging;

@property (strong, nonatomic) PFLoginViewController *loginView;

@property (strong, nonatomic) UIRefreshControl *refreshControl;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

//no login
@property (strong, nonatomic) IBOutlet UIView *nologinView;
@property (strong, nonatomic) IBOutlet UIView *bg_nologinView;
@property (strong, nonatomic) IBOutlet UIButton *bt_register;
@property (strong, nonatomic) IBOutlet UILabel *lb_nologin;

//login
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *bg_headerView;

@property (strong, nonatomic) IBOutlet UITextField *txt_name;
@property (strong, nonatomic) IBOutlet UITextField *txt_hn;

@property (strong, nonatomic) IBOutlet UIButton *bt_consult;

// button Tap
- (IBAction)editTapped:(id)sender;
- (IBAction)registerTapped:(id)sender;
- (IBAction)consultTapped:(id)sender;

@end
