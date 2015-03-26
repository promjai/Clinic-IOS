//
//  PFTimesViewController.m
//  Times Clinic
//
//  Created by Pariwat Promjai on 2/27/2558 BE.
//  Copyright (c) 2558 Pariwat Promjai. All rights reserved.
//

#import "PFTimesViewController.h"

@interface PFTimesViewController ()

@end

@implementation PFTimesViewController

BOOL loadTimes;
BOOL noDataTimes;
BOOL refreshDataTimes;

int TimesInt;
NSTimer *timmer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.0f/255.0f green:175.0f/255.0f blue:0.0f/255.0f alpha:1.0f]];
        self.meOffline = [NSUserDefaults standardUserDefaults];
        self.timesOffline = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.arrObj = [[NSMutableArray alloc] init];
    
    self.Api = [[PFApi alloc] init];
    self.Api.delegate = self;
    
    loadTimes = NO;
    noDataTimes = NO;
    refreshDataTimes = NO;
    
    /* NavigationBar */
    [self setNavigationBar];
    
    if ([self.Api checkLogin] == false) {
        
        self.tableView.tableHeaderView = self.nologinView;
        
    } else {
        
        /* API */
        [self.Api user];
        [self.Api getTimes];
        
        self.tableView.tableHeaderView = self.headerView;
        
    }
    
    /* View */
    [self setView];
    
    self.lb_nologin.text = @"กรุณาลงทะเบียน เพื่อเข้าถึงประวัติการรักษา และรับแจ้งเตือนนัดพบแพทย์ในครั้งถัดไป";
    
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
    
    self.navigationItem.title = @"บัตรคลินิก";
    
}

/* Set View */

- (void)setView {
    
    [self.bg_nologinView.layer setMasksToBounds:YES];
    [self.bg_nologinView.layer setCornerRadius:10.0f];
    
    [self.bt_edit.layer setMasksToBounds:YES];
    [self.bt_edit.layer setCornerRadius:10.0f];
    
    [self.bt_register.layer setMasksToBounds:YES];
    [self.bt_register.layer setCornerRadius:5.0f];
    
    [self.bt_consult.layer setMasksToBounds:YES];
    [self.bt_consult.layer setCornerRadius:5.0f];
    
    CAGradientLayer *gradientNologin = [CAGradientLayer layer];
    gradientNologin.frame = self.bg_nologinView.bounds;
    gradientNologin.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[UIColor colorWithRed:221.0f/255.0f green:221.0f/255.0f blue:221.0f/255.0f alpha:1.0f] CGColor], nil];
    [self.bg_nologinView.layer insertSublayer:gradientNologin atIndex:0];
    
    CAGradientLayer *gradientlogin = [CAGradientLayer layer];
    gradientlogin.frame = self.bt_edit.bounds;
    gradientlogin.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[UIColor colorWithRed:221.0f/255.0f green:221.0f/255.0f blue:221.0f/255.0f alpha:1.0f] CGColor], nil];
    [self.bt_edit.layer insertSublayer:gradientlogin atIndex:0];
    
}

/* Edit Tap */

- (IBAction)editTapped:(id)sender {

    PFEditCardViewController *editcardView = [[PFEditCardViewController alloc] init];
    if(IS_WIDESCREEN) {
        editcardView = [[PFEditCardViewController alloc] initWithNibName:@"PFEditCardViewController_Wide" bundle:nil];
    } else {
        editcardView = [[PFEditCardViewController alloc] initWithNibName:@"PFEditCardViewController" bundle:nil];
    }
    editcardView.delegate = self;
    editcardView.obj = self.obj;
    editcardView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:editcardView animated:YES];

}

/* Register Tap */

- (IBAction)registerTapped:(id)sender {
    
    self.loginView = [PFLoginViewController alloc];
    self.loginView.delegate = self;
    self.loginView.menu = @"times";
    [self.view addSubview:self.loginView.view];

}

/* Return Times */

- (void)PFTimesViewController:(id)sender {

    [self viewDidLoad];
    
}

/* Consult Tap */

- (IBAction)consultTapped:(id)sender {

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

/* User API */

- (void)PFApi:(id)sender userResponse:(NSDictionary *)response {
    NSLog(@"%@",response);
    
    self.obj = response;
    
    [self.meOffline setObject:response forKey:@"meOffline"];
    [self.meOffline synchronize];
    
    self.txt_name.text = [response objectForKey:@"display_name"];
    self.txt_hn.text = [response objectForKey:@"hn_number"];
    
}

- (void)PFApi:(id)sender userErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
    
    self.obj = [self.meOffline objectForKey:@"meOffline"];
    
    self.txt_name.text = [[self.meOffline objectForKey:@"meOffline"] objectForKey:@"display_name"];
    self.txt_hn.text = [[self.meOffline objectForKey:@"meOffline"] objectForKey:@"hn_number"];
    
}

/* Times API */

- (void)PFApi:(id)sender getTimesResponse:(NSDictionary *)response {
    NSLog(@"%@",response);
    
    [self.refreshControl endRefreshing];
    
    [self.NoInternetView removeFromSuperview];
    self.checkinternet = @"connect";
    
    [self.timesOffline setObject:response forKey:@"timesArray"];
    [self.timesOffline synchronize];
    
    if (!refreshDataTimes) {
        [self.arrObj removeAllObjects];
        for (int i=0; i<[[response objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[response objectForKey:@"data"] objectAtIndex:i]];
        }
    } else {
        [self.arrObj removeAllObjects];
        for (int i=0; i<[[response objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[response objectForKey:@"data"] objectAtIndex:i]];
        }
    }
    
    if ( [[response objectForKey:@"paging"] objectForKey:@"next"] == nil ) {
        noDataTimes = YES;
    } else {
        noDataTimes = NO;
        self.paging = [[response objectForKey:@"paging"] objectForKey:@"next"];
    }
    
    [self.tableView reloadData];
    
}

- (void)PFApi:(id)sender getTimesErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
    
    [self.refreshControl endRefreshing];
    
    self.checkinternet = @"error";
    self.NoInternetView.frame = CGRectMake(0, 64, self.NoInternetView.frame.size.width, self.NoInternetView.frame.size.height);
    [self.view addSubview:self.NoInternetView];
    
    TimesInt = 5;
    timmer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    
    if (!refreshDataTimes) {
        [self.arrObj removeAllObjects];
        for (int i=0; i<[[[self.timesOffline objectForKey:@"timesArray"] objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[[self.timesOffline objectForKey:@"timesArray"] objectForKey:@"data"] objectAtIndex:i]];
        }
    } else {
        [self.arrObj removeAllObjects];
        for (int i=0; i<[[[self.timesOffline objectForKey:@"timesArray"] objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[[self.timesOffline objectForKey:@"timesArray"] objectForKey:@"data"] objectAtIndex:i]];
        }
    }
    
    [self.tableView reloadData];
    
}

/* Count Down */

- (void)countDown {
    TimesInt -= 1;
    if (TimesInt == 0) {
        [self.NoInternetView removeFromSuperview];
    }
}

/* TableView */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if ([self.Api checkLogin] == false) {
    
        return 0;
        
    } else {
        
        return [self.arrObj count];
        
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return  45;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    PFTimesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PFTimesCell"];
    if(cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PFTimesCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSDateFormatter *monthFormatter = [[NSDateFormatter alloc] init];
    [monthFormatter setDateFormat:@"MMM"];
    
    NSDateFormatter *getDateFormatter = [[NSDateFormatter alloc] init];
    [getDateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *dayOfMonth = [[NSString alloc] initWithFormat:@"%@",[[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"date_time"] substringToIndex:10]];
    NSDate *date = [getDateFormatter dateFromString:dayOfMonth];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    int year = [components year];
    int day = [components day];
    
    cell.lb_day.text = [[NSString alloc] initWithFormat:@"%d %@ %d",day,[monthFormatter stringFromDate:date],year];
    cell.lb_detail.text = [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"detail"];
    
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    PFTimesDetailViewController *timesdetailView = [[PFTimesDetailViewController alloc] init];
    if(IS_WIDESCREEN) {
        timesdetailView = [[PFTimesDetailViewController alloc] initWithNibName:@"PFTimesDetailViewController_Wide" bundle:nil];
    } else {
        timesdetailView = [[PFTimesDetailViewController alloc] initWithNibName:@"PFTimesDetailViewController" bundle:nil];
    }
    timesdetailView.delegate = self;
    timesdetailView.obj = [self.arrObj objectAtIndex:indexPath.row];
    timesdetailView.status = [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"status"];
    timesdetailView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:timesdetailView animated:YES];

}

/* EditCard Back */

- (void)PFEditCardViewControllerBack {

    /* API */
    [self.Api user];
    
}

/* Consult Back */

- (void)PFConsultViewControllerBack:(NSString *)consult_id {

    /* API */
    [self.Api getTimes];
    
}

/* TimesDetail Back */

- (void)PFTimesDetailViewControllerBack {

    /* API */
    [self.Api getTimes];
    
}

@end
