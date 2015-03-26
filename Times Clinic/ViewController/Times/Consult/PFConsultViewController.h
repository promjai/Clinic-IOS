//
//  PFConsultViewController.h
//  Times Clinic
//
//  Created by Pariwat Promjai on 3/12/2558 BE.
//  Copyright (c) 2558 Pariwat Promjai. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PFApi.h"

@class MLTableAlert;

@protocol PFConsultViewControllerDelegate <NSObject>

- (void)PFConsultViewControllerBack:(NSString *)consult_id;

@end

@interface PFConsultViewController : UIViewController

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) PFApi *Api;
@property (strong, nonatomic) NSDictionary *obj;
@property (strong, nonatomic) NSMutableArray *arrObj;
@property (strong, nonatomic) NSMutableArray *dayArrObj;
@property (strong, nonatomic) NSMutableArray *dayArr;
@property (strong, nonatomic) NSMutableArray *sentDayArr;
@property (strong, nonatomic) NSMutableArray *hourArr;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *headerView;

@property (strong, nonatomic) MLTableAlert *alert;
@property (strong, nonatomic) IBOutlet UILabel *lb_day;

@property (strong, nonatomic) IBOutlet UILabel *lb_time;

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *phoneTextField;
@property (strong, nonatomic) IBOutlet UITextField *messageTextField;

@property (strong, nonatomic) IBOutlet UIButton *bt_cancel;
@property (strong, nonatomic) IBOutlet UIButton *bt_submit;

@property (strong, nonatomic) NSString *message;

//Button Tap
- (IBAction)dateTapped:(id)sender;
- (IBAction)timeTapped:(id)sender;
- (IBAction)cancelTapped:(id)sender;
- (IBAction)submitTapped:(id)sender;

@end
