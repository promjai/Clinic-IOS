//
//  PFEditCardDetailViewController.h
//  Times Clinic
//
//  Created by Pariwat Promjai on 3/11/2558 BE.
//  Copyright (c) 2558 Pariwat Promjai. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PFApi.h"

@protocol PFEditCardDetailViewControllerDelegate <NSObject>

- (void)PFEditCardDetailViewControllerBack;

@end

@interface PFEditCardDetailViewController : UIViewController

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) PFApi *Api;
@property (strong, nonatomic) NSDictionary *obj;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSString *titlename;

@property (strong, nonatomic) IBOutlet UIView *editNameView;
@property (strong, nonatomic) IBOutlet UIView *editHNView;

@property (strong, nonatomic) IBOutlet UITextField *txt_name;
@property (strong, nonatomic) IBOutlet UITextField *txt_hn;
@property (strong, nonatomic) IBOutlet UITextField *txt_password;

@property (strong, nonatomic) IBOutlet UIButton *bt_name;
@property (strong, nonatomic) IBOutlet UIButton *bt_hn;

// button Tap
- (IBAction)nameTapped:(id)sender;
- (IBAction)hnTapped:(id)sender;

@end
