//
//  PFEditCardDetailViewController.m
//  Times Clinic
//
//  Created by Pariwat Promjai on 3/11/2558 BE.
//  Copyright (c) 2558 Pariwat Promjai. All rights reserved.
//

#import "PFEditCardDetailViewController.h"

@interface PFEditCardDetailViewController ()

@end

@implementation PFEditCardDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* NavigationBar */
    [self setNavigationBar];
    
    /* View */
    [self setView];
    
    if ([self.titlename isEqualToString:@"ชื่อ"]) {
        
        self.tableView.tableHeaderView = self.editNameView;
    
    } else if ([self.titlename isEqualToString:@"เลขบัตร"]) {
    
        self.tableView.tableHeaderView = self.editHNView;
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

/* Set NavigationBar */

- (void)setNavigationBar {
    
    self.navigationItem.title = self.titlename;
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    
}

/* Set View */

- (void)setView {


}

@end
