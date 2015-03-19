//
//  PFUpdateDetailViewController.m
//  Times Clinic
//
//  Created by Pariwat Promjai on 3/17/2558 BE.
//  Copyright (c) 2558 Pariwat Promjai. All rights reserved.
//

#import "PFUpdateDetailViewController.h"

@interface PFUpdateDetailViewController ()

@end

@implementation PFUpdateDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_share"] style:UIBarButtonItemStyleDone target:self action:@selector(share)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    
}

/* Share Onclick */

- (void)share {
    
    // Check if the Facebook app is installed and we can present the share dialog
    FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
    params.link = [NSURL URLWithString:[[self.obj objectForKey:@"node"] objectForKey:@"share"]];
    
    // If the Facebook app is installed and we can present the share dialog
    if ([FBDialogs canPresentShareDialogWithParams:params]) {
        
        // Present share dialog
        [FBDialogs presentShareDialogWithLink:params.link
                                      handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                          if(error) {
                                              // An error occurred, we need to handle the error
                                              // See: https://developers.facebook.com/docs/ios/errors
                                              NSLog(@"Error publishing story: %@", error.description);
                                          } else {
                                              // Success
                                              NSLog(@"result %@", results);
                                          }
                                      }];
        
        // If the Facebook app is NOT installed and we can't present the share dialog
    } else {
        // FALLBACK: publish just a link using the Feed dialog
        
        // Put together the dialog parameters
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       nil, @"name",
                                       nil, @"caption",
                                       nil, @"description",
                                       [[self.obj objectForKey:@"node"] objectForKey:@"share"], @"link",
                                       nil, @"picture",
                                       nil];
        
        // Show the feed dialog
        [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                               parameters:params
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      if (error) {
                                                          // An error occurred, we need to handle the error
                                                          // See: https://developers.facebook.com/docs/ios/errors
                                                          NSLog(@"Error publishing story: %@", error.description);
                                                      } else {
                                                          if (result == FBWebDialogResultDialogNotCompleted) {
                                                              // User canceled.
                                                              NSLog(@"User cancelled.");
                                                          } else {
                                                              // Handle the publish feed callback
                                                              NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                              
                                                              if (![urlParams valueForKey:@"post_id"]) {
                                                                  // User canceled.
                                                                  NSLog(@"User cancelled.");
                                                                  
                                                              } else {
                                                                  // User clicked the Share button
                                                                  NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                                  NSLog(@"result %@", result);
                                                              }
                                                          }
                                                      }
                                                  }];
    }
    
}

// A function for parsing URL parameters returned by the Feed Dialog.
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}

/* Set View */

- (void)setView {
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fullimage:)];
    [self.img_thumbnails addGestureRecognizer:singleTap];
    [self.img_thumbnails setMultipleTouchEnabled:YES];
    [self.img_thumbnails setUserInteractionEnabled:YES];
    
    self.img_thumbnails.layer.masksToBounds = YES;
    self.img_thumbnails.contentMode = UIViewContentModeScaleAspectFill;
    
    NSString *urlimg = [[NSString alloc] initWithFormat:@"%@",[[self.obj objectForKey:@"thumb"] objectForKey:@"url"]];
    
    NSString *getheight = [[self.obj objectForKey:@"thumb"] objectForKey:@"height"];
    int height = [getheight intValue];
    
    NSString *getwidth = [[self.obj objectForKey:@"thumb"] objectForKey:@"width"];
    int width = [getwidth intValue];
    
    if (width == 320) {
        
        self.img_thumbnails.frame = CGRectMake(self.img_thumbnails.frame.origin.x, self.img_thumbnails.frame.origin.y, 320, height);
        
        [DLImageLoader loadImageFromURL:urlimg
                              completed:^(NSError *error, NSData *imgData) {
                                  self.img_thumbnails.image = [UIImage imageWithData:imgData];
                              }];
        
        //name
        self.lb_name.text = [self.obj objectForKey:@"name"];
        
        CGRect frameName = self.lb_name.frame;
        frameName.size = [self.lb_name sizeOfMultiLineLabel];
        [self.lb_name sizeOfMultiLineLabel];
        
        [self.lb_name setFrame:frameName];
        int linesName = self.lb_name.frame.size.height/15;
        self.lb_name.numberOfLines = linesName;
        
        UILabel *descTextName = [[UILabel alloc] initWithFrame:frameName];
        descTextName.textColor = RGB(207, 0, 15);
        descTextName.text = self.lb_name.text;
        descTextName.numberOfLines = linesName;
        [descTextName setFont:[UIFont boldSystemFontOfSize:17]];
        self.lb_name.alpha = 0;
        [self.footerView addSubview:descTextName];
        
        //detail
        
        self.lb_detail.frame = CGRectMake(self.lb_detail.frame.origin.x, self.lb_detail.frame.origin.y+self.lb_name.frame.size.height-20, self.lb_detail.frame.size.width, self.lb_detail.frame.size.height);
        
        self.lb_detail.text = [self.obj objectForKey:@"detail"];
        
        CGRect frame = self.lb_detail.frame;
        frame.size = [self.lb_detail sizeOfMultiLineLabel];
        [self.lb_detail sizeOfMultiLineLabel];
        
        [self.lb_detail setFrame:frame];
        int lines = self.lb_detail.frame.size.height/15;
        self.lb_detail.numberOfLines = lines;
        
        UILabel *descText = [[UILabel alloc] initWithFrame:frame];
        descText.textColor = RGB(102, 102, 102);
        descText.text = self.lb_detail.text;
        descText.numberOfLines = lines;
        [descText setFont:[UIFont systemFontOfSize:15]];
        self.lb_detail.alpha = 0;
        [self.footerView addSubview:descText];
        
        self.headerView.frame = CGRectMake(self.headerView.frame.origin.x, self.headerView.frame.origin.y, self.headerView.frame.size.width, self.headerView.frame.size.height+height-10);
        
        self.footerView.frame = CGRectMake(self.footerView.frame.origin.x, self.footerView.frame.origin.y, self.footerView.frame.size.width, self.footerView.frame.size.height+self.lb_name.frame.size.height+self.lb_detail.frame.size.height-20);
        
        self.tableView.tableHeaderView = self.headerView;
        self.tableView.tableFooterView = self.footerView;
        
    } else {
        
        int sumheight = (height*320)/width;
        
        self.img_thumbnails.frame = CGRectMake(self.img_thumbnails.frame.origin.x, self.img_thumbnails.frame.origin.y, 320, sumheight);
        
        [DLImageLoader loadImageFromURL:urlimg
                              completed:^(NSError *error, NSData *imgData) {
                                  self.img_thumbnails.image = [UIImage imageWithData:imgData];
                              }];
        
        //name
        self.lb_name.text = [self.obj objectForKey:@"name"];
        
        CGRect frameName = self.lb_name.frame;
        frameName.size = [self.lb_name sizeOfMultiLineLabel];
        [self.lb_name sizeOfMultiLineLabel];
        
        [self.lb_name setFrame:frameName];
        int linesName = self.lb_name.frame.size.height/15;
        self.lb_name.numberOfLines = linesName;
        
        UILabel *descTextName = [[UILabel alloc] initWithFrame:frameName];
        descTextName.textColor = RGB(207, 0, 15);
        descTextName.text = self.lb_name.text;
        descTextName.numberOfLines = linesName;
        [descTextName setFont:[UIFont boldSystemFontOfSize:17]];
        self.lb_name.alpha = 0;
        [self.footerView addSubview:descTextName];
        
        //detail
        
        self.lb_detail.frame = CGRectMake(self.lb_detail.frame.origin.x, self.lb_detail.frame.origin.y+self.lb_name.frame.size.height-20, self.lb_detail.frame.size.width, self.lb_detail.frame.size.height);
        
        self.lb_detail.text = [self.obj objectForKey:@"detail"];
        
        CGRect frame = self.lb_detail.frame;
        frame.size = [self.lb_detail sizeOfMultiLineLabel];
        [self.lb_detail sizeOfMultiLineLabel];
        
        [self.lb_detail setFrame:frame];
        int lines = self.lb_detail.frame.size.height/15;
        self.lb_detail.numberOfLines = lines;
        
        UILabel *descText = [[UILabel alloc] initWithFrame:frame];
        descText.textColor = RGB(102, 102, 102);
        descText.text = self.lb_detail.text;
        descText.numberOfLines = lines;
        [descText setFont:[UIFont systemFontOfSize:15]];
        self.lb_detail.alpha = 0;
        [self.footerView addSubview:descText];
        
        self.headerView.frame = CGRectMake(self.headerView.frame.origin.x, self.headerView.frame.origin.y, self.headerView.frame.size.width, self.headerView.frame.size.height+sumheight-10);
        
        self.footerView.frame = CGRectMake(self.footerView.frame.origin.x, self.footerView.frame.origin.y, self.footerView.frame.size.width, self.footerView.frame.size.height+self.lb_name.frame.size.height+self.lb_detail.frame.size.height-20);
        
        self.tableView.tableHeaderView = self.headerView;
        self.tableView.tableFooterView = self.footerView;
        
    }

    
}

/* Full Image */

- (void)fullimage:(UIGestureRecognizer *)gesture {
    
    [self.delegate PFImageViewController:self viewPicture:self.img_thumbnails.image];
    
}

@end
