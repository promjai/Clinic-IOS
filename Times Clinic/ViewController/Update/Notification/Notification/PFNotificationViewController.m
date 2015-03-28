//
//  PFNotificationViewController.m
//  Times Clinic
//
//  Created by Pariwat Promjai on 3/24/2558 BE.
//  Copyright (c) 2558 Pariwat Promjai. All rights reserved.
//

#import "PFNotificationViewController.h"

@interface PFNotificationViewController ()

@end

@implementation PFNotificationViewController

BOOL loadNoti;
BOOL noDataNoti;
BOOL refreshDataNoti;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.0f/255.0f green:175.0f/255.0f blue:0.0f/255.0f alpha:1.0f]];
        self.manager = [AFHTTPRequestOperationManager manager];
        self.notifyOffline = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.arrObj = [[NSMutableArray alloc] init];
    
    [self.view addSubview:self.waitView];
    
    self.Api = [[PFApi alloc] init];
    self.Api.delegate = self;
    
    /* NavigationBar */
    [self setNavigationBar];
    
    /* View */
    [self setView];
    
    /* API */
    [self.Api getNotification:@"15" link:@"NO"];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}


/* Set NavigationBar */

- (void)setNavigationBar {
    
    self.navigationItem.title = @"การแจ้งเตือน";
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    
}

/* Set View */

- (void)setView {
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    // During startup (-viewDidLoad or in storyboard) do:
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    
    refreshDataNoti = YES;
    [self.Api getNotification:@"15" link:@"NO"];
    
}

/* Get Notification API */

- (void)PFApi:(id)sender getNotificationResponse:(NSDictionary *)response {
    NSLog(@"notification %@",response);
    
    [self.Api clearBadge];
    
    [self.waitView removeFromSuperview];
    [self.refreshControl endRefreshing];
    
    self.checkinternet = @"connect";
    
    if (!refreshDataNoti) {
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
        noDataNoti = YES;
    } else {
        noDataNoti = NO;
        self.paging = [[response objectForKey:@"paging"] objectForKey:@"next"];
    }
    
    [self.notifyOffline setObject:response forKey:@"notificationArray"];
    [self.notifyOffline synchronize];
    
    [self.tableView reloadData];
}

- (void)PFApi:(id)sender getNotificationErrorResponse:(NSString *)errorResponse {
    //NSLog(@"%@",errorResponse);
    
    [self.waitView removeFromSuperview];
    [self.refreshControl endRefreshing];
    
    self.checkinternet = @"error";
    
    if (!refreshDataNoti) {
        [self.arrObj removeAllObjects];
        for (int i=0; i<[[[self.notifyOffline objectForKey:@"notificationArray"] objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[[self.notifyOffline objectForKey:@"notificationArray"] objectForKey:@"data"] objectAtIndex:i]];
        }
    } else {
        [self.arrObj removeAllObjects];
        for (int i=0; i<[[[self.notifyOffline objectForKey:@"notificationArray"] objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[[self.notifyOffline objectForKey:@"notificationArray"] objectForKey:@"data"] objectAtIndex:i]];
        }
    }
    
    if ( [[[self.notifyOffline objectForKey:@"notificationArray"] objectForKey:@"paging"] objectForKey:@"next"] == nil ) {
        noDataNoti = YES;
    } else {
        noDataNoti = NO;
        self.paging = [[[self.notifyOffline objectForKey:@"notificationArray"] objectForKey:@"paging"] objectForKey:@"next"];
    }
    
    [self.tableView reloadData];
}

/* Get Feed API */

- (void)PFApi:(id)sender getFeedByIdResponse:(NSDictionary *)response {
    //NSLog(@"%@",response);
    
    PFUpdateDetailViewController *updatedetail = [[PFUpdateDetailViewController alloc] init];
    
    if(IS_WIDESCREEN){
        updatedetail = [[PFUpdateDetailViewController alloc] initWithNibName:@"PFUpdateDetailViewController_Wide" bundle:nil];
    } else {
        updatedetail = [[PFUpdateDetailViewController alloc] initWithNibName:@"PFUpdateDetailViewController" bundle:nil];
    }
    self.navigationItem.title = @" ";
    updatedetail.obj = response;
    updatedetail.delegate = self;
    [self.navigationController pushViewController:updatedetail animated:YES];
    
}

- (void)PFApi:(id)sender getFeedByIdErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
}

////promotion
//
//- (void)PFApi:(id)sender getPromotionByIdResponse:(NSDictionary *)response {
//    //NSLog(@"%@",response);
//    
//    PFPromotionDetailViewController *promotiondetail = [[PFPromotionDetailViewController alloc] init];
//    
//    if(IS_WIDESCREEN){
//        promotiondetail = [[PFPromotionDetailViewController alloc] initWithNibName:@"PFPromotionDetailViewController_Wide" bundle:nil];
//    } else {
//        promotiondetail = [[PFPromotionDetailViewController alloc] initWithNibName:@"PFPromotionDetailViewController" bundle:nil];
//    }
//    self.navigationItem.title = @" ";
//    promotiondetail.obj = response;
//    promotiondetail.delegate = self;
//    [self.navigationController pushViewController:promotiondetail animated:YES];
//}
//
//- (void)PFApi:(id)sender getPromotionByIdErrorResponse:(NSString *)errorResponse {
//    NSLog(@"%@",errorResponse);
//}

//card

- (void)PFApi:(id)sender apppointByIdResponse:(NSDictionary *)response {
    NSLog(@"%@",response);
    
    PFTimesDetailViewController *timesdetailView = [[PFTimesDetailViewController alloc] init];
    if(IS_WIDESCREEN) {
        timesdetailView = [[PFTimesDetailViewController alloc] initWithNibName:@"PFTimesDetailViewController_Wide" bundle:nil];
    } else {
        timesdetailView = [[PFTimesDetailViewController alloc] initWithNibName:@"PFTimesDetailViewController" bundle:nil];
    }
    timesdetailView.delegate = self;
    timesdetailView.obj = response;
    timesdetailView.status = [response objectForKey:@"status"];
    timesdetailView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:timesdetailView animated:YES];
    
}

- (void)PFApi:(id)sender apppointByIdErrorResponse:(NSDictionary *)errorResponse {
    NSLog(@"%@",errorResponse);
}

//message

- (void)PFApi:(id)sender getMessageByIdResponse:(NSDictionary *)response {
    NSLog(@"%@",response);
    
    PFMessageViewController *coupondetail = [[PFMessageViewController alloc] init];
    if(IS_WIDESCREEN){
        coupondetail = [[PFMessageViewController alloc] initWithNibName:@"PFMessageViewController_Wide" bundle:nil];
    } else {
        coupondetail = [[PFMessageViewController alloc] initWithNibName:@"PFMessageViewController" bundle:nil];
    }
    NSString *message = [[NSString alloc] initWithFormat:@"%@   %@",[response objectForKey:@"message"],@""];
    coupondetail.message = message;
    coupondetail.delegate = self;
    [self.navigationController pushViewController:coupondetail animated:YES];
    
}

- (void)PFApi:(id)sender getMessageByIdErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
}

/* TableView */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrObj count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PFNotificationCell"];
    if(cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PFNotificationCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.lb_topic.text = [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"preview_header"];
    
    NSString *myDate = [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"created_at"];
    NSString *mySmallerDate = [myDate substringToIndex:16];
    cell.lb_time.text = mySmallerDate;
    
    cell.lb_msg.text = [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"preview_content"];
    
    if ([[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"opened"] intValue] == 0) {
        cell.bg.image = [UIImage imageNamed:@"NotBoxNoReadIp5"];
    } else {
        cell.bg.image = [UIImage imageNamed:@"NotBoxReadedIp5"];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *type = [[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"object"] objectForKey:@"type"];
    
    if ( [type isEqualToString:@"news"] ) {
        
        [self.Api getFeedById:[[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"object"] objectForKey:@"id"]];
        
//    else if ( [type isEqualToString:@"promotion"] ) {
//        
//        [self.Api getPromotionById:[[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"object"] objectForKey:@"id"]];
//        
    } else if ( [type isEqualToString:@"card"] ) {
        
        [self.Api appointById:[[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"object"] objectForKey:@"id"]];
        
    } else if ( [type isEqualToString:@"message"] ) {
    
        [self.Api getMessageById:[[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"object"] objectForKey:@"id"]];
    
    }

    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@user/notify/read/%@",API_URL,[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"id"]];
    
    NSDictionary *parameters = @{@"access_token":[self.Api getAccessToken]};
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [self.manager.requestSerializer setValue:nil forHTTPHeaderField:@"X-Auth-Token"];
    [self.manager GET:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        
        [self.Api deleteNotification:[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"id"]];
        
    }
}

/* Delete Notification API */

- (void)PFApi:(id)sender deleteNotificationResponse:(NSDictionary *)response {
    [self.Api getNotification:@"15" link:@"NO"];
}

- (void)PFApi:(id)sender deleteNotificationErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float offset = (scrollView.contentOffset.y - (scrollView.contentSize.height - scrollView.frame.size.height));
    if (offset >= 0 && offset <= 5) {
        if (!noDataNoti) {
            refreshDataNoti = NO;
            
            if ([self.checkinternet isEqualToString:@"connect"]) {
                [self.Api getNotification:@"NO" link:self.paging];
            }
        }
    }
}

- (void)PFImageViewController:(id)sender viewPicture:(UIImage *)image {
    [self.delegate PFImageViewController:self viewPicture:image];
}

- (void)PFUpdateDetailViewControllerBack {
    [self viewDidLoad];
}

- (void)PFMessageViewControllerBack {
    [self viewDidLoad];
}

- (void)PFTimesDetailViewControllerBack {
    [self viewDidLoad];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        // 'Back' button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        if([self.delegate respondsToSelector:@selector(PFNotificationViewControllerBack)]){
            [self.delegate PFNotificationViewControllerBack];
        }
    }
}

@end
