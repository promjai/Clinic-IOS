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
    
    /* NavigationBar */
    [self setNavigationBar];

    //self.tableView.tableHeaderView = self.nologinView;
    self.tableView.tableHeaderView = self.headerView;
    
    /* View */
    [self setView];
    
    self.txt_nologin.text = @"กรุณาลงทะเบียน เพื่อเข้าถึงประวัติการรักษา และรับแจ้งเตือนนัดพบแพทย์ในครั้งถัดไป";
    
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
    
    self.navigationItem.title = @"บัตรคลินิก";
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"แก้ไข" style:UIBarButtonItemStylePlain target:self action:@selector(edit)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
}

/* Edit */

- (void)edit {

    PFEditCardViewController *editcardView = [[PFEditCardViewController alloc] init];
    if(IS_WIDESCREEN) {
        editcardView = [[PFEditCardViewController alloc] initWithNibName:@"PFEditCardViewController_Wide" bundle:nil];
    } else {
        editcardView = [[PFEditCardViewController alloc] initWithNibName:@"PFEditCardViewController" bundle:nil];
    }
    editcardView.delegate = self;
    editcardView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:editcardView animated:YES];

}

/* Set View */

- (void)setView {
    
    [self.bg_nologinView.layer setMasksToBounds:YES];
    [self.bg_nologinView.layer setCornerRadius:5.0f];
    
    [self.bg_headerView.layer setMasksToBounds:YES];
    [self.bg_headerView.layer setCornerRadius:5.0f];
    
    [self.bt_register.layer setMasksToBounds:YES];
    [self.bt_register.layer setCornerRadius:5.0f];
    
    [self.bt_consult.layer setMasksToBounds:YES];
    [self.bt_consult.layer setCornerRadius:5.0f];
    
}

/* Register Tap */

- (IBAction)registerTapped:(id)sender {
    
    

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

/* TableView */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
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
    timesdetailView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:timesdetailView animated:YES];

}

@end
