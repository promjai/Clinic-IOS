//
//  PFUpdateViewController.m
//  Times Clinic
//
//  Created by Pariwat Promjai on 2/27/2558 BE.
//  Copyright (c) 2558 Pariwat Promjai. All rights reserved.
//

#import "PFUpdateViewController.h"

@interface PFUpdateViewController ()

@end

@implementation PFUpdateViewController

BOOL loadFeed;
BOOL noDataFeed;
BOOL refreshDataFeed;

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
    
    self.Api = [[PFApi alloc] init];
    self.Api.delegate = self;
    
    /* NavigationBar */
    [self setNavigationBar];
    
    /* API */
    [self.Api getOverview];
    //[self.Api getFeed];
    
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
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_update.png"]];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_setting"] style:UIBarButtonItemStyleDone target:self action:@selector(setting)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_notification"] style:UIBarButtonItemStyleDone target:self action:@selector(notify)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
}

/* Setting Onclick */

- (void)setting {
    
    if ([self.Api checkLogin] == false) {
        
        self.navigationItem.leftBarButtonItem.enabled = NO;
        self.navigationItem.rightBarButtonItem.enabled = NO;
        
        self.loginView = [PFLoginViewController alloc];
        self.loginView.delegate = self;
        self.loginView.menu = @"setting";
        [self.view addSubview:self.loginView.view];
        
    } else {
        
        PFSettingViewController *settingView = [[PFSettingViewController alloc] init];
        if(IS_WIDESCREEN) {
            settingView = [[PFSettingViewController alloc] initWithNibName:@"PFSettingViewController_Wide" bundle:nil];
        } else {
            settingView = [[PFSettingViewController alloc] initWithNibName:@"PFSettingViewController" bundle:nil];
        }
        settingView.delegate = self;
        settingView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:settingView animated:YES];
        
    }
    
}

/* Return Setting */

- (void)PFSettingViewController:(id)sender {

    PFSettingViewController *settingView = [[PFSettingViewController alloc] init];
    if(IS_WIDESCREEN) {
        settingView = [[PFSettingViewController alloc] initWithNibName:@"PFSettingViewController_Wide" bundle:nil];
    } else {
        settingView = [[PFSettingViewController alloc] initWithNibName:@"PFSettingViewController" bundle:nil];
    }
    settingView.delegate = self;
    settingView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingView animated:YES];
    
}

/* Notification Onclick */

- (void)notify {
    
    if ([self.Api checkLogin] == false) {
        
        self.navigationItem.leftBarButtonItem.enabled = NO;
        self.navigationItem.rightBarButtonItem.enabled = NO;
        
        self.loginView = [PFLoginViewController alloc];
        self.loginView.delegate = self;
        self.loginView.menu = @"notify";
        [self.view addSubview:self.loginView.view];
        
    } else {
        
        PFNotificationViewController *notifyView = [[PFNotificationViewController alloc] init];
        if(IS_WIDESCREEN) {
            notifyView = [[PFNotificationViewController alloc] initWithNibName:@"PFNotificationViewController_Wide" bundle:nil];
        } else {
            notifyView = [[PFNotificationViewController alloc] initWithNibName:@"PFNotificationViewController" bundle:nil];
        }
        notifyView.delegate = self;
        notifyView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:notifyView animated:YES];
        
    }
    
}

/* Return Notify */

- (void)PFNotifyViewController:(id)sender {
    
    PFNotificationViewController *notifyView = [[PFNotificationViewController alloc] init];
    if(IS_WIDESCREEN) {
        notifyView = [[PFNotificationViewController alloc] initWithNibName:@"PFNotificationViewController_Wide" bundle:nil];
    } else {
        notifyView = [[PFNotificationViewController alloc] initWithNibName:@"PFNotificationViewController" bundle:nil];
    }
    notifyView.delegate = self;
    notifyView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:notifyView animated:YES];
    
}

/* Close Login View */

- (void)closeloginView:(id)sender {

    self.navigationItem.leftBarButtonItem.enabled = YES;
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
}

/* Setting Back */

- (void)PFSettingViewControllerBack {

    self.navigationItem.leftBarButtonItem.enabled = YES;
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
}

/* Overview API */

- (void)PFApi:(id)sender getOverviewResponse:(NSDictionary *)response {
    NSLog(@"%@",response);
    
    /* API */
    [self.Api getFeed];
    
}

- (void)PFApi:(id)sender getOverviewErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
}

/* Feed API */

- (void)PFApi:(id)sender getFeedResponse:(NSDictionary *)response {
    NSLog(@"%@",response);
    
    self.checkinternet = @"connect";
    
    self.tableView.tableHeaderView = self.headerView;
    
    if (!refreshDataFeed) {
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
        noDataFeed = YES;
    } else {
        noDataFeed = NO;
        self.paging = [[response objectForKey:@"paging"] objectForKey:@"next"];
    }
    
    [self.tableView reloadData];
    
}

- (void)PFApi:(id)sender getFeedErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
}

/* TableView */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrObj count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  260;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PFUpdateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PFUpdateCell"];
    if(cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PFUpdateCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.img_thumb.layer.masksToBounds = YES;
    cell.img_thumb.contentMode = UIViewContentModeScaleAspectFill;
    
    NSString *urlimg = [[NSString alloc] initWithFormat:@"%@",[[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"thumb"] objectForKey:@"url"]];
    
    [DLImageLoader loadImageFromURL:urlimg
                          completed:^(NSError *error, NSData *imgData) {
                              cell.img_thumb.image = [UIImage imageWithData:imgData];
                          }];
    
    cell.lb_name.text = [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"name"];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"feed"]) {
        
        PFUpdateDetailViewController *detailView = [[PFUpdateDetailViewController alloc] init];
        if(IS_WIDESCREEN) {
            detailView = [[PFUpdateDetailViewController alloc] initWithNibName:@"PFUpdateDetailViewController_Wide" bundle:nil];
        } else {
            detailView = [[PFUpdateDetailViewController alloc] initWithNibName:@"PFUpdateDetailViewController" bundle:nil];
        }
        detailView.delegate = self;
        detailView.obj = [self.arrObj objectAtIndex:indexPath.row];
        detailView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailView animated:YES];
    
    } else if ([[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"coupon"]) {
        
        PFPromotionDetailViewController *promotionDetail = [[PFPromotionDetailViewController alloc] init];
        if(IS_WIDESCREEN) {
            promotionDetail = [[PFPromotionDetailViewController alloc] initWithNibName:@"PFPromotionDetailViewController_Wide" bundle:nil];
        } else {
            promotionDetail = [[PFPromotionDetailViewController alloc] initWithNibName:@"PFPromotionDetailViewController" bundle:nil];
        }
        promotionDetail.delegate = self;
        promotionDetail.obj = [self.arrObj objectAtIndex:indexPath.row];
        promotionDetail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:promotionDetail animated:YES];
    
    }
    
}

/* Full Image */

- (void)PFImageViewController:(id)sender viewPicture:(UIImage *)image {
    
    [self.delegate PFImageViewController:self viewPicture:image];
    
}

@end
