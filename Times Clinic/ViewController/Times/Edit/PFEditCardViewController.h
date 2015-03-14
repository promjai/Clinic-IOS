//
//  PFEditCardViewController.h
//  Times Clinic
//
//  Created by Pariwat Promjai on 3/11/2558 BE.
//  Copyright (c) 2558 Pariwat Promjai. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PFEditCardDetailViewController.h"

@interface PFEditCardViewController : UIViewController

@property (assign, nonatomic) id delegate;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;

// button Tap
- (IBAction)editNameTapped:(id)sender;
- (IBAction)editHNTapped:(id)sender;

@end
