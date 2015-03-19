//
//  PFServiceDetailViewController.m
//  Times Clinic
//
//  Created by Pariwat Promjai on 3/18/2558 BE.
//  Copyright (c) 2558 Pariwat Promjai. All rights reserved.
//

#import "PFServiceDetailViewController.h"

@interface PFServiceDetailViewController ()

@end

@implementation PFServiceDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.0f/255.0f green:175.0f/255.0f blue:0.0f/255.0f alpha:1.0f]];
        self.serviceDetailOffline = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    [self.bt_consult.layer setMasksToBounds:YES];
    [self.bt_consult.layer setCornerRadius:5.0f];

    images = [[NSMutableArray alloc]init];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [scrollView addGestureRecognizer:singleTap];
    
    NSString *id = [NSString stringWithFormat:@"%@",[self.obj objectForKey:@"id"]];
    [self.Api getServiceByID:id];
    
    self.lb_name.text = [self.obj objectForKey:@"name"];
    self.lb_price.text = [[NSString alloc] initWithFormat:@"%@ %@",[self.obj objectForKey:@"price"],@"บาท"];
    self.lb_detail.text = [self.obj objectForKey:@"detail"];
    
    NSString *urlimg = [[NSString alloc] initWithFormat:@"%@",[[self.obj objectForKey:@"thumb"] objectForKey:@"url"]];
    
    self.imageView1.layer.masksToBounds = YES;
    self.imageView1.contentMode = UIViewContentModeScaleAspectFill;
    
    [DLImageLoader loadImageFromURL:urlimg
                          completed:^(NSError *error, NSData *imgData) {
                              self.imageView1.image = [UIImage imageWithData:imgData];
                          }];
    
    self.lb_name1.text = [self.obj objectForKey:@"name"];
    self.lb_price1.text = [[NSString alloc] initWithFormat:@"%@ %@",[self.obj objectForKey:@"price"],@"บาท"];
    self.lb_detail1.text = [self.obj objectForKey:@"detail"];

}

/* Single Tap Gesture Captured */

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    CGPoint touchPoint=[gesture locationInView:scrollView];
    for(int index=0;index<[images count];index++)
    {
        UIImageView *imgView = [images objectAtIndex:index];
        
        if(CGRectContainsPoint([imgView frame], touchPoint))
        {
            self.current = [NSString stringWithFormat:@"%d",index];
            [self ShowDetailView:imgView];
            break;
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [[event allTouches] anyObject];
    
    for(int index=0;index<[images count];index++)
    {
        UIImageView *imgView = [images objectAtIndex:index];
        
        if(CGRectContainsPoint([imgView frame], [touch locationInView:scrollView]))
        {
            [self ShowDetailView:imgView];
            break;
        }
    }
}

-(void)ShowDetailView:(UIImageView *)imgView
{
    imageView.image = imgView.image;
    imageView.layer.masksToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
}

/* Service API */

- (void)PFApi:(id)sender getServiceResponse:(NSDictionary *)response {
    NSLog(@"%@",response);
    
    [self.waitView removeFromSuperview];
    
    [self.serviceDetailOffline removeObjectForKey:@"serviceDetailArray"];
    
    [self.serviceDetailOffline setObject:response forKey:[self.obj objectForKey:@"id"]];
    [self.serviceDetailOffline synchronize];
    
    NSString *length = [NSString stringWithFormat:@"%@",[response objectForKey:@"length"]];
    int num = length.intValue;
    
    if (num <= 1) {
        
        //name
        CGRect frameName1 = self.lb_name1.frame;
        frameName1.size = [self.lb_name1 sizeOfMultiLineLabel];
        [self.lb_name1 sizeOfMultiLineLabel];
        
        [self.lb_name1 setFrame:frameName1];
        int linesName1 = self.lb_name1.frame.size.height/15;
        self.lb_name1.numberOfLines = linesName1;
        
        UILabel *descTextName1 = [[UILabel alloc] initWithFrame:frameName1];
        descTextName1.textColor = RGB(0, 0, 0);
        descTextName1.text = self.lb_name1.text;
        descTextName1.numberOfLines = linesName1;
        [descTextName1 setFont:[UIFont boldSystemFontOfSize:17]];
        self.lb_name1.alpha = 0;
        [self.headerImgView addSubview:descTextName1];
        
        //price
        self.lb_price1.frame = CGRectMake(self.lb_price1.frame.origin.x, self.lb_price1.frame.origin.y+self.lb_name1.frame.size.height-20, self.lb_price1.frame.size.width, self.lb_price1.frame.size.height);
        
        //detail
        self.lb_detail1.frame = CGRectMake(self.lb_detail1.frame.origin.x, self.lb_detail1.frame.origin.y+self.lb_price1.frame.size.height-20, self.lb_detail1.frame.size.width, self.lb_detail1.frame.size.height);
        
        CGRect frame = self.lb_detail1.frame;
        frame.size = [self.lb_detail1 sizeOfMultiLineLabel];
        [self.lb_detail1 sizeOfMultiLineLabel];
        
        [self.lb_detail1 setFrame:frame];
        int lines = self.lb_detail1.frame.size.height/15;
        self.lb_detail1.numberOfLines = lines;
        
        UILabel *descText = [[UILabel alloc] initWithFrame:frame];
        descText.textColor = RGB(102, 102, 102);
        descText.text = self.lb_detail1.text;
        descText.numberOfLines = lines;
        [descText setFont:[UIFont systemFontOfSize:15]];
        self.lb_detail1.alpha = 0;
        [self.headerImgView addSubview:descText];
        
        self.headerImgView.frame = CGRectMake(self.headerImgView.frame.origin.x, self.headerImgView.frame.origin.y, self.headerImgView.frame.size.width, self.headerImgView.frame.size.height+self.lb_name1.frame.size.height+self.lb_detail1.frame.size.height-20);
        
        self.tableView.tableHeaderView = self.headerImgView;
        self.tableView.tableFooterView = self.footerView;
        
    } else {
        
        //name
        CGRect frameName = self.lb_name.frame;
        frameName.size = [self.lb_name sizeOfMultiLineLabel];
        [self.lb_name sizeOfMultiLineLabel];
        
        [self.lb_name setFrame:frameName];
        int linesName = self.lb_name.frame.size.height/15;
        self.lb_name.numberOfLines = linesName;
        
        UILabel *descTextName = [[UILabel alloc] initWithFrame:frameName];
        descTextName.textColor = RGB(0, 0, 0);
        descTextName.text = self.lb_name.text;
        descTextName.numberOfLines = linesName;
        [descTextName setFont:[UIFont boldSystemFontOfSize:17]];
        self.lb_name.alpha = 0;
        [self.headerView addSubview:descTextName];
        
        //price
        self.lb_price.frame = CGRectMake(self.lb_price.frame.origin.x, self.lb_price.frame.origin.y+self.lb_name.frame.size.height-20, self.lb_price.frame.size.width, self.lb_price.frame.size.height);
        
        //detail
        self.lb_detail.frame = CGRectMake(self.lb_detail.frame.origin.x, self.lb_detail.frame.origin.y+self.lb_price.frame.size.height-20, self.lb_detail.frame.size.width, self.lb_detail.frame.size.height);
        
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
        [self.headerView addSubview:descText];
        
        self.headerView.frame = CGRectMake(self.headerView.frame.origin.x, self.headerView.frame.origin.y, self.headerView.frame.size.width, self.headerView.frame.size.height+self.lb_name.frame.size.height+self.lb_detail.frame.size.height-20);
        
        self.tableView.tableHeaderView = self.headerView;
        self.tableView.tableFooterView = self.footerView;
        
        scrollView.delegate = self;
        scrollView.scrollEnabled = YES;
        int scrollWidth = 70;
        scrollView.contentSize = CGSizeMake(scrollWidth,70);
        
        int xOffset = 0;
        
        NSString *urlimg = [[NSString alloc] initWithFormat:@"%@",[[[response objectForKey:@"data"] objectAtIndex:0] objectForKey:@"url"]];
        
        imageView.layer.masksToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        [DLImageLoader loadImageFromURL:urlimg
                              completed:^(NSError *error, NSData *imgData) {
                                  imageView.image = [UIImage imageWithData:imgData];
                              }];
        
        self.arrgalleryimg = [[NSMutableArray alloc] init];
        
        for (int i=0; i<[[response objectForKey:@"data"] count]; ++i) {
            //
            AsyncImageView *img = [[AsyncImageView alloc] init];
            
            img.layer.masksToBounds = YES;
            img.contentMode = UIViewContentModeScaleAspectFill;
            
            img.frame = CGRectMake(xOffset, 0, 70, 70);
            
            NSString *urlimg = [[NSString alloc] initWithFormat:@"%@",[[[response objectForKey:@"data"] objectAtIndex:i] objectForKey:@"url"]];
            
            [DLImageLoader loadImageFromURL:urlimg
                                  completed:^(NSError *error, NSData *imgData) {
                                      img.image = [UIImage imageWithData:imgData];
                                  }];
            
            [images insertObject:img atIndex:i];
            
            [self.arrgalleryimg addObject:[[[response objectForKey:@"data"] objectAtIndex:i] objectForKey:@"url"]];
            
            scrollView.contentSize = CGSizeMake(scrollWidth+xOffset,70);
            [scrollView addSubview:[images objectAtIndex:i]];
            
            xOffset += 70;
        }
    }
    
}

- (void)PFApi:(id)sender getServiceErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
    
    [self.waitView removeFromSuperview];
    
    NSString *length = [NSString stringWithFormat:@"%@",[[self.serviceDetailOffline objectForKey:[self.obj objectForKey:@"id"]] objectForKey:@"length"]];
    int num = length.intValue;
    
    if (num <= 1) {
        
        //name
        CGRect frameName1 = self.lb_name1.frame;
        frameName1.size = [self.lb_name1 sizeOfMultiLineLabel];
        [self.lb_name1 sizeOfMultiLineLabel];
        
        [self.lb_name1 setFrame:frameName1];
        int linesName1 = self.lb_name1.frame.size.height/15;
        self.lb_name1.numberOfLines = linesName1;
        
        UILabel *descTextName1 = [[UILabel alloc] initWithFrame:frameName1];
        descTextName1.textColor = RGB(0, 0, 0);
        descTextName1.text = self.lb_name1.text;
        descTextName1.numberOfLines = linesName1;
        [descTextName1 setFont:[UIFont boldSystemFontOfSize:17]];
        self.lb_name1.alpha = 0;
        [self.headerImgView addSubview:descTextName1];
        
        //price
        self.lb_price1.frame = CGRectMake(self.lb_price1.frame.origin.x, self.lb_price1.frame.origin.y+self.lb_name1.frame.size.height-20, self.lb_price1.frame.size.width, self.lb_price1.frame.size.height);
        
        //detail
        self.lb_detail1.frame = CGRectMake(self.lb_detail1.frame.origin.x, self.lb_detail1.frame.origin.y+self.lb_price1.frame.size.height-20, self.lb_detail1.frame.size.width, self.lb_detail1.frame.size.height);
        
        CGRect frame = self.lb_detail1.frame;
        frame.size = [self.lb_detail1 sizeOfMultiLineLabel];
        [self.lb_detail1 sizeOfMultiLineLabel];
        
        [self.lb_detail1 setFrame:frame];
        int lines = self.lb_detail1.frame.size.height/15;
        self.lb_detail1.numberOfLines = lines;
        
        UILabel *descText = [[UILabel alloc] initWithFrame:frame];
        descText.textColor = RGB(102, 102, 102);
        descText.text = self.lb_detail1.text;
        descText.numberOfLines = lines;
        [descText setFont:[UIFont systemFontOfSize:15]];
        self.lb_detail1.alpha = 0;
        [self.headerImgView addSubview:descText];
        
        self.headerImgView.frame = CGRectMake(self.headerImgView.frame.origin.x, self.headerImgView.frame.origin.y, self.headerImgView.frame.size.width, self.headerImgView.frame.size.height+self.lb_name1.frame.size.height+self.lb_detail1.frame.size.height-20);
        
        
        self.tableView.tableHeaderView = self.headerImgView;
        self.tableView.tableFooterView = self.footerView;
        
    } else {
        
        //name
        CGRect frameName = self.lb_name.frame;
        frameName.size = [self.lb_name sizeOfMultiLineLabel];
        [self.lb_name sizeOfMultiLineLabel];
        
        [self.lb_name setFrame:frameName];
        int linesName = self.lb_name.frame.size.height/15;
        self.lb_name.numberOfLines = linesName;
        
        UILabel *descTextName = [[UILabel alloc] initWithFrame:frameName];
        descTextName.textColor = RGB(0, 0, 0);
        descTextName.text = self.lb_name.text;
        descTextName.numberOfLines = linesName;
        [descTextName setFont:[UIFont boldSystemFontOfSize:17]];
        self.lb_name.alpha = 0;
        [self.headerView addSubview:descTextName];
        
        //price
        self.lb_price.frame = CGRectMake(self.lb_price.frame.origin.x, self.lb_price.frame.origin.y+self.lb_name.frame.size.height-20, self.lb_price.frame.size.width, self.lb_price.frame.size.height);
        
        //detail
        self.lb_detail.frame = CGRectMake(self.lb_detail.frame.origin.x, self.lb_detail.frame.origin.y+self.lb_name.frame.size.height-20, self.lb_detail.frame.size.width, self.lb_detail.frame.size.height);
        
        
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
        [self.headerView addSubview:descText];
        
        self.headerView.frame = CGRectMake(self.headerView.frame.origin.x, self.headerView.frame.origin.y, self.headerView.frame.size.width, self.headerView.frame.size.height+self.lb_name.frame.size.height+self.lb_detail.frame.size.height-20);
        
        self.tableView.tableHeaderView = self.headerView;
        self.tableView.tableFooterView = self.footerView;
        
        scrollView.delegate = self;
        scrollView.scrollEnabled = YES;
        int scrollWidth = 70;
        scrollView.contentSize = CGSizeMake(scrollWidth,70);
        
        int xOffset = 0;
        
        NSString *urlimg = [[NSString alloc] initWithFormat:@"%@",[[[[self.serviceDetailOffline objectForKey:[self.obj objectForKey:@"id"]] objectForKey:@"data"] objectAtIndex:0] objectForKey:@"url"]];
        
        [DLImageLoader loadImageFromURL:urlimg
                              completed:^(NSError *error, NSData *imgData) {
                                  imageView.image = [UIImage imageWithData:imgData];
                              }];
        
        imageView.layer.masksToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        self.arrgalleryimg = [[NSMutableArray alloc] init];
        
        for (int i=0; i<[[[self.serviceDetailOffline objectForKey:[self.obj objectForKey:@"id"]] objectForKey:@"data"] count]; ++i) {
            //
            AsyncImageView *img = [[AsyncImageView alloc] init];
            
            img.layer.masksToBounds = YES;
            img.contentMode = UIViewContentModeScaleAspectFill;
            
            img.frame = CGRectMake(xOffset, 0, 70, 70);
            
            NSString *urlimg = [[NSString alloc] initWithFormat:@"%@",[[[[self.serviceDetailOffline objectForKey:[self.obj objectForKey:@"id"]] objectForKey:@"data"] objectAtIndex:i] objectForKey:@"url"]];
            
            [DLImageLoader loadImageFromURL:urlimg
                                  completed:^(NSError *error, NSData *imgData) {
                                      img.image = [UIImage imageWithData:imgData];
                                  }];
            
            [images insertObject:img atIndex:i];
            
            [self.arrgalleryimg addObject:[[[[self.serviceDetailOffline objectForKey:[self.obj objectForKey:@"id"]] objectForKey:@"data"] objectAtIndex:i] objectForKey:@"url"]];
            
            scrollView.contentSize = CGSizeMake(scrollWidth+xOffset,70);
            [scrollView addSubview:[images objectAtIndex:i]];
            
            xOffset += 70;
        }
    }
    
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

/* Full Image Gallery */

- (IBAction)fullimgalbumTapped:(id)sender {
    [self.delegate PFGalleryViewController:self sum:self.arrgalleryimg current:self.current];
}

/* Full Image */

- (IBAction)fullimgTapped:(id)sender {
    [self.delegate PFImageViewController:self viewPicture:self.imageView1.image];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        // 'Back' button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        if([self.delegate respondsToSelector:@selector(PFServiceDetailViewControllerBack)]){
            [self.delegate PFServiceDetailViewControllerBack];
        }
    }
}

@end
