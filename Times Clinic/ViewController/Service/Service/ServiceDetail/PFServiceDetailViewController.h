//
//  PFServiceDetailViewController.h
//  Times Clinic
//
//  Created by Pariwat Promjai on 3/18/2558 BE.
//  Copyright (c) 2558 Pariwat Promjai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <FacebookSDK/FacebookSDK.h>
#import "ScrollView.h"
#import "DLImageLoader.h"
#import "AsyncImageView.h"
#import "UILabel+UILabelDynamicHeight.h"

#import "PFApi.h"

#import "PFConsultViewController.h"

@protocol PFServiceDetailViewControllerDelegate <NSObject>

- (void)PFGalleryViewController:(id)sender sum:(NSMutableArray *)sum current:(NSString *)current;
- (void)PFImageViewController:(id)sender viewPicture:(UIImage *)image;
- (void)PFServiceDetailViewControllerBack;

@end

@interface PFServiceDetailViewController : UIViewController < UIScrollViewDelegate> {
    
    IBOutlet ScrollView *scrollView;
    IBOutlet AsyncImageView *imageView;
    NSMutableArray *images;
    NSArray *imagesName;
    
}

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) PFApi *Api;
@property (strong, nonatomic) NSMutableArray *arrObj;
@property (strong, nonatomic) NSDictionary *obj;

@property NSUserDefaults *serviceDetailOffline;

@property (strong, nonatomic) IBOutlet UIView *waitView;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *headerImgView;

@property (strong, nonatomic) NSMutableArray *arrgalleryimg;
@property (strong, nonatomic) NSString *current;

@property (strong, nonatomic) IBOutlet UILabel_UILabelDynamicHeight *lb_name;
@property (strong, nonatomic) IBOutlet UILabel *lb_price;
@property (strong, nonatomic) IBOutlet UILabel_UILabelDynamicHeight *lb_detail;

@property (strong, nonatomic) IBOutlet AsyncImageView *imageView1;
@property (strong, nonatomic) IBOutlet UILabel_UILabelDynamicHeight *lb_name1;
@property (strong, nonatomic) IBOutlet UILabel *lb_price1;
@property (strong, nonatomic) IBOutlet UILabel_UILabelDynamicHeight *lb_detail1;

-(void)ShowDetailView:(UIImageView *)imgView;

@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (strong, nonatomic) IBOutlet UIButton *bt_consult;

//Button Tap
- (IBAction)fullimgTapped:(id)sender;
- (IBAction)fullimgalbumTapped:(id)sender;
- (IBAction)consultTapped:(id)sender;

@end
