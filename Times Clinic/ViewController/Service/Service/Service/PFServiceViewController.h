//
//  PFServiceViewController.h
//  Times Clinic
//
//  Created by Pariwat Promjai on 2/27/2558 BE.
//  Copyright (c) 2558 Pariwat Promjai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLImageLoader.h"

#import "PFApi.h"

#import "PFServiceCell.h"
#import "PFPromotionCell.h"
#import "PFFolder1ViewController.h"
#import "PFServiceDetailViewController.h"
#import "PFPromotionDetailViewController.h"

@protocol PFServiceViewControllerDelegate <NSObject>

- (void)PFGalleryViewController:(id)sender sum:(NSMutableArray *)sum current:(NSString *)current;
- (void)PFImageViewController:(id)sender viewPicture:(UIImage *)image;

@end

@interface PFServiceViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) PFApi *Api;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmented;

@property (strong, nonatomic) NSMutableArray *arrObjService;
@property (strong, nonatomic) NSDictionary *objService;

@property (strong, nonatomic) NSMutableArray *arrObjPromotion;
@property (strong, nonatomic) NSDictionary *objPromotion;

@property NSUserDefaults *serviceOffline;

@property (strong, nonatomic) IBOutlet UIView *waitView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@property (strong, nonatomic) IBOutlet UIView *NoInternetView;
@property (strong, nonatomic) NSString *checkinternet;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSString *checksegmented;
@property (strong, nonatomic) NSString *checkstatus;

@property (strong, nonatomic) NSString *paging;

@end
