//
//  PFEditCardDetailViewController.h
//  Times Clinic
//
//  Created by Pariwat Promjai on 3/11/2558 BE.
//  Copyright (c) 2558 Pariwat Promjai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PFEditCardDetailViewController : UIViewController

@property (assign, nonatomic) id delegate;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSString *titlename;

@property (strong, nonatomic) IBOutlet UIView *editNameView;
@property (strong, nonatomic) IBOutlet UIView *editHNView;

@end
