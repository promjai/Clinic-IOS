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
    
    self.Api = [[PFApi alloc] init];
    self.Api.delegate = self;
    
    /* API */
    [self.Api getDateTimes];
    
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
    
//    NSTimeInterval interval  = [[NSDate date] timeIntervalSince1970] ;
//    int myInt = (int)interval+900;
//    NSString *dateSave = [[NSString alloc] initWithFormat:@"%d",myInt];
//    
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[dateSave intValue]];
//    
//    self.timePicker.minimumDate = date;
    
}

- (void)PFApi:(id)sender getDateTimesResponse:(NSDictionary *)response {
    NSLog(@"%@",response);
    
    self.timePicker.minuteInterval = [[response objectForKey:@"repeat"] integerValue];
    
}

- (void)PFApi:(id)sender getDateTimesErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
}

/* Date Tap */

- (IBAction)dateTapped:(id)sender {

    

}

/* Time Tap */

- (IBAction)timeTapped:(id)sender {

    [self.view addSubview:self.timeView];
    
}

@end
