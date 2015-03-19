//
//  PFEditCardViewController.h
//  Times Clinic
//
//  Created by Pariwat Promjai on 3/11/2558 BE.
//  Copyright (c) 2558 Pariwat Promjai. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PFApi.h"

#import "PFEditCardDetailViewController.h"

@protocol PFEditCardViewControllerDelegate <NSObject>

- (void)PFEditCardViewControllerBack;

@end

@interface PFEditCardViewController : UIViewController

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) PFApi *Api;
@property (strong, nonatomic) NSDictionary *obj;

@property NSUserDefaults *meOffline;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;

@property (strong, nonatomic) IBOutlet UILabel *lb_name;
@property (strong, nonatomic) IBOutlet UILabel *lb_hn;

// button Tap
- (IBAction)editNameTapped:(id)sender;
- (IBAction)editHNTapped:(id)sender;

@end
