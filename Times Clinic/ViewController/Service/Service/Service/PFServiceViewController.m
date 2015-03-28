//
//  PFServiceViewController.m
//  Times Clinic
//
//  Created by Pariwat Promjai on 2/27/2558 BE.
//  Copyright (c) 2558 Pariwat Promjai. All rights reserved.
//

#import "PFServiceViewController.h"

@interface PFServiceViewController ()

@end

@implementation PFServiceViewController

BOOL loadService;
BOOL noDataService;
BOOL refreshDataService;

int serviceInt;
NSTimer *timmer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.0f/255.0f green:175.0f/255.0f blue:0.0f/255.0f alpha:1.0f]];
        self.serviceOffline = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    loadService = NO;
    noDataService = NO;
    refreshDataService = NO;
    
    [self.view addSubview:self.waitView];
    
    self.arrObjService = [[NSMutableArray alloc] init];
    self.arrObjPromotion = [[NSMutableArray alloc] init];
    
    self.Api = [[PFApi alloc] init];
    self.Api.delegate = self;
    
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

    NSArray * buttonNames = [[NSArray alloc]initWithObjects:@"บริการ",@"โปรโมชั่น", nil];
    self.segmented = [[UISegmentedControl alloc]initWithItems:buttonNames];
    self.segmented.selectedSegmentIndex = 0;
    [self.segmented addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = self.segmented;
    
}

-(void)segmentAction:(UISegmentedControl *)sender
{
    if (self.segmented.selectedSegmentIndex == 0) {
        
        self.checksegmented = @"0";
        self.checkstatus = @"refresh";
        
        [self.view addSubview:self.waitView];
        
        UIView *fv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
        self.tableView.tableFooterView = fv;
        
        /* API */
        [self.Api getService:@"15" link:@"NO"];
        
    }
    if (self.segmented.selectedSegmentIndex == 1) {
        
        self.checksegmented = @"1";
        self.checkstatus = @"refresh";
        
        [self.view addSubview:self.waitView];

        self.tableView.tableFooterView = nil;
        
        /* API */
        [self.Api getPromotion:@"15" link:@"NO"];
        
    }
}

/* Set View */

- (void)setView {
    
    [self.serviceOffline setObject:@"0" forKey:@"service_updated"];
    [self.serviceOffline setObject:@"0" forKey:@"promotion_updated"];
    
    self.checksegmented = @"0";
    self.checkstatus = @"refresh";
    
    UIView *fv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    self.tableView.tableFooterView = fv;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl setTintColor:[UIColor whiteColor]];
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    /* API */
    [self.Api getService:@"15" link:@"NO"];
    
}

/* Refresh TableView */

- (void)refresh:(UIRefreshControl *)refreshControl {
    
    if ([self.checksegmented isEqualToString:@"0"]) {
        
        refreshDataService = YES;
        [self.Api getPromotion:@"15" link:@"NO"];
        self.checkstatus = @"notrefresh";
        
    } else {
        
        refreshDataService = YES;
        [self.Api getService:@"15" link:@"NO"];
        self.checkstatus = @"notrefresh";
        
    }
    
}

/* Service API */

- (void)PFApi:(id)sender getServiceResponse:(NSDictionary *)response {
    NSLog(@"%@",response);
    
    self.objService = response;
    
    [self.waitView removeFromSuperview];
    [self.refreshControl endRefreshing];
    
    [self.NoInternetView removeFromSuperview];
    self.checkinternet = @"connect";
    
    [self.serviceOffline setObject:response forKey:@"serviceArray"];
    [self.serviceOffline synchronize];
    
    if (!refreshDataService) {
        [self.arrObjService removeAllObjects];
        for (int i=0; i<[[response objectForKey:@"data"] count]; ++i) {
            [self.arrObjService addObject:[[response objectForKey:@"data"] objectAtIndex:i]];
        }
    } else {
        [self.arrObjService removeAllObjects];
        for (int i=0; i<[[response objectForKey:@"data"] count]; ++i) {
            [self.arrObjService addObject:[[response objectForKey:@"data"] objectAtIndex:i]];
        }
    }
    
    if ( [[response objectForKey:@"paging"] objectForKey:@"next"] == nil ) {
        noDataService = YES;
    } else {
        noDataService = NO;
        self.paging = [[response objectForKey:@"paging"] objectForKey:@"next"];
    }
    
    [self.serviceOffline setObject:response forKey:@"serviceArray"];
    [self.serviceOffline synchronize];
    
    if ([[self.serviceOffline objectForKey:@"service_updated"] intValue] != [[response objectForKey:@"last_updated"] intValue]) {
        [self.tableView reloadData];
        [self.serviceOffline setObject:[response objectForKey:@"last_updated"] forKey:@"service_updated"];
    }
    
    if ([self.checkstatus isEqualToString:@"refresh"]) {
        [self.tableView reloadData];
    }

}

- (void)PFApi:(id)sender getServiceErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
    
    [self.waitView removeFromSuperview];
    [self.refreshControl endRefreshing];
    
    self.checkinternet = @"error";
    self.NoInternetView.frame = CGRectMake(0, 64, self.NoInternetView.frame.size.width, self.NoInternetView.frame.size.height);
    [self.view addSubview:self.NoInternetView];
    
    serviceInt = 5;
    timmer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    
    if (!refreshDataService) {
        [self.arrObjService removeAllObjects];
        for (int i=0; i<[[[self.serviceOffline objectForKey:@"serviceArray"] objectForKey:@"data"] count]; ++i) {
            [self.arrObjService addObject:[[[self.serviceOffline objectForKey:@"serviceArray"] objectForKey:@"data"] objectAtIndex:i]];
        }
    } else {
        [self.arrObjService removeAllObjects];
        for (int i=0; i<[[[self.serviceOffline objectForKey:@"serviceArray"] objectForKey:@"data"] count]; ++i) {
            [self.arrObjService addObject:[[[self.serviceOffline objectForKey:@"serviceArray"] objectForKey:@"data"] objectAtIndex:i]];
        }
    }
    
    if ([[self.serviceOffline objectForKey:@"service_updated"] intValue] != [[[self.serviceOffline objectForKey:@"serviceArray"] objectForKey:@"last_updated"] intValue]) {
        [self.tableView reloadData];
        [self.serviceOffline setObject:[[self.serviceOffline objectForKey:@"serviceArray"] objectForKey:@"last_updated"] forKey:@"service_updated"];
    }
    
    if ([self.checkstatus isEqualToString:@"refresh"]) {
        [self.tableView reloadData];
    }
    
}

/* Promotion API */

- (void)PFApi:(id)sender getPromotionResponse:(NSDictionary *)response {
    NSLog(@"%@",response);
    
    self.objPromotion = response;
    
    [self.waitView removeFromSuperview];
    [self.refreshControl endRefreshing];
    
    [self.NoInternetView removeFromSuperview];
    self.checkinternet = @"connect";
    
    [self.serviceOffline setObject:response forKey:@"promotionArray"];
    [self.serviceOffline synchronize];
    
    if (!refreshDataService) {
        [self.arrObjPromotion removeAllObjects];
        for (int i=0; i<[[response objectForKey:@"data"] count]; ++i) {
            [self.arrObjPromotion addObject:[[response objectForKey:@"data"] objectAtIndex:i]];
        }
    } else {
        [self.arrObjPromotion removeAllObjects];
        for (int i=0; i<[[response objectForKey:@"data"] count]; ++i) {
            [self.arrObjPromotion addObject:[[response objectForKey:@"data"] objectAtIndex:i]];
        }
    }
    
    if ( [[response objectForKey:@"paging"] objectForKey:@"next"] == nil ) {
        noDataService = YES;
    } else {
        noDataService = NO;
        self.paging = [[response objectForKey:@"paging"] objectForKey:@"next"];
    }
    
    [self.serviceOffline setObject:response forKey:@"promotionArray"];
    [self.serviceOffline synchronize];
    
    if ([[self.serviceOffline objectForKey:@"promotion_updated"] intValue] != [[response objectForKey:@"last_updated"] intValue]) {
        [self.tableView reloadData];
        [self.serviceOffline setObject:[response objectForKey:@"last_updated"] forKey:@"promotion_updated"];
    }
    
    if ([self.checkstatus isEqualToString:@"refresh"]) {
        [self.tableView reloadData];
    }
    
}

- (void)PFApi:(id)sender getPromotionErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
    
    [self.waitView removeFromSuperview];
    [self.refreshControl endRefreshing];
    
    self.checkinternet = @"error";
    self.NoInternetView.frame = CGRectMake(0, 64, self.NoInternetView.frame.size.width, self.NoInternetView.frame.size.height);
    [self.view addSubview:self.NoInternetView];
    
    serviceInt = 5;
    timmer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    
    if (!refreshDataService) {
        [self.arrObjPromotion removeAllObjects];
        for (int i=0; i<[[[self.serviceOffline objectForKey:@"promotionArray"] objectForKey:@"data"] count]; ++i) {
            [self.arrObjPromotion addObject:[[[self.serviceOffline objectForKey:@"promotionArray"] objectForKey:@"data"] objectAtIndex:i]];
        }
    } else {
        [self.arrObjPromotion removeAllObjects];
        for (int i=0; i<[[[self.serviceOffline objectForKey:@"promotionArray"] objectForKey:@"data"] count]; ++i) {
            [self.arrObjPromotion addObject:[[[self.serviceOffline objectForKey:@"promotionArray"] objectForKey:@"data"] objectAtIndex:i]];
        }
    }
    
    if ([[self.serviceOffline objectForKey:@"promotion_updated"] intValue] != [[[self.serviceOffline objectForKey:@"promotionArray"] objectForKey:@"last_updated"] intValue]) {
        [self.tableView reloadData];
        [self.serviceOffline setObject:[[self.serviceOffline objectForKey:@"promotionArray"] objectForKey:@"last_updated"] forKey:@"promotion_updated"];
    }
    
    if ([self.checkstatus isEqualToString:@"refresh"]) {
        [self.tableView reloadData];
    }
    
}

/* Count Down */

- (void)countDown {
    serviceInt -= 1;
    if (serviceInt == 0) {
        [self.NoInternetView removeFromSuperview];
    }
}

/* TableView */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.checksegmented isEqualToString:@"0"]) {
        return [self.arrObjService count];
    } else {
        return [self.arrObjPromotion count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.checksegmented isEqualToString:@"0"]) {
        return 290;
    } else {
        return 92;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.checksegmented isEqualToString:@"0"]) {
        
        PFServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PFServiceCell"];
        if(cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PFServiceCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.img_thumb.layer.masksToBounds = YES;
        cell.img_thumb.contentMode = UIViewContentModeScaleAspectFill;
        
        NSString *urlimg = [[NSString alloc] initWithFormat:@"%@",[[[self.arrObjService objectAtIndex:indexPath.row] objectForKey:@"thumb"] objectForKey:@"url"]];
        
        [DLImageLoader loadImageFromURL:urlimg
                              completed:^(NSError *error, NSData *imgData) {
                                  cell.img_thumb.image = [UIImage imageWithData:imgData];
                              }];
        
        cell.lb_name.text = [[self.arrObjService objectAtIndex:indexPath.row] objectForKey:@"name"];
        
        return cell;
        
    } else {
        
        PFPromotionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PFPromotionCell"];
        if(cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PFPromotionCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.img_thumb.layer.masksToBounds = YES;
        cell.img_thumb.contentMode = UIViewContentModeScaleAspectFill;
        
        NSString *urlimg = [[NSString alloc] initWithFormat:@"%@",[[[self.arrObjPromotion objectAtIndex:indexPath.row] objectForKey:@"thumb"] objectForKey:@"url"]];
        
        [DLImageLoader loadImageFromURL:urlimg
                              completed:^(NSError *error, NSData *imgData) {
                                  cell.img_thumb.image = [UIImage imageWithData:imgData];
                              }];
        
        cell.lb_name.text = [[self.arrObjPromotion objectAtIndex:indexPath.row] objectForKey:@"name"];
        
        return cell;
        
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.checksegmented isEqualToString:@"0"]) {
        
        if ([[[self.arrObjService objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"folder"]) {
        
            PFFolder1ViewController *foldertype = [[PFFolder1ViewController alloc] init];
            if(IS_WIDESCREEN) {
                foldertype = [[PFFolder1ViewController alloc] initWithNibName:@"PFFolder1ViewController_Wide" bundle:nil];
            } else {
                foldertype = [[PFFolder1ViewController alloc] initWithNibName:@"PFFolder1ViewController" bundle:nil];
            }
            foldertype.delegate = self;
            foldertype.obj = [self.arrObjService objectAtIndex:indexPath.row];
            foldertype.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:foldertype animated:YES];
        
        } else {
        
            PFServiceDetailViewController *serviceDetail = [[PFServiceDetailViewController alloc] init];
            if(IS_WIDESCREEN) {
                serviceDetail = [[PFServiceDetailViewController alloc] initWithNibName:@"PFServiceDetailViewController_Wide" bundle:nil];
            } else {
                serviceDetail = [[PFServiceDetailViewController alloc] initWithNibName:@"PFServiceDetailViewController" bundle:nil];
            }
            serviceDetail.delegate = self;
            serviceDetail.obj = [self.arrObjService objectAtIndex:indexPath.row];
            serviceDetail.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:serviceDetail animated:YES];
            
        }
        
    } else {
        
        PFPromotionDetailViewController *promotionDetail = [[PFPromotionDetailViewController alloc] init];
        if(IS_WIDESCREEN) {
            promotionDetail = [[PFPromotionDetailViewController alloc] initWithNibName:@"PFPromotionDetailViewController_Wide" bundle:nil];
        } else {
            promotionDetail = [[PFPromotionDetailViewController alloc] initWithNibName:@"PFPromotionDetailViewController" bundle:nil];
        }
        promotionDetail.delegate = self;
        promotionDetail.obj = [self.arrObjPromotion objectAtIndex:indexPath.row];
        promotionDetail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:promotionDetail animated:YES];
        
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float offset = (scrollView.contentOffset.y - (scrollView.contentSize.height - scrollView.frame.size.height));
    if (offset >= 0 && offset <= 5) {
        if (!noDataService) {
            refreshDataService = NO;
            
            if ([self.checksegmented isEqualToString:@"0"]) {
                
                if ([self.checkinternet isEqualToString:@"connect"]) {
                    [self.Api getService:@"NO" link:self.paging];
                }
                
            } else {
                
                if ([self.checkinternet isEqualToString:@"connect"]) {
                    [self.Api getPromotion:@"NO" link:self.paging];
                }
                
            }
            
        }
    }
}

/* Full Image Gallery */

- (void)PFGalleryViewController:(id)sender sum:(NSMutableArray *)sum current:(NSString *)current{
    [self.delegate PFGalleryViewController:self sum:sum current:current];
}

/* Full Image */

- (void)PFImageViewController:(id)sender viewPicture:(UIImage *)image {
    [self.delegate PFImageViewController:self viewPicture:image];
}

@end
