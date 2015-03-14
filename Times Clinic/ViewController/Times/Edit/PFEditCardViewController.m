//
//  PFEditCardViewController.m
//  Times Clinic
//
//  Created by Pariwat Promjai on 3/11/2558 BE.
//  Copyright (c) 2558 Pariwat Promjai. All rights reserved.
//

#import "PFEditCardViewController.h"

@interface PFEditCardViewController ()

@end

@implementation PFEditCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* NavigationBar */
    [self setNavigationBar];
    
    self.tableView.tableHeaderView = self.headerView;
    
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
    
    self.navigationItem.title = @"แก้ไข";
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    
}

/* Edit Name Tap */

- (IBAction)editNameTapped:(id)sender {

    PFEditCardDetailViewController *editcarddetailView = [[PFEditCardDetailViewController alloc] init];
    if(IS_WIDESCREEN) {
        editcarddetailView = [[PFEditCardDetailViewController alloc] initWithNibName:@"PFEditCardDetailViewController_Wide" bundle:nil];
    } else {
        editcarddetailView = [[PFEditCardDetailViewController alloc] initWithNibName:@"PFEditCardDetailViewController" bundle:nil];
    }
    editcarddetailView.delegate = self;
    editcarddetailView.titlename = @"ชื่อ";
    editcarddetailView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:editcarddetailView animated:YES];
    
}

/* Edit HN Tap */

- (IBAction)editHNTapped:(id)sender {
    
    PFEditCardDetailViewController *editcarddetailView = [[PFEditCardDetailViewController alloc] init];
    if(IS_WIDESCREEN) {
        editcarddetailView = [[PFEditCardDetailViewController alloc] initWithNibName:@"PFEditCardDetailViewController_Wide" bundle:nil];
    } else {
        editcarddetailView = [[PFEditCardDetailViewController alloc] initWithNibName:@"PFEditCardDetailViewController" bundle:nil];
    }
    editcarddetailView.delegate = self;
    editcarddetailView.titlename = @"เลขบัตร";
    editcarddetailView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:editcarddetailView animated:YES];

}

@end
