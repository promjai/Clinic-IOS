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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.0f/255.0f green:175.0f/255.0f blue:0.0f/255.0f alpha:1.0f]];
        self.meOffline = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.Api = [[PFApi alloc] init];
    self.Api.delegate = self;
    
    /* API */
    [self.Api user];
    
    /* NavigationBar */
    [self setNavigationBar];
    
    self.tableView.tableHeaderView = self.headerView;
    
    self.lb_name.text = [self.obj objectForKey:@"display_name"];
    self.lb_hn.text = [self.obj objectForKey:@"hn_number"];
    
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
    
    self.navigationItem.title = @"แก้ไข";
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    
}

/* User API */

- (void)PFApi:(id)sender userResponse:(NSDictionary *)response {
    NSLog(@"%@",response);
    
    self.obj = response;
    
    [self.meOffline setObject:response forKey:@"meOffline"];
    [self.meOffline synchronize];
    
    self.lb_name.text = [response objectForKey:@"display_name"];
    self.lb_hn.text = [response objectForKey:@"hn_number"];
    
}

- (void)PFApi:(id)sender userErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
    
    self.obj = [self.meOffline objectForKey:@"meOffline"];
    
    self.lb_name.text = [[self.meOffline objectForKey:@"meOffline"] objectForKey:@"display_name"];
    self.lb_hn.text = [[self.meOffline objectForKey:@"meOffline"] objectForKey:@"hn_number"];
    
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
    editcarddetailView.obj = self.obj;
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
    editcarddetailView.obj = self.obj;
    editcarddetailView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:editcarddetailView animated:YES];

}

/* EditCardDetail Back */

- (void)PFEditCardDetailViewControllerBack {

    /* API */
    [self.Api user];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        // 'Back' button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        if([self.delegate respondsToSelector:@selector(PFEditCardViewControllerBack)]){
            [self.delegate PFEditCardViewControllerBack];
        }
    }
    
}

@end
