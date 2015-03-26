//
//  PFTimesDetailViewController.m
//  Times Clinic
//
//  Created by Pariwat Promjai on 3/12/2558 BE.
//  Copyright (c) 2558 Pariwat Promjai. All rights reserved.
//

#import "PFTimesDetailViewController.h"

@interface PFTimesDetailViewController ()

@end

@implementation PFTimesDetailViewController

NSString *onclick;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.waitView];
    
    self.Api = [[PFApi alloc] init];
    self.Api.delegate = self;
    
    /* NavigationBar */
    [self setNavigationBar];
    
    /* API */
    [self.Api appointById:[self.obj objectForKey:@"id"]];
    
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
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    
    if ([self.status isEqualToString:@""]) {
    
        self.navigationItem.title = @"ประวัติ";
        self.navigationItem.rightBarButtonItem = nil;
        
    } else {
    
        self.navigationItem.title = @"นัดหมาย";
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(delete)];
        self.navigationItem.rightBarButtonItem = rightButton;
    
    }
    
}

/* Delete Onclick */

- (void)delete {

    onclick = @"delete";
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"ยกเลิกนัดหมายหรือไม่"
                                                      message:@"ท่านสามารถสร้างนัดหมายได้ในภายหลัง"
                                                     delegate:self
                                            cancelButtonTitle:@"ไม่ใช่"
                                            otherButtonTitles:@"ใช่",nil];
    [message show];

}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {

        if ([onclick isEqualToString:@"pendingconfirm"]) {
            [self.Api appointStatus:@"confirmed" appoint_id:[self.obj objectForKey:@"id"]];
        }
        
    } else if (buttonIndex == 1) {
        
        [self.Api appointStatus:@"cancelled" appoint_id:[self.obj objectForKey:@"id"]];
        
    }
    
}

/* Set View */

- (void)setView {
    
    [self.bt_newappointment.layer setMasksToBounds:YES];
    [self.bt_newappointment.layer setCornerRadius:5.0f];
    
    [self.bt_pendingappointment.layer setMasksToBounds:YES];
    [self.bt_pendingappointment.layer setCornerRadius:5.0f];
    
    [self.bt_pendingconfirm.layer setMasksToBounds:YES];
    [self.bt_pendingconfirm.layer setCornerRadius:5.0f];
    
    [self.bt_confirmappointment.layer setMasksToBounds:YES];
    [self.bt_confirmappointment.layer setCornerRadius:5.0f];
    
    [self.bt_missedappointment.layer setMasksToBounds:YES];
    [self.bt_missedappointment.layer setCornerRadius:5.0f];
    
    self.tableView.tableHeaderView = self.headerView;
    
    //date
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    
    NSDateFormatter *monthFormatter = [[NSDateFormatter alloc] init];
    [monthFormatter setDateFormat:@"MMM"];
    
    NSDateFormatter *getDateFormatter = [[NSDateFormatter alloc] init];
    [getDateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *dayOfMonth = [[NSString alloc] initWithFormat:@"%@",[[self.objTimes objectForKey:@"date_time"] substringToIndex:10]];
    NSDate *date = [getDateFormatter dateFromString:dayOfMonth];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    int year = [components year];
    int day = [components day];
    
    self.lb_date.text = [[NSString alloc] initWithFormat:@"%@ %d %@ %d",[dateFormatter stringFromDate:date],day,[monthFormatter stringFromDate:date],year];
    
    //detail
    
    self.lb_detail.frame = CGRectMake(self.lb_detail.frame.origin.x, self.lb_detail.frame.origin.y+self.lb_date.frame.size.height-20, self.lb_detail.frame.size.width, self.lb_detail.frame.size.height);
    
    self.lb_detail.text = [self.objTimes objectForKey:@"detail"];
    
    CGRect frame = self.lb_detail.frame;
    frame.size = [self.lb_detail sizeOfMultiLineLabel];
    [self.lb_detail sizeOfMultiLineLabel];
    
    [self.lb_detail setFrame:frame];
    int lines = self.lb_detail.frame.size.height/15;
    self.lb_detail.numberOfLines = lines;
    
    UILabel *descText = [[UILabel alloc] initWithFrame:frame];
    descText.textColor = RGB(153, 153, 153);
    descText.text = self.lb_detail.text;
    descText.numberOfLines = lines;
    [descText setFont:[UIFont systemFontOfSize:15]];
    self.lb_detail.alpha = 0;
    [self.headerView addSubview:descText];
    
    self.headerView.frame = CGRectMake(self.headerView.frame.origin.x, self.headerView.frame.origin.y, self.headerView.frame.size.width, self.headerView.frame.size.height);
    
    if ([[self.objTimes objectForKey:@"status"] isEqualToString:@"new"]) {
        
        self.tableView.tableFooterView = self.newsView;
    
    } else if ([[self.objTimes objectForKey:@"status"] isEqualToString:@"pending"]) {
        
        self.tableView.tableFooterView = self.pendingView;
        
    } else if ([[self.objTimes objectForKey:@"status"] isEqualToString:@"confirmed"]) {
        
        self.tableView.tableFooterView = self.confirmedView;
        
    } else if ([[self.objTimes objectForKey:@"status"] isEqualToString:@"missed"]) {
        
        self.tableView.tableFooterView = self.missedView;
        
    }
    
}

/* Apppoint By ID API */

- (void)PFApi:(id)sender apppointByIdResponse:(NSDictionary *)response {
    NSLog(@"%@",response);
    
    self.objTimes = response;
    
    [self.waitView removeFromSuperview];
    
    /* View */
    [self setView];
    
}

- (void)PFApi:(id)sender apppointByIdErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
    
    [self.waitView removeFromSuperview];
    
    /* View */
    [self setView];
    
}

/* Apppoint Status API */

- (void)PFApi:(id)sender apppointStatusResponse:(NSDictionary *)response {
    NSLog(@"%@",response);
    
    if ([onclick isEqualToString:@"delete"]) {
    
        [self.delegate PFTimesDetailViewControllerBack];
        [self.navigationController popViewControllerAnimated:YES];
        
    } else if ([onclick isEqualToString:@"pendingconfirm"]) {
    
        /* API */
        [self.Api appointById:[self.obj objectForKey:@"id"]];
        
    } else if ([onclick isEqualToString:@"newappointment"]) {
        
        PFConsultViewController *consultView = [[PFConsultViewController alloc] init];
        if(IS_WIDESCREEN) {
            consultView = [[PFConsultViewController alloc] initWithNibName:@"PFConsultViewController_Wide" bundle:nil];
        } else {
            consultView = [[PFConsultViewController alloc] initWithNibName:@"PFConsultViewController" bundle:nil];
        }
        consultView.delegate = self;
        consultView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:consultView animated:YES];
        
    } else if ([onclick isEqualToString:@"pendingappointment"]) {
        
        PFConsultViewController *consultView = [[PFConsultViewController alloc] init];
        if(IS_WIDESCREEN) {
            consultView = [[PFConsultViewController alloc] initWithNibName:@"PFConsultViewController_Wide" bundle:nil];
        } else {
            consultView = [[PFConsultViewController alloc] initWithNibName:@"PFConsultViewController" bundle:nil];
        }
        consultView.delegate = self;
        consultView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:consultView animated:YES];
        
    } else if ([onclick isEqualToString:@"confirmappointment"]) {
        
        PFConsultViewController *consultView = [[PFConsultViewController alloc] init];
        if(IS_WIDESCREEN) {
            consultView = [[PFConsultViewController alloc] initWithNibName:@"PFConsultViewController_Wide" bundle:nil];
        } else {
            consultView = [[PFConsultViewController alloc] initWithNibName:@"PFConsultViewController" bundle:nil];
        }
        consultView.delegate = self;
        consultView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:consultView animated:YES];
        
    }
    
}

- (void)PFApi:(id)sender apppointStatusErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
}

/* New Appointment Tap */

- (IBAction)newappointmentTapped:(id)sender {
    
    onclick = @"newappointment";
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:nil
                                                      message:@"ยกเลิกนัดหมายเดิมหรือไม่"
                                                     delegate:self
                                            cancelButtonTitle:@"ไม่ใช่"
                                            otherButtonTitles:@"ใช่",nil];
    [message show];
    
}

/* Pending Appointment Tap */

- (IBAction)pendingappointmentTapped:(id)sender {
    
    onclick = @"pendingappointment";
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:nil
                                                      message:@"ยกเลิกนัดหมายเดิมหรือไม่"
                                                     delegate:self
                                            cancelButtonTitle:@"ไม่ใช่"
                                            otherButtonTitles:@"ใช่",nil];
    [message show];
    
}

/* Pending Confirm Tap */

- (IBAction)pendingconfirmTapped:(id)sender {
    
    onclick = @"pendingconfirm";
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:nil
                                                      message:@"ยืนยันนัดหมายเรียบร้อย ขอบคุณค่ะ"
                                                     delegate:self
                                            cancelButtonTitle:@"ตกลง"
                                            otherButtonTitles:nil];
    [message show];
    
}

/* Confirm Appointment Tap */

- (IBAction)confirmappointmentTapped:(id)sender {
    
    onclick = @"confirmappointment";
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:nil
                                                      message:@"ยกเลิกนัดหมายเดิมหรือไม่"
                                                     delegate:self
                                            cancelButtonTitle:@"ไม่ใช่"
                                            otherButtonTitles:@"ใช่",nil];
    [message show];
    
}

/* Missed Appointment Tap */

- (IBAction)missedappointmentTapped:(id)sender {
    
    onclick = @"missedappointment";
    
    [self.Api appointStatus:@"cancelled" appoint_id:[self.obj objectForKey:@"id"]];
    
    PFConsultViewController *consultView = [[PFConsultViewController alloc] init];
    if(IS_WIDESCREEN) {
        consultView = [[PFConsultViewController alloc] initWithNibName:@"PFConsultViewController_Wide" bundle:nil];
    } else {
        consultView = [[PFConsultViewController alloc] initWithNibName:@"PFConsultViewController" bundle:nil];
    }
    consultView.delegate = self;
    consultView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:consultView animated:YES];
    
}

/* Consult Back */

- (void)PFConsultViewControllerBack:(NSString *)consult_id {
    
    if ([consult_id intValue] != 0) {
    
        /* API */
        [self.Api appointById:consult_id];
        
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        // 'Back' button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        if([self.delegate respondsToSelector:@selector(PFTimesDetailViewControllerBack)]){
            [self.delegate PFTimesDetailViewControllerBack];
        }
    }
    
}

@end
