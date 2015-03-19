//
//  PFEditDetailProfileViewController.m
//  Times Clinic
//
//  Created by Pariwat Promjai on 3/16/2558 BE.
//  Copyright (c) 2558 Pariwat Promjai. All rights reserved.
//

#import "PFEditDetailProfileViewController.h"

@interface PFEditDetailProfileViewController ()

@end

@implementation PFEditDetailProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.Api = [[PFApi alloc] init];
    self.Api.delegate = self;
    
    /* NavigationBar */
    [self setNavigationBar];
    
    /* Button */
    [self setButton];
    
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
    
    self.navigationItem.title = self.titlename;
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    
}

/* Set Button */

- (void)setButton {
    
    [self.bt_displayname.layer setMasksToBounds:YES];
    [self.bt_displayname.layer setCornerRadius:5.0f];
    
    [self.bt_password.layer setMasksToBounds:YES];
    [self.bt_password.layer setCornerRadius:5.0f];
    
    [self.bt_facebook.layer setMasksToBounds:YES];
    [self.bt_facebook.layer setCornerRadius:5.0f];
    
    [self.bt_email.layer setMasksToBounds:YES];
    [self.bt_email.layer setCornerRadius:5.0f];
    
    [self.bt_website.layer setMasksToBounds:YES];
    [self.bt_website.layer setCornerRadius:5.0f];
    
    [self.bt_phone.layer setMasksToBounds:YES];
    [self.bt_phone.layer setCornerRadius:5.0f];
    
    [self.bt_gender.layer setMasksToBounds:YES];
    [self.bt_gender.layer setCornerRadius:5.0f];
    
    [self.bt_birthday.layer setMasksToBounds:YES];
    [self.bt_birthday.layer setCornerRadius:5.0f];
    
}

/* Set View */

- (void)setView {
    
    if ([self.checkstatus isEqualToString:@"displayname"]) {

        self.tableView.tableHeaderView = self.displaynameView;
        
        self.txt_displayname.text = [self.obj objectForKey:@"display_name"];

    }
    
    if ([self.checkstatus isEqualToString:@"password"]) {
        
        self.tableView.tableHeaderView = self.passwordView;
        
    }
    
    if ([self.checkstatus isEqualToString:@"facebook"]) {
        
        self.tableView.tableHeaderView = self.facebookView;
        
        self.txt_facebook.text = [self.obj objectForKey:@"fb_name"];
        
    }
    
    if ([self.checkstatus isEqualToString:@"email"]) {
        
        self.tableView.tableHeaderView = self.emailView;
        
        self.txt_email.text = [self.obj objectForKey:@"email"];
        
    }
    
    if ([self.checkstatus isEqualToString:@"website"]) {
        
        self.tableView.tableHeaderView = self.websiteView;
        
        self.txt_website.text = [self.obj objectForKey:@"website"];
        
    }
    
    if ([self.checkstatus isEqualToString:@"phone"]) {
        
        self.tableView.tableHeaderView = self.phoneView;
        
        self.txt_phone.text = [self.obj objectForKey:@"mobile"];
        
    }
    
    if ([self.checkstatus isEqualToString:@"gender"]) {
        
        self.tableView.tableHeaderView = self.genderView;
        
        if ([[self.obj objectForKey:@"gender"] isEqualToString:@"Male"] || [[self.obj objectForKey:@"gender"] isEqualToString:@"male"]) {
            
            self.checkgender = @"male";
            
            self.img_male.hidden = NO;
            self.img_female.hidden = YES;
            
        } else {
            
            self.checkgender = @"female";
            
            self.img_male.hidden = YES;
            self.img_female.hidden = NO;
            
        }
        
    }
    
    if ([self.checkstatus isEqualToString:@"birthday"]) {
        
        self.tableView.tableHeaderView = self.birthdayView;
        
        NSString *myString1 = [[NSString alloc] initWithFormat:@"%@",[self.obj objectForKey:@"birth_date"]];
        NSString *mySmallerString = [myString1 substringToIndex:10];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date1 = [dateFormatter dateFromString:mySmallerString];
        
        [self.Date setDate:date1];
        
    }
    
}

/* Male Tap */

- (IBAction)maleTapped:(id)sender {

    self.checkgender = @"male";
    
    self.img_male.hidden = NO;
    self.img_female.hidden = YES;

}

/* Female Tap */

- (IBAction)femaleTapped:(id)sender {

    self.checkgender = @"female";
    
    self.img_male.hidden = YES;
    self.img_female.hidden = NO;

}

/* Display Name Tap */

- (IBAction)displaynameTapped:(id)sender {

    [self.Api userSetting:@"display_name" value:self.txt_displayname.text];

}

/* Facebook Tap */

- (IBAction)facebookTapped:(id)sender {

    [self.Api userSetting:@"fb_name" value:self.txt_facebook.text];

}

/* Password Tap */

- (IBAction)passwordTapped:(id)sender {

    if (![self.txt_newpassword.text isEqualToString:self.txt_confirmpassword.text]) {
        
        [[[UIAlertView alloc] initWithTitle:@"Times Clinic!"
                                    message:@"ป้อนรหัสผ่านเดียวกันสองครั้งเพื่อยืนยัน"
                                   delegate:nil
                          cancelButtonTitle:@"ตกลง"
                          otherButtonTitles:nil] show];
        
    } else {
        
        [self.Api changePassword:self.txt_password.text new_password:self.txt_newpassword.text confirm_password:self.txt_confirmpassword.text];
        
    }
    
}

/* Email Tap */

- (IBAction)emailTapped:(id)sender {

    [self.Api userSetting:@"email" value:self.txt_email.text];

}

/* Website Tap */

- (IBAction)websiteTapped:(id)sender {

    [self.Api userSetting:@"website" value:self.txt_website.text];

}

/* Phone Tap */

- (IBAction)phoneTapped:(id)sender {

    [self.Api userSetting:@"mobile" value:self.txt_phone.text];

}

/* Gender Tap */

- (IBAction)genderTapped:(id)sender {

    [self.Api userSetting:@"gender" value:self.checkgender];

}

/* Birthday Tap */

- (IBAction)birthdayTapped:(id)sender {
    
    NSDateFormatter *date = [[NSDateFormatter alloc] init];
    date.dateFormat = @"yyyy-MM-dd";
    
    NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [date setLocale:enUSPOSIXLocale];
    
    NSArray *temp = [[NSString stringWithFormat:@"%@",[date stringFromDate:self.Date.date]] componentsSeparatedByString:@""];
    NSString *dateString = [[NSString alloc] init];
    dateString = [[NSString alloc] initWithString:[temp objectAtIndex:0]];
    
    [self.Api userSetting:@"birth_date" value:dateString];

}

/* Close Display Name Tap */

- (IBAction)closedisplaynameTapped:(id)sender {

    self.txt_displayname.text = @"";
    
}

/* Close Facebook Tap */

- (IBAction)closefacebookTapped:(id)sender {

    self.txt_facebook.text = @"";
    
}

/* Close Email Tap */

- (IBAction)closeemailTapped:(id)sender {
    
    self.txt_email.text = @"";

}

/* Close Website Tap */

- (IBAction)closewebsiteTapped:(id)sender {
    
    self.txt_website.text = @"";

}

/* Close Phone Tap */

- (IBAction)closephoneTapped:(id)sender {
    
    self.txt_phone.text = @"";

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

/* Change Password API */

- (void)PFApi:(id)sender changPasswordResponse:(NSDictionary *)response {
    NSLog(@"changPassword %@",response);
    
    if ([[[response objectForKey:@"error"] objectForKey:@"type"] isEqualToString:@"Error"]) {

        [[[UIAlertView alloc] initWithTitle:@"Times Clinic!"
                                    message:[[response objectForKey:@"error"] objectForKey:@"message"]
                                   delegate:nil
                          cancelButtonTitle:@"ตกลง"
                          otherButtonTitles:nil] show];
        
    } else {

        [[[UIAlertView alloc] initWithTitle:@"Times Clinic!"
                                    message:@"บันทึกเรียบร้อย"
                                   delegate:self
                          cancelButtonTitle:@"ตกลง"
                          otherButtonTitles:nil] show];
        
    }
    
}

- (void)PFApi:(id)sender changPasswordErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        
        [self.delegate PFEditDetailProfileViewControllerBack];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        
        [self.txt_displayname resignFirstResponder];
        [self.txt_facebook resignFirstResponder];
        [self.txt_email resignFirstResponder];
        [self.txt_password resignFirstResponder];
        [self.txt_newpassword resignFirstResponder];
        [self.txt_confirmpassword resignFirstResponder];
        [self.txt_website resignFirstResponder];
        [self.txt_phone resignFirstResponder];
        
    }
}

@end
