//
//  PFPromotionDetailViewController.m
//  Times Clinic
//
//  Created by Pariwat Promjai on 3/18/2558 BE.
//  Copyright (c) 2558 Pariwat Promjai. All rights reserved.
//

#import "PFPromotionDetailViewController.h"

@interface PFPromotionDetailViewController ()

@end

@implementation PFPromotionDetailViewController

int sum;
NSString *dte;
NSTimer *timer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.0f/255.0f green:175.0f/255.0f blue:0.0f/255.0f alpha:1.0f]];
        self.promotionDetailOffline = [NSUserDefaults standardUserDefaults];
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
    
    [self.bt_redeem.layer setMasksToBounds:YES];
    [self.bt_redeem.layer setCornerRadius:5.0f];
    
    [self.bt_used.layer setMasksToBounds:YES];
    [self.bt_used.layer setCornerRadius:5.0f];
    
    [self.Api getPromotionByID:[self.obj objectForKey:@"id"]];
    
}

/* Full Image Tap */

- (IBAction)fullimgTapped:(id)sender {
    
    [self.delegate PFImageViewController:self viewPicture:self.img_thumbnails.image];
    
}

/* Redeem Tap */

- (IBAction)redeemTapped:(id)sender {

    if ([self.Api checkLogin] == false){
        
        self.loginView = [PFLoginViewController alloc];
        self.loginView.delegate = self;
        self.loginView.menu = @"promotion";
        [self.view addSubview:self.loginView.view];
        
    }else{
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@""
                                                          message:@"คุณสามารถใช้คูปองได้ภายใน 60 นาที ต้องการใช้คูปองหรือไม่ ?"
                                                         delegate:self
                                                cancelButtonTitle:@"ยกเลิก"
                                                otherButtonTitles:@"ตกลง", nil];
        
        [message show];
        
    }
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // the user clicked OK
    if (buttonIndex == 1) {
        
        [self.redeemView removeFromSuperview];
        self.tableView.tableFooterView = self.codeView;
        
        [self.Api getPromotionRequest:[self.obj objectForKey:@"id"]];
        
    }
}

/* Return Promotion */

- (void)PFPromotionViewController:(id)sender {

    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@""
                                                      message:@"คุณสามารถใช้คูปองได้ภายใน 60 นาที ต้องการใช้คูปองหรือไม่ ?"
                                                     delegate:self
                                            cancelButtonTitle:@"ยกเลิก"
                                            otherButtonTitles:@"ตกลง", nil];
    
    [message show];
    
}

/* Promotion By ID API */

- (void)PFApi:(id)sender getPromotionResponse:(NSDictionary *)response {
    NSLog(@"%@",response);
    
    [self.promotionDetailOffline setObject:response forKey:@"promotionDetailArray"];
    [self.promotionDetailOffline synchronize];
    
    self.img_thumbnails.layer.masksToBounds = YES;
    self.img_thumbnails.contentMode = UIViewContentModeScaleAspectFill;
    
    NSString *urlimg = [[NSString alloc] initWithFormat:@"%@",[[response objectForKey:@"thumb"] objectForKey:@"url"]];
    
    [DLImageLoader loadImageFromURL:urlimg
                          completed:^(NSError *error, NSData *imgData) {
                              self.img_thumbnails.image = [UIImage imageWithData:imgData];
                          }];
    
    //name
    self.lb_name.text = [response objectForKey:@"name"];
    
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
    [self.headerView addSubview:descTextName];
    
    //detail
    self.lb_detail.frame = CGRectMake(self.lb_detail.frame.origin.x, self.lb_detail.frame.origin.y+self.lb_name.frame.size.height-20, self.lb_detail.frame.size.width, self.lb_detail.frame.size.height);
    
    self.lb_detail.text = [response objectForKey:@"detail"];
    
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
    
    //condition
    self.lb_condition.frame = CGRectMake(self.lb_condition.frame.origin.x, self.lb_condition.frame.origin.y+self.lb_detail.frame.size.height-10, self.lb_condition.frame.size.width, self.lb_condition.frame.size.height);
    
    self.lb_condition.text = [response objectForKey:@"condition"];
    CGRect frame1 = self.lb_condition.frame;
    frame1.size = [self.lb_condition sizeOfMultiLineLabel];
    [self.lb_condition sizeOfMultiLineLabel];
    
    [self.lb_condition setFrame:frame1];
    int lines1 = self.lb_condition.frame.size.height/15;
    self.lb_condition.numberOfLines = lines1;
    
    UILabel *descText1 = [[UILabel alloc] initWithFrame:frame1];
    descText1.textColor = RGB(102, 102, 102);
    descText1.text = self.lb_condition.text;
    descText1.numberOfLines = lines1;
    [descText1 setFont:[UIFont systemFontOfSize:15]];
    self.lb_condition.alpha = 0;
    [self.headerView addSubview:descText1];
    
    self.headerView.frame = CGRectMake(self.headerView.frame.origin.x, self.headerView.frame.origin.y, self.headerView.frame.size.width, self.headerView.frame.size.height+self.lb_detail.frame.size.height+self.lb_condition.frame.size.height-20);
    
    self.tableView.tableHeaderView = self.headerView;
    
    if ([[response objectForKey:@"used_status"] isEqualToString:@"none"]) {
        
        self.tableView.tableFooterView = self.redeemView;
        
    } else if ([[response objectForKey:@"used_status"] isEqualToString:@"countdown"]) {
        
        [self.Api getPromotionRequest:[response objectForKey:@"id"]];
        
    } else if ([[response objectForKey:@"used_status"] isEqualToString:@"timeout"]) {
        
        self.tableView.tableFooterView = self.usedView;
        
    }

}

- (void)PFApi:(id)sender getPromotionErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
    
    self.img_thumbnails.layer.masksToBounds = YES;
    self.img_thumbnails.contentMode = UIViewContentModeScaleAspectFill;
    
    NSString *urlimg = [[NSString alloc] initWithFormat:@"%@",[[[self.promotionDetailOffline objectForKey:@"promotionDetailArray"] objectForKey:@"thumb"] objectForKey:@"url"]];
    
    [DLImageLoader loadImageFromURL:urlimg
                          completed:^(NSError *error, NSData *imgData) {
                              self.img_thumbnails.image = [UIImage imageWithData:imgData];
                          }];
    
    //name
    self.lb_name.text = [[self.promotionDetailOffline objectForKey:@"promotionDetailArray"] objectForKey:@"name"];
    
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
    [self.headerView addSubview:descTextName];
    
    //detail
    self.lb_detail.frame = CGRectMake(self.lb_detail.frame.origin.x, self.lb_detail.frame.origin.y+self.lb_name.frame.size.height-20, self.lb_detail.frame.size.width, self.lb_detail.frame.size.height);
    
    self.lb_detail.text = [[self.promotionDetailOffline objectForKey:@"promotionDetailArray"] objectForKey:@"detail"];
    
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
    
    //condition
    self.lb_condition.frame = CGRectMake(self.lb_condition.frame.origin.x, self.lb_condition.frame.origin.y+self.lb_detail.frame.size.height-10, self.lb_condition.frame.size.width, self.lb_condition.frame.size.height);
    
    self.lb_condition.text = [[self.promotionDetailOffline objectForKey:@"promotionDetailArray"] objectForKey:@"condition"];
    CGRect frame1 = self.lb_condition.frame;
    frame1.size = [self.lb_condition sizeOfMultiLineLabel];
    [self.lb_condition sizeOfMultiLineLabel];
    
    [self.lb_condition setFrame:frame1];
    int lines1 = self.lb_condition.frame.size.height/15;
    self.lb_condition.numberOfLines = lines1;
    
    UILabel *descText1 = [[UILabel alloc] initWithFrame:frame1];
    descText1.textColor = RGB(102, 102, 102);
    descText1.text = self.lb_condition.text;
    descText1.numberOfLines = lines1;
    [descText1 setFont:[UIFont systemFontOfSize:15]];
    self.lb_condition.alpha = 0;
    [self.headerView addSubview:descText1];
    
    self.headerView.frame = CGRectMake(self.headerView.frame.origin.x, self.headerView.frame.origin.y, self.headerView.frame.size.width, self.headerView.frame.size.height+self.lb_detail.frame.size.height+self.lb_condition.frame.size.height-20);
    
    self.tableView.tableHeaderView = self.headerView;
    
}

/* Promotion Request API */

- (void)PFApi:(id)sender getPromotionRequestResponse:(NSDictionary *)response {
    NSLog(@"%@",response);
    
    if ([[response objectForKey:@"expire"] intValue] == 0) {
        
        [self.codeView removeFromSuperview];
        self.tableView.tableFooterView = self.usedView;
        
    } else {
        
        self.tableView.tableFooterView = self.codeView;
        
        self.lb_code.text = [response objectForKey:@"code"];
        
        NSDate *today = [NSDate date];
        NSTimeInterval interval  = [today timeIntervalSince1970] ;
        int myInt = (int)interval;
        
        NSString *expireString = [response objectForKey:@"expire"];
        NSDateFormatter *expireFormatter = [[NSDateFormatter alloc] init];
        [expireFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *expireFromString = [[NSDate alloc] init];
        expireFromString = [expireFormatter dateFromString:expireString];
        
        NSTimeInterval intervalExpire  = [expireFromString timeIntervalSince1970] ;
        int expireInt = (int)intervalExpire;
        
        sum = expireInt - myInt;
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:sum];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"mm:ss"];
        
        dte = [dateFormatter stringFromDate:date];
        
        self.lb_time.text = [[NSString alloc] initWithFormat:@"เหลือเวลาอีก 00:%@",dte];
        
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countTime:) userInfo:nil repeats:YES];
        
    }

}

- (void)PFApi:(id)sender getPromotionRequestErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
}

/* Count Time */

-(void)countTime:(NSTimer *)timer {
    
    sum = sum - 1;
    
    if (sum == 0) {
        
        [self.codeView removeFromSuperview];
        self.tableView.tableFooterView = self.usedView;
        
    } else {
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:sum];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"mm:ss"];
        
        dte = [dateFormatter stringFromDate:date];
        self.lb_time.text = [[NSString alloc] initWithFormat:@"เหลือเวลาอีก 00:%@",dte];
        
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {

            [timer invalidate];

    }
}

@end
