//
//  PFUpdateDetailViewController.h
//  Times Clinic
//
//  Created by Pariwat Promjai on 3/17/2558 BE.
//  Copyright (c) 2558 Pariwat Promjai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <FacebookSDK/FacebookSDK.h>
#import "DLImageLoader.h"
#import "UILabel+UILabelDynamicHeight.h"

@protocol PFUpdateDetailViewControllerDelegate <NSObject>

- (void)PFImageViewController:(id)sender viewPicture:(UIImage *)image;
- (void)PFUpdateDetailViewControllerBack;

@end

@interface PFUpdateDetailViewController : UIViewController

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) NSDictionary *obj;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *footerView;

@property (weak, nonatomic) IBOutlet UILabel_UILabelDynamicHeight *lb_name;
@property (weak, nonatomic) IBOutlet UILabel_UILabelDynamicHeight *lb_detail;
@property (weak, nonatomic) IBOutlet UIImageView *img_thumbnails;

@end
