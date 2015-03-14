//
//  PFTimesViewController.h
//  Times Clinic
//
//  Created by Pariwat Promjai on 2/27/2558 BE.
//  Copyright (c) 2558 Pariwat Promjai. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PFTimesCell.h"
#import "PFTimesDetailViewController.h"
#import "PFConsultViewController.h"
#import "PFEditCardViewController.h"

@interface PFTimesViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property (assign, nonatomic) id delegate;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

//no login
@property (strong, nonatomic) IBOutlet UIView *nologinView;
@property (strong, nonatomic) IBOutlet UIView *bg_nologinView;
@property (strong, nonatomic) IBOutlet UIButton *bt_register;
@property (strong, nonatomic) IBOutlet UILabel *txt_nologin;

//login
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *bg_headerView;
@property (strong, nonatomic) IBOutlet UIButton *bt_consult;

// button Tap
- (IBAction)registerTapped:(id)sender;
- (IBAction)consultTapped:(id)sender;

@end
