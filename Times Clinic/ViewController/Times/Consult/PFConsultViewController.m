//
//  PFConsultViewController.m
//  Times Clinic
//
//  Created by Pariwat Promjai on 3/12/2558 BE.
//  Copyright (c) 2558 Pariwat Promjai. All rights reserved.
//

#import "PFConsultViewController.h"

@interface PFConsultViewController ()

@end

@implementation PFConsultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* NavigationBar */
    [self setNavigationBar];
    
    /* View */
    [self setView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

/* Set NavigationBar */

- (void)setNavigationBar {
    
    self.navigationItem.title = @"นัดปรึกษาแพทย์";
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    
}

/* Set View */

- (void)setView {
    
    self.tableView.tableHeaderView = self.headerView;
    
    [self.bt_cancel.layer setMasksToBounds:YES];
    [self.bt_cancel.layer setCornerRadius:5.0f];
    
    [self.bt_submit.layer setMasksToBounds:YES];
    [self.bt_submit.layer setCornerRadius:5.0f];
    
}

@end
