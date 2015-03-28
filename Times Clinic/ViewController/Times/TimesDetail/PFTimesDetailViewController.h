//
//  PFTimesDetailViewController.h
//  Times Clinic
//
//  Created by Pariwat Promjai on 3/12/2558 BE.
//  Copyright (c) 2558 Pariwat Promjai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UILabel+UILabelDynamicHeight.h"

#import "PFApi.h"

#import "PFConsultViewController.h"

@protocol PFTimesDetailViewControllerDelegate <NSObject>

- (void)PFTimesDetailViewControllerBack;

@end

@interface PFTimesDetailViewController : UIViewController

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) PFApi *Api;
@property (strong, nonatomic) NSDictionary *obj;
@property (strong, nonatomic) NSDictionary *objTimes;

@property (strong, nonatomic) IBOutlet UIView *waitView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;

@property (strong, nonatomic) IBOutlet UIView *newsView;
@property (strong, nonatomic) IBOutlet UIView *pendingView;
@property (strong, nonatomic) IBOutlet UIView *confirmedView;
@property (strong, nonatomic) IBOutlet UIView *missedView;

@property (weak, nonatomic) IBOutlet UILabel *lb_date;
@property (weak, nonatomic) IBOutlet UILabel_UILabelDynamicHeight *lb_detail;

@property (strong, nonatomic) IBOutlet UIButton *bt_newappointment;
@property (strong, nonatomic) IBOutlet UIButton *bt_pendingappointment;
@property (strong, nonatomic) IBOutlet UIButton *bt_pendingconfirm;
@property (strong, nonatomic) IBOutlet UIButton *bt_confirmappointment;
@property (strong, nonatomic) IBOutlet UIButton *bt_missedappointment;

@property (strong, nonatomic) NSString *status;

// button Tap
- (IBAction)newappointmentTapped:(id)sender;
- (IBAction)pendingappointmentTapped:(id)sender;
- (IBAction)pendingconfirmTapped:(id)sender;
- (IBAction)confirmappointmentTapped:(id)sender;
- (IBAction)missedappointmentTapped:(id)sender;

@end
