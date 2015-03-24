//
//  PFConsultViewController.h
//  Times Clinic
//
//  Created by Pariwat Promjai on 3/12/2558 BE.
//  Copyright (c) 2558 Pariwat Promjai. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PFApi.h"

@interface PFConsultViewController : UIViewController

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) PFApi *Api;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *headerView;

@property (strong, nonatomic) IBOutlet UIView *timeView;

@property (strong, nonatomic) IBOutlet UIButton *bt_cancel;
@property (strong, nonatomic) IBOutlet UIButton *bt_submit;

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UIDatePicker *timePicker;

//Button Tap
- (IBAction)dateTapped:(id)sender;
- (IBAction)timeTapped:(id)sender;
- (IBAction)cancelTapped:(id)sender;
- (IBAction)submitTapped:(id)sender;

@end
