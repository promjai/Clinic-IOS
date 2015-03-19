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
    
    self.Api = [[PFApi alloc] init];
    self.Api.delegate = self;
    
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

-(NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

/* Set NavigationBar */

- (void)setNavigationBar {
    
    self.navigationItem.title = self.titlename;
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    
}

/* Set View */

- (void)setView {

    [self.bt_name.layer setMasksToBounds:YES];
    [self.bt_name.layer setCornerRadius:5.0f];
    
    [self.bt_hn.layer setMasksToBounds:YES];
    [self.bt_hn.layer setCornerRadius:5.0f];
    
    self.txt_name.text = [self.obj objectForKey:@"display_name"];
    self.txt_hn.text = [self.obj objectForKey:@"hn_number"];
    
}

/* Name Tap */

- (IBAction)nameTapped:(id)sender {

    [self.Api userSetting:@"display_name" value:self.txt_name.text];
    
}

/* Name Tap */

- (IBAction)hnTapped:(id)sender {

    if (![self.txt_password.text isEqualToString:@""]) {
    
        [self.Api checkPassword:self.txt_password.text];
    
    } else {
    
        [[[UIAlertView alloc] initWithTitle:@"Times Clinic!"
                                    message:@"กรุณาใส่รหัสผ่าน"
                                   delegate:nil
                          cancelButtonTitle:@"ตกลง"
                          otherButtonTitles:nil] show];
        
    }
    
}

/* Check Password API */

- (void)PFApi:(id)sender checkPasswordResponse:(NSDictionary *)response {
    NSLog(@"%@",response);
    
    if ([[[response objectForKey:@"error"] objectForKey:@"type"] isEqualToString:@"Error"]) {
        
        [[[UIAlertView alloc] initWithTitle:@"Times Clinic!"
                                    message:@"รหัสผ่านไม่ถูกต้อง กรุณาใส่รหัสผ่านใหม่"
                                   delegate:nil
                          cancelButtonTitle:@"ตกลง"
                          otherButtonTitles:nil] show];
        
    } else {
        
        [self.Api userSetting:@"hn_number" value:self.txt_hn.text];
        
    }
    
}

- (void)PFApi:(id)sender checkPasswordErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
}

/* User Setting API */

- (void)PFApi:(id)sender userSettingResponse:(NSDictionary *)response {
    NSLog(@"%@",response);
    
    if ([[response objectForKey:@"success"] integerValue] == 1) {
        
        [[[UIAlertView alloc] initWithTitle:@"Times Clinic!"
                                    message:@"บันทึกเรียบร้อย"
                                   delegate:self
                          cancelButtonTitle:@"ตกลง"
                          otherButtonTitles:nil] show];
        
    }
    
}

- (void)PFApi:(id)sender userSettingErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        
        [self.delegate PFEditCardDetailViewControllerBack];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        
        [self.txt_name resignFirstResponder];
        
    }
}

@end
