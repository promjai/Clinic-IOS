//
//  PFConsultViewController.m
//  Times Clinic
//
//  Created by Pariwat Promjai on 3/12/2558 BE.
//  Copyright (c) 2558 Pariwat Promjai. All rights reserved.
//

#import "PFConsultViewController.h"
#import "MLTableAlert.h"

@interface PFConsultViewController ()

@end

@implementation PFConsultViewController

NSString *sentDate;
NSString *sentTime;
NSString *consult_id;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.0f/255.0f green:175.0f/255.0f blue:0.0f/255.0f alpha:1.0f]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.arrObj = [[NSMutableArray alloc] init];
    self.dayArrObj = [[NSMutableArray alloc] init];
    self.dayArr = [[NSMutableArray alloc] init];
    self.sentDayArr = [[NSMutableArray alloc] init];
    self.hourArr = [[NSMutableArray alloc] init];
    
    self.Api = [[PFApi alloc] init];
    self.Api.delegate = self;
    
    /* API */
    [self.Api user];
    
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
    
    self.messageTextField.text = self.message;
    
}

/* Set Date */

- (void)setDate {

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EE"];
    
    NSDateFormatter *monthFormatter = [[NSDateFormatter alloc] init];
    [monthFormatter setDateFormat:@"MMMM"];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    int year = [components year];
    int month = [components month];
    int day = [components day];
    
    NSDateFormatter *getDateFormatter = [[NSDateFormatter alloc] init];
    [getDateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    //จำนวนวันในเดือนนี้
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSRange daysRange = [currentCalendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[NSDate date]];
    
    for (int i = day; i <= daysRange.length; i++) {
        
        NSString *dayOfMonth = [[NSString alloc] initWithFormat:@"%d-%d-%d",year,month,i];
        NSDate *date = [getDateFormatter dateFromString:dayOfMonth];
        
        NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:date];
        int weekday = [comps weekday];
        
        for (int d = 0; d < [self.dayArrObj count]; d++) {
            
            if (weekday == [[self.dayArrObj objectAtIndex:d] integerValue]) {
                
                NSString *sentdayOfMonth = [[NSString alloc] initWithFormat:@"%d-%d-%d",year,month,i];
                NSDate *sentdate = [getDateFormatter dateFromString:sentdayOfMonth];
                NSString *sentdateStr = [getDateFormatter stringFromDate:sentdate];
                
                NSString *dayOfMonth = [[NSString alloc] initWithFormat:@"%@ %d %@ %d",[dateFormatter stringFromDate:date],i,[monthFormatter stringFromDate:[NSDate date]],year];
                
                [self.sentDayArr addObject:sentdateStr];
                [self.dayArr addObject:dayOfMonth];
                
            }
            
        }
        
    }
    
    //จำนวนวันในเดือนถัดไป
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:1];
    NSRange daysRangenextMonth = [currentCalendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[currentCalendar dateByAddingComponents:dateComponents toDate:[NSDate date] options:0]];
    
    for (int i = 1; i <= daysRangenextMonth.length; i++) {
        
        NSString *dayOfNextMonth = [[NSString alloc] initWithFormat:@"%d-%d-%d",year,month+1,i];
        NSDate *dateNextMonth = [getDateFormatter dateFromString:dayOfNextMonth];
        
        NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:dateNextMonth];
        int weekdayNextMonth = [comps weekday];
        
        for (int d = 0; d < [self.dayArrObj count]; d++) {
            
            if (weekdayNextMonth == [[self.dayArrObj objectAtIndex:d] integerValue]) {
                
                NSString *sentdayOfNextMonth = [[NSString alloc] initWithFormat:@"%d-%d-%d",year,month+1,i];
                NSDate *sentdateNextMonth = [getDateFormatter dateFromString:sentdayOfNextMonth];
                NSString *sentdateNextMonthStr = [getDateFormatter stringFromDate:sentdateNextMonth];
                
                NSString *dayOfNextMonth = [[NSString alloc] initWithFormat:@"%@ %d %@ %d",[dateFormatter stringFromDate:dateNextMonth],i,[monthFormatter stringFromDate:dateNextMonth],year];
                
                [self.sentDayArr addObject:sentdateNextMonthStr];
                [self.dayArr addObject:dayOfNextMonth];
                
            }
            
        }
        
    }
    
}

/* Set Time */

- (void)setTime {

    for (int i = [[[self.obj objectForKey:@"time_start"] substringToIndex:2] integerValue]; i < [[[self.obj objectForKey:@"time_end"] substringToIndex:2] integerValue]; i++) {
    
        for (int c = 0; c < 60/[[self.obj objectForKey:@"repeat"] integerValue]; c++) {
        
            NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
            [timeFormatter setDateFormat:@"HH:mm"];
            
            NSString *timeStr = [[NSString alloc] initWithFormat:@"%d:%d",i,c*[[self.obj objectForKey:@"repeat"] integerValue]];
            
            NSDate *dateTime = [timeFormatter dateFromString:timeStr];
            NSString *sentdateNextMonthStr = [timeFormatter stringFromDate:dateTime];
            
            [self.hourArr addObject:sentdateNextMonthStr];
            
        }
    
    }

}

/* User API */

- (void)PFApi:(id)sender userResponse:(NSDictionary *)response {
    NSLog(@"%@",response);
    
    self.nameTextField.text = [response objectForKey:@"display_name"];
    self.phoneTextField.text = [response objectForKey:@"mobile"];
    
}

- (void)PFApi:(id)sender userErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
}

/* DateTimes API */

- (void)PFApi:(id)sender getDateTimesResponse:(NSDictionary *)response {
    NSLog(@"%@",response);
    
    self.obj = response;
    
    for (int i=0; i<[[response objectForKey:@"date"] count]; ++i) {
        
        if ([[[response objectForKey:@"date"] objectAtIndex:i] isEqualToString:@"Sun"]) {
            
            [self.dayArrObj addObject:@"1"];
            
        } else if ([[[response objectForKey:@"date"] objectAtIndex:i] isEqualToString:@"Mon"]) {
        
            [self.dayArrObj addObject:@"2"];
            
        } else if ([[[response objectForKey:@"date"] objectAtIndex:i] isEqualToString:@"Tue"]) {
            
            [self.dayArrObj addObject:@"3"];
            
        } else if ([[[response objectForKey:@"date"] objectAtIndex:i] isEqualToString:@"Wed"]) {
            
            [self.dayArrObj addObject:@"4"];
            
        } else if ([[[response objectForKey:@"date"] objectAtIndex:i] isEqualToString:@"Thu"]) {
            
            [self.dayArrObj addObject:@"5"];
            
        } else if ([[[response objectForKey:@"date"] objectAtIndex:i] isEqualToString:@"Fri"]) {
            
            [self.dayArrObj addObject:@"6"];
            
        } else if ([[[response objectForKey:@"date"] objectAtIndex:i] isEqualToString:@"Sat"]) {
            
            [self.dayArrObj addObject:@"7"];
        
        }
        
    }
    
    /* Date */
    [self setDate];
    
    /* Time */
    [self setTime];
    
}

- (void)PFApi:(id)sender getDateTimesErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
}

/* Appoint API */

- (void)PFApi:(id)sender apppointResponse:(NSDictionary *)response {
    NSLog(@"%@",response);
    
    consult_id = [response objectForKey:@"id"];
    
    if ([[[response objectForKey:@"error"] objectForKey:@"type"] isEqualToString:@"Error"]) {
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:nil
                                                          message:@"ส่งนัดหมายล้มเหลว"
                                                         delegate:nil
                                                cancelButtonTitle:@"ตกลง"
                                                otherButtonTitles:nil];
        [message show];
        
    } else {
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"ส่งนัดหมายเรียบร้อย"
                                                          message:@"กรุณารอการยืนยันจากทางคลินิกอีกครั้ง ขอบคุณค่ะ"
                                                         delegate:self
                                                cancelButtonTitle:@"ตกลง"
                                                otherButtonTitles:nil];
        [message show];
        
    }
    
}

- (void)PFApi:(id)sender apppointErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        
        if ([self.message isEqualToString:@""]) {
            
            [self.delegate PFConsultViewControllerBack:consult_id];
            [self.navigationController popViewControllerAnimated:YES];
        
        } else {
        
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
    }
    
}

/* Date Tap */

- (IBAction)dateTapped:(id)sender {

    // create the alert
    self.alert = [MLTableAlert tableAlertWithTitle:@"เลือกวันที่" cancelButtonTitle:@"ยกเลิก" numberOfRows:^NSInteger (NSInteger section)
                  {
                    return [self.dayArr count];
                  }
                                          andCells:^UITableViewCell* (MLTableAlert *anAlert, NSIndexPath *indexPath)
                  {
                      static NSString *CellIdentifier = @"CellIdentifier";
                      UITableViewCell *cell = [anAlert.table dequeueReusableCellWithIdentifier:CellIdentifier];
                      if (cell == nil)
                          cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                      
                      cell.textLabel.text = [NSString stringWithFormat:@"%@",[self.dayArr objectAtIndex:indexPath.row]];
                      
                      return cell;
                  }];
    
    // Setting custom alert height
    self.alert.height = 350;
    
    // configure actions to perform
    [self.alert configureSelectionBlock:^(NSIndexPath *selectedIndex){
        
        sentDate = [self.sentDayArr objectAtIndex:selectedIndex.row];
        self.lb_day.text = [self.dayArr objectAtIndex:selectedIndex.row];
        
    } andCompletionBlock:^{
        
    }];
    
    // show the alert
    [self.alert show];
    
}

/* Time Tap */

- (IBAction)timeTapped:(id)sender {

    // create the alert
    self.alert = [MLTableAlert tableAlertWithTitle:@"เลือกเวลา" cancelButtonTitle:@"ยกเลิก" numberOfRows:^NSInteger (NSInteger section)
                  {
                      return [self.hourArr count];
                  }
                                          andCells:^UITableViewCell* (MLTableAlert *anAlert, NSIndexPath *indexPath)
                  {
                      static NSString *CellIdentifier = @"CellIdentifier";
                      UITableViewCell *cell = [anAlert.table dequeueReusableCellWithIdentifier:CellIdentifier];
                      if (cell == nil)
                          cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                      
                      cell.textLabel.text = [NSString stringWithFormat:@"%@ น.",[self.hourArr objectAtIndex:indexPath.row]];
                      
                      return cell;
                  }];
    
    // Setting custom alert height
    self.alert.height = 350;
    
    // configure actions to perform
    [self.alert configureSelectionBlock:^(NSIndexPath *selectedIndex){
        
        sentTime = [self.hourArr objectAtIndex:selectedIndex.row];
        self.lb_time.text = [NSString stringWithFormat:@"%@ น.",[self.hourArr objectAtIndex:selectedIndex.row]];
        
    } andCompletionBlock:^{
        
    }];
    
    // show the alert
    [self.alert show];
    
}

/* Cancel Tap */

- (IBAction)cancelTapped:(id)sender {
    
    [self.delegate PFConsultViewControllerBack:@"0"];
    [self.navigationController popViewControllerAnimated:YES];
    
}

/* Submit Tap */

- (IBAction)submitTapped:(id)sender {

    if ([self.lb_day.text isEqualToString:@""]) {
    
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:nil
                                                          message:@"กรุณาเลือกวันที่"
                                                         delegate:nil
                                                cancelButtonTitle:@"ตกลง"
                                                otherButtonTitles:nil];
        [message show];
        
    } else if ([self.lb_time.text isEqualToString:@""]) {
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:nil
                                                          message:@"กรุณาเลือกเวลา"
                                                         delegate:nil
                                                cancelButtonTitle:@"ตกลง"
                                                otherButtonTitles:nil];
        [message show];
        
    } else if ([self.nameTextField.text isEqualToString:@""]) {
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:nil
                                                          message:@"กรุณากรอกชื่อ"
                                                         delegate:nil
                                                cancelButtonTitle:@"ตกลง"
                                                otherButtonTitles:nil];
        [message show];
        
    } else if ([self.phoneTextField.text isEqualToString:@""]) {
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:nil
                                                          message:@"กรุณากรอกเบอร์โทรศัพท์"
                                                         delegate:nil
                                                cancelButtonTitle:@"ตกลง"
                                                otherButtonTitles:nil];
        [message show];
        
    } else if ([self.messageTextField.text isEqualToString:@""]) {
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:nil
                                                          message:@"กรุณากรอกข้อความ"
                                                         delegate:nil
                                                cancelButtonTitle:@"ตกลง"
                                                otherButtonTitles:nil];
        [message show];
        
    } else {
    
        [self.Api appoint:sentDate time:sentTime name:self.nameTextField.text phone:self.phoneTextField.text detail:self.messageTextField.text status:@"new"];
        
    }
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (textField == self.nameTextField) {
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.headerView.frame = CGRectMake(self.headerView.frame.origin.x, -30, self.headerView.frame.size.width, self.headerView.frame.size.height);
        [UIView commitAnimations];
        
    }
    
    if (textField == self.phoneTextField) {
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.headerView.frame = CGRectMake(self.headerView.frame.origin.x, -100, self.headerView.frame.size.width, self.headerView.frame.size.height);
        [UIView commitAnimations];
        
    }
    
    if (textField == self.messageTextField) {
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.headerView.frame = CGRectMake(self.headerView.frame.origin.x, -170, self.headerView.frame.size.width, self.headerView.frame.size.height);
        [UIView commitAnimations];
        
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {

    if (textField == self.nameTextField) {
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.headerView.frame = CGRectMake(self.headerView.frame.origin.x, 0, self.headerView.frame.size.width, self.headerView.frame.size.height);
        [UIView commitAnimations];
        
    }
    
    if (textField == self.phoneTextField) {
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.headerView.frame = CGRectMake(self.headerView.frame.origin.x, 0, self.headerView.frame.size.width, self.headerView.frame.size.height);
        [UIView commitAnimations];
        
    }
    
    if (textField == self.messageTextField) {
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.headerView.frame = CGRectMake(self.headerView.frame.origin.x, 0, self.headerView.frame.size.width, self.headerView.frame.size.height);
        [UIView commitAnimations];
        
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField  {
    
    [self.nameTextField resignFirstResponder];
    [self.phoneTextField resignFirstResponder];
    [self.messageTextField resignFirstResponder];
    
    return YES;
}

@end
