//
//  PFFolder2ViewController.m
//  Times Clinic
//
//  Created by Pariwat Promjai on 3/19/2558 BE.
//  Copyright (c) 2558 Pariwat Promjai. All rights reserved.
//

#import "PFFolder2ViewController.h"

@interface PFFolder2ViewController ()

@end

@implementation PFFolder2ViewController

BOOL loadFolder;
BOOL noDataFolder;
BOOL refreshDataFolder;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.0f/255.0f green:175.0f/255.0f blue:0.0f/255.0f alpha:1.0f]];
        self.foldertypeOffline = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    loadFolder = NO;
    noDataFolder = NO;
    refreshDataFolder = NO;
    
    [self.view addSubview:self.waitView];
    
    self.arrObj = [[NSMutableArray alloc] init];
    
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
    
    self.navigationItem.title = [self.obj objectForKey:@"name"];
    
}

/* Set View */

- (void)setView {
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    /* API */
    [self.Api getServiceByURL:[[self.obj objectForKey:@"node"] objectForKey:@"children"]];
    
}

/* Refresh TableView */

- (void)refresh:(UIRefreshControl *)refreshControl {
    
    refreshDataFolder = YES;
    
    /* API */
    [self.Api getServiceByURL:[[self.obj objectForKey:@"node"] objectForKey:@"children"]];
    
}

/* Service API */

- (void)PFApi:(id)sender getServiceResponse:(NSDictionary *)response {
    NSLog(@"%@",response);
    
    [self.waitView removeFromSuperview];
    [self.refreshControl endRefreshing];
    
    if (!refreshDataFolder) {
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
        noDataFolder = YES;
    } else {
        noDataFolder = NO;
        self.paging = [[response objectForKey:@"paging"] objectForKey:@"next"];
    }
    
    [self.foldertypeOffline setObject:response forKey:[[self.obj objectForKey:@"node"] objectForKey:@"children"]];
    [self.foldertypeOffline synchronize];
    
    [self.tableView reloadData];
    
}

- (void)PFApi:(id)sender getServiceErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
    
    [self.waitView removeFromSuperview];
    [self.refreshControl endRefreshing];
    
    if (!refreshDataFolder) {
        for (int i=0; i<[[[self.foldertypeOffline objectForKey:[[self.obj objectForKey:@"node"] objectForKey:@"children"]] objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[[self.foldertypeOffline objectForKey:[[self.obj objectForKey:@"node"] objectForKey:@"children"]] objectForKey:@"data"] objectAtIndex:i]];
        }
    } else {
        [self.arrObj removeAllObjects];
        for (int i=0; i<[[[self.foldertypeOffline objectForKey:[[self.obj objectForKey:@"node"] objectForKey:@"children"]] objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[[self.foldertypeOffline objectForKey:[[self.obj objectForKey:@"node"] objectForKey:@"children"]] objectForKey:@"data"] objectAtIndex:i]];
        }
    }
    
    [self.tableView reloadData];
    
}

/* TableView */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrObj count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"folder"]) {
        
        PFFolderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PFFolderCell"];
        if(cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PFFolderCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.img_thumb.layer.masksToBounds = YES;
        cell.img_thumb.contentMode = UIViewContentModeScaleAspectFill;
        
        NSString *urlimg = [[NSString alloc] initWithFormat:@"%@",[[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"thumb"] objectForKey:@"url"]];
        
        [DLImageLoader loadImageFromURL:urlimg
                              completed:^(NSError *error, NSData *imgData) {
                                  cell.img_thumb.image = [UIImage imageWithData:imgData];
                              }];
        
        cell.lb_name.text = [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"name"];
        
        return cell;
        
    } else {
        
        PFFolderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PFFolderCell"];
        if(cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PFFolderCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.img_thumb.layer.masksToBounds = YES;
        cell.img_thumb.contentMode = UIViewContentModeScaleAspectFill;
        
        NSString *urlimg = [[NSString alloc] initWithFormat:@"%@",[[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"thumb"] objectForKey:@"url"]];
        
        [DLImageLoader loadImageFromURL:urlimg
                              completed:^(NSError *error, NSData *imgData) {
                                  cell.img_thumb.image = [UIImage imageWithData:imgData];
                              }];
        
        cell.lb_name.text = [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"name"];
        NSString *price = [[NSString alloc] initWithFormat:@"%@ %@",[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"price"],@"บาท"];
        cell.lb_price.text = price;
        
        return cell;
        
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"item"]) {
        
        PFServiceDetailViewController *serviceDetail = [[PFServiceDetailViewController alloc] init];
        if(IS_WIDESCREEN) {
            serviceDetail = [[PFServiceDetailViewController alloc] initWithNibName:@"PFServiceDetailViewController_Wide" bundle:nil];
        } else {
            serviceDetail = [[PFServiceDetailViewController alloc] initWithNibName:@"PFServiceDetailViewController" bundle:nil];
        }
        serviceDetail.delegate = self;
        serviceDetail.obj = [self.arrObj objectAtIndex:indexPath.row];
        serviceDetail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:serviceDetail animated:YES];
        
    } else if ([[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"folder"]) {
        
        NSString *children_length = [[NSString alloc] initWithFormat:@"%@",[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"children_length"]];
        
        if ([children_length isEqualToString:@"0"]) {
            
            [[[UIAlertView alloc] initWithTitle:@"Times Clinic!"
                                        message:@"เร็วๆ นี้."
                                       delegate:nil
                              cancelButtonTitle:@"ตกลง"
                              otherButtonTitles:nil] show];
            
        } else {
            
            PFFolder2ViewController *folderDetail = [[PFFolder2ViewController alloc] init];
            if(IS_WIDESCREEN) {
                folderDetail = [[PFFolder2ViewController alloc] initWithNibName:@"PFFolder2ViewController_Wide" bundle:nil];
            } else {
                folderDetail = [[PFFolder2ViewController alloc] initWithNibName:@"PFFolder2ViewController" bundle:nil];
            }
            folderDetail.delegate = self;
            folderDetail.obj = [self.arrObj objectAtIndex:indexPath.row];
            folderDetail.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:folderDetail animated:YES];
        }
        
    }
    
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float offset = (scrollView.contentOffset.y - (scrollView.contentSize.height - scrollView.frame.size.height));
    if (offset >= 0 && offset <= 5) {
        if (!noDataFolder) {
            refreshDataFolder = NO;
            
            [self.Api getServiceByURL:[[self.obj objectForKey:@"node"] objectForKey:@"children"]];
        }
    }
}

/* Full Image Gallery */

- (void)PFGalleryViewController:(id)sender sum:(NSMutableArray *)sum current:(NSString *)current{
    [self.delegate PFGalleryViewController:self sum:sum current:current];
}

/* Full Image */

- (void)PFImageViewController:(id)sender viewPicture:(UIImage *)image{
    [self.delegate PFImageViewController:self viewPicture:image];
}

/* Folder2 Back */

- (void)PFFolder1ViewControllerBack {
    [self.tableView reloadData];
}

/* ServiceDetail Back */

- (void)PFServiceDetailViewControllerBack {
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        // 'Back' button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        if([self.delegate respondsToSelector:@selector(PFFolder2ViewControllerBack)]){
            [self.delegate PFFolder2ViewControllerBack];
        }
    }
}

@end
