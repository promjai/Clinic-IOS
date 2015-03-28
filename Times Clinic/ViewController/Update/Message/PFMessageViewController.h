//
//  PFMessageViewController.h
//  Times Clinic
//
//  Created by Pariwat Promjai on 3/27/2558 BE.
//  Copyright (c) 2558 Pariwat Promjai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UILabel+UILabelDynamicHeight.h"

@protocol PFMessageViewControllerDelegate <NSObject>

- (void)PFMessageViewControllerBack;

@end

@interface PFMessageViewController : UIViewController

@property (assign, nonatomic) id delegate;

@property (retain, nonatomic) NSString *message;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *headerView;

@property (strong, nonatomic) IBOutlet UILabel_UILabelDynamicHeight *lb_detail;

@end
