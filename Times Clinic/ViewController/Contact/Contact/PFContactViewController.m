//
//  PFContactViewController.m
//  Times Clinic
//
//  Created by Pariwat Promjai on 2/27/2558 BE.
//  Copyright (c) 2558 Pariwat Promjai. All rights reserved.
//

#import "PFContactViewController.h"

@interface PFContactViewController ()

@end

@implementation PFContactViewController

BOOL loadContact;
BOOL noDataContact;
BOOL refreshDataContact;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.0f/255.0f green:175.0f/255.0f blue:0.0f/255.0f alpha:1.0f]];
        self.contactOffline = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    loadContact = NO;
    noDataContact = NO;
    refreshDataContact = NO;
    
    [self.view addSubview:self.waitView];
    
    self.Api = [[PFApi alloc] init];
    self.Api.delegate = self;
    
    /* API */
    [self.Api getContact];
    
    self.tableView.tableHeaderView = self.headerView;
    
    /* NavigationBar */
    [self setNavigationBar];
    
    /* MapImage */
    [self setMapImage];
    
    /* View */
    [self setView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

/* Set NavigationBar */

- (void)setNavigationBar {
    
    self.navigationItem.title = @"ติดต่อ";
    
}

/* Set MapImage */

- (void)setMapImage {
    
    NSString *urlmap = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",@"http://maps.googleapis.com/maps/api/staticmap?center=",@"18.797633",@",",@"98.973255",@"&zoom=16&size=640x360&sensor=false&markers=color:red%7Clabel:o%7C",@"18.797633",@",",@"98.973255"];
    
    [DLImageLoader loadImageFromURL:urlmap
                          completed:^(NSError *error, NSData *imgData) {
                              self.img_map.image = [UIImage imageWithData:imgData];
                          }];
    
}

/* Set View */

- (void)setView {

    [self.bg_buttonView.layer setMasksToBounds:YES];
    [self.bg_buttonView.layer setCornerRadius:5.0f];
    
    [self.bt_comment.layer setMasksToBounds:YES];
    [self.bt_comment.layer setCornerRadius:5.0f];

}

/* Contact API */

- (void)PFApi:(id)sender getContactResponse:(NSDictionary *)response {
    NSLog(@"contact %@",response);
    
    self.obj = response;
    
    [self.waitView removeFromSuperview];
    
    [self.contactOffline setObject:response forKey:@"contactArray"];
    [self.contactOffline synchronize];
    
    self.txt_phone.text = [response objectForKey:@"phone"];
    self.txt_website.text = [response objectForKey:@"website"];
    self.txt_email.text = [response objectForKey:@"email"];
    self.txt_facebook.text = [[response objectForKey:@"facebook"] objectForKey:@"name"];
    self.txt_line.text = [[response objectForKey:@"line"] objectForKey:@"id"];
    
}

- (void)PFApi:(id)sender getContactErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
    
}

/* Map Tap */

- (IBAction)mapTapped:(id)sender {
    
    PFMapViewController *mapView = [[PFMapViewController alloc] init];
    if(IS_WIDESCREEN) {
        mapView = [[PFMapViewController alloc] initWithNibName:@"PFMapViewController_Wide" bundle:nil];
    } else {
        mapView = [[PFMapViewController alloc] initWithNibName:@"PFMapViewController" bundle:nil];
    }
    mapView.delegate = self;
    mapView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:mapView animated:YES];

}

/* Phone Tap */

- (IBAction)phoneTapped:(id)sender {

    if (![self.txt_phone.text isEqualToString:@""]) {
        
        NSString *phone = [[NSString alloc] initWithFormat:@"telprompt://%@",self.txt_phone.text];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
    
    }

}

/* Website Tap */

- (IBAction)websiteTapped:(id)sender {

    if (![self.txt_website.text isEqualToString:@""]) {
        
        NSString *website = [[NSString alloc] initWithFormat:@"%@",self.txt_website.text];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:website]];
        
    }

}

/* Email Tap */

- (IBAction)emailTapped:(id)sender {

    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"Select Menu"
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"Send Email", nil];
    [actionSheet showInView:[[[[UIApplication sharedApplication] keyWindow] subviews] lastObject]];
    
}

/* Facebook Tap */

- (IBAction)facebookTapped:(id)sender {

    NSString *stringURL = [[NSString alloc] initWithFormat:@"fb://profile/%@",[[self.obj objectForKey:@"facebook"] objectForKey:@"id"]];
    NSURL *url = [NSURL URLWithString:stringURL];
    [[UIApplication sharedApplication] openURL:url];

}

/* Line Tap */

- (IBAction)lineTapped:(id)sender {
    
    NSString *stringURL = [[NSString alloc] initWithFormat:@"line://ti/p/%@",[[self.obj objectForKey:@"line"] objectForKey:@"code"]];
    NSURL *url = [NSURL URLWithString:stringURL];
    [[UIApplication sharedApplication] openURL:url];

}

/* Comment Tap */

- (IBAction)commentTapped:(id)sender {
    
    if ([self.Api checkLogin] == false){
        
        self.loginView = [PFLoginViewController alloc];
        self.loginView.delegate = self;
        self.loginView.menu = @"comment";
        [self.view addSubview:self.loginView.view];
        
    }else{
    
        PFCommentViewController *commentView = [[PFCommentViewController alloc] init];
        if(IS_WIDESCREEN) {
            commentView = [[PFCommentViewController alloc] initWithNibName:@"PFCommentViewController_Wide" bundle:nil];
        } else {
            commentView = [[PFCommentViewController alloc] initWithNibName:@"PFCommentViewController" bundle:nil];
        }
        commentView.delegate = self;
        commentView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:commentView animated:YES];
        
    }

}

/* Return Login */

- (void)PFCommentViewController:(id)sender {
    
    PFCommentViewController *commentView = [[PFCommentViewController alloc] init];
    if(IS_WIDESCREEN) {
        commentView = [[PFCommentViewController alloc] initWithNibName:@"PFCommentViewController_Wide" bundle:nil];
    } else {
        commentView = [[PFCommentViewController alloc] initWithNibName:@"PFCommentViewController" bundle:nil];
    }
    commentView.delegate = self;
    commentView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:commentView animated:YES];
    
}

/* Power By Tap */

- (IBAction)powerbyTapped:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://pla2fusion.com/"]];

}

/* Send E-mail */

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    //Get the name of the current pressed button
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if  ([buttonTitle isEqualToString:@"Send Email"]) {
        
        // Email Subject
        NSString *emailTitle = nil;
        // Email Content
        NSString *messageBody = nil;
        // To address
        NSArray *toRecipents = [self.txt_email.text componentsSeparatedByString: @","];
        
        [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:242.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0f]];
        
        [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                               [UIColor colorWithRed:0.0f/255.0f green:175.0f/255.0f blue:0.0f/255.0f alpha:1.0f], NSForegroundColorAttributeName, nil]];
        
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        
        [mc.navigationBar setTintColor:[UIColor colorWithRed:0.0f/255.0f green:175.0f/255.0f blue:0.0f/255.0f alpha:1.0f]];
        [mc setSubject:emailTitle];
        [mc setMessageBody:messageBody isHTML:NO];
        [mc setToRecipients:toRecipents];
        
        // Present mail view controller on screen
        [self presentViewController:mc animated:YES completion:NULL];
        
    }
    if ([buttonTitle isEqualToString:@"Cancel"]) {
        NSLog(@"Cancel");
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            //[self reloadView];
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}

@end
