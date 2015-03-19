//
//  PFEditProfileViewController.m
//  Times Clinic
//
//  Created by Pariwat Promjai on 3/14/2558 BE.
//  Copyright (c) 2558 Pariwat Promjai. All rights reserved.
//

#import "PFEditProfileViewController.h"

@interface PFEditProfileViewController ()

@end

@implementation PFEditProfileViewController

BOOL newMedia;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.0f/255.0f green:175.0f/255.0f blue:0.0f/255.0f alpha:1.0f]];
        self.meOffline = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.obj = [[NSDictionary alloc] init];
    
    [self.view addSubview:self.waitView];
    
    self.Api = [[PFApi alloc] init];
    self.Api.delegate = self;
    
    /* NavigationBar */
    [self setNavigationBar];
    
    self.tableView.tableHeaderView = self.headerView;
    
    /* API */
    [self.Api user];
    
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
    
    // Navbar setup
    [[self.navController navigationBar] setBarTintColor:[UIColor colorWithRed:242.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0f]];
    
    [[self.navController navigationBar] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:0.0f/255.0f green:175.0f/255.0f blue:0.0f/255.0f alpha:1.0f], NSForegroundColorAttributeName, nil]];
    
    [[self.navController navigationBar] setTranslucent:YES];
    [self.view addSubview:self.navController.view];
    
    self.navItem.title = @"แก้ไขโปรไฟล์";
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"ปิด" style:UIBarButtonItemStylePlain target:self action:@selector(close)];
    self.navItem.rightBarButtonItem = rightButton;
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    
}

/* Close */

- (void)close {

    [self.delegate PFEditProfileViewControllerBack];
    [self dismissModalViewControllerAnimated:YES];
    
}

/* User API */

- (void)PFApi:(id)sender userResponse:(NSDictionary *)response {
    NSLog(@"%@",response);
    
    self.obj = response;
    
    [self.waitView removeFromSuperview];
    
    [self.meOffline setObject:response forKey:@"meOffline"];
    [self.meOffline synchronize];
    
    self.lb_display_name.text = [response objectForKey:@"display_name"];
    
    NSString *picStr = [[response objectForKey:@"picture"] objectForKey:@"url"];
    self.img_thumUser.layer.masksToBounds = YES;
    self.img_thumUser.contentMode = UIViewContentModeScaleAspectFill;
    
    [DLImageLoader loadImageFromURL:picStr
                          completed:^(NSError *error, NSData *imgData) {
                              self.img_thumUser.image = [UIImage imageWithData:imgData];
                          }];
    
    self.txt_display_name.text = [response objectForKey:@"display_name"];
    self.txt_facebook.text = [response objectForKey:@"fb_name"];
    self.txt_email.text = [response objectForKey:@"email"];
    self.txt_website.text = [response objectForKey:@"website"];
    self.txt_tel.text = [response objectForKey:@"mobile"];
    self.txt_gender.text = [response objectForKey:@"gender"];
    
    NSString *myString = [[NSString alloc] initWithFormat:@"%@",[[self.meOffline objectForKey:@"meOffline"] objectForKey:@"birth_date"]];
    NSString *mySmallerString = [myString substringToIndex:10];
    self.txt_birthday.text = mySmallerString;
    
    if ([[response objectForKey:@"fb_id"] integerValue] != 0) {
        self.img_password.hidden = YES;
        self.bt_password.hidden = YES;
    }
    
}

- (void)PFApi:(id)sender userErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
    
    self.obj = [self.meOffline objectForKey:@"meOffline"];
    
    [self.waitView removeFromSuperview];
    
    self.lb_display_name.text = [[self.meOffline objectForKey:@"meOffline"] objectForKey:@"display_name"];
    
    NSString *picStr = [[[self.meOffline objectForKey:@"meOffline"] objectForKey:@"picture"] objectForKey:@"url"];
    self.img_thumUser.layer.masksToBounds = YES;
    self.img_thumUser.contentMode = UIViewContentModeScaleAspectFill;
    
    [DLImageLoader loadImageFromURL:picStr
                          completed:^(NSError *error, NSData *imgData) {
                              self.img_thumUser.image = [UIImage imageWithData:imgData];
                          }];
    
    self.txt_display_name.text = [[self.meOffline objectForKey:@"meOffline"] objectForKey:@"display_name"];
    self.txt_facebook.text = [[self.meOffline objectForKey:@"meOffline"] objectForKey:@"fb_name"];
    self.txt_email.text = [[self.meOffline objectForKey:@"meOffline"] objectForKey:@"email"];
    self.txt_website.text = [[self.meOffline objectForKey:@"meOffline"] objectForKey:@"website"];
    self.txt_tel.text = [[self.meOffline objectForKey:@"meOffline"] objectForKey:@"mobile"];
    self.txt_gender.text = [[self.meOffline objectForKey:@"meOffline"] objectForKey:@"gender"];
    
    NSString *myString = [[NSString alloc] initWithFormat:@"%@",[[self.meOffline objectForKey:@"meOffline"] objectForKey:@"birth_date"]];
    NSString *mySmallerString = [myString substringToIndex:10];
    self.txt_birthday.text = mySmallerString;
    
    if ([[[self.meOffline objectForKey:@"meOffline"] objectForKey:@"fb_id"] integerValue] != 0) {
        self.img_password.hidden = YES;
        self.bt_password.hidden = YES;
    }
    
}

/* Upload Img Tap */

- (IBAction)uploadPictureTapped:(id)sender {

    [self alertUpload];

}

/* Display Tap */

- (IBAction)displaynameTapped:(id)sender {
    
    PFEditDetailProfileViewController *editdetailView = [[PFEditDetailProfileViewController alloc] init];
    if(IS_WIDESCREEN) {
        editdetailView = [[PFEditDetailProfileViewController alloc] initWithNibName:@"PFEditDetailProfileViewController_Wide" bundle:nil];
    } else {
        editdetailView = [[PFEditDetailProfileViewController alloc] initWithNibName:@"PFEditDetailProfileViewController" bundle:nil];
    }
    editdetailView.delegate = self;
    editdetailView.obj = self.obj;
    editdetailView.titlename = @"แก้ไขชื่อผู้ใช้งาน";
    editdetailView.checkstatus = @"displayname";
    editdetailView.hidesBottomBarWhenPushed = YES;
    [self.navController pushViewController:editdetailView animated:YES];

}

/* Password Tap */

- (IBAction)passwordTapped:(id)sender {

    PFEditDetailProfileViewController *editdetailView = [[PFEditDetailProfileViewController alloc] init];
    if(IS_WIDESCREEN) {
        editdetailView = [[PFEditDetailProfileViewController alloc] initWithNibName:@"PFEditDetailProfileViewController_Wide" bundle:nil];
    } else {
        editdetailView = [[PFEditDetailProfileViewController alloc] initWithNibName:@"PFEditDetailProfileViewController" bundle:nil];
    }
    editdetailView.delegate = self;
    editdetailView.obj = self.obj;
    editdetailView.titlename = @"แก้ไขรหัสผ่าน";
    editdetailView.checkstatus = @"password";
    editdetailView.hidesBottomBarWhenPushed = YES;
    [self.navController pushViewController:editdetailView animated:YES];

}

/* Facebook Tap */

- (IBAction)facebookTapped:(id)sender {
    
    PFEditDetailProfileViewController *editdetailView = [[PFEditDetailProfileViewController alloc] init];
    if(IS_WIDESCREEN) {
        editdetailView = [[PFEditDetailProfileViewController alloc] initWithNibName:@"PFEditDetailProfileViewController_Wide" bundle:nil];
    } else {
        editdetailView = [[PFEditDetailProfileViewController alloc] initWithNibName:@"PFEditDetailProfileViewController" bundle:nil];
    }
    editdetailView.delegate = self;
    editdetailView.obj = self.obj;
    editdetailView.titlename = @"แก้ไขชื่อ facebook";
    editdetailView.checkstatus = @"facebook";
    editdetailView.hidesBottomBarWhenPushed = YES;
    [self.navController pushViewController:editdetailView animated:YES];

}

/* Email Tap */

- (IBAction)emailTapped:(id)sender {
    
    PFEditDetailProfileViewController *editdetailView = [[PFEditDetailProfileViewController alloc] init];
    if(IS_WIDESCREEN) {
        editdetailView = [[PFEditDetailProfileViewController alloc] initWithNibName:@"PFEditDetailProfileViewController_Wide" bundle:nil];
    } else {
        editdetailView = [[PFEditDetailProfileViewController alloc] initWithNibName:@"PFEditDetailProfileViewController" bundle:nil];
    }
    editdetailView.delegate = self;
    editdetailView.obj = self.obj;
    editdetailView.titlename = @"แก้ไข Email";
    editdetailView.checkstatus = @"email";
    editdetailView.hidesBottomBarWhenPushed = YES;
    [self.navController pushViewController:editdetailView animated:YES];

}

/* Website Tap */

- (IBAction)websiteTapped:(id)sender {
    
    PFEditDetailProfileViewController *editdetailView = [[PFEditDetailProfileViewController alloc] init];
    if(IS_WIDESCREEN) {
        editdetailView = [[PFEditDetailProfileViewController alloc] initWithNibName:@"PFEditDetailProfileViewController_Wide" bundle:nil];
    } else {
        editdetailView = [[PFEditDetailProfileViewController alloc] initWithNibName:@"PFEditDetailProfileViewController" bundle:nil];
    }
    editdetailView.delegate = self;
    editdetailView.obj = self.obj;
    editdetailView.titlename = @"แก้ไข Website";
    editdetailView.checkstatus = @"website";
    editdetailView.hidesBottomBarWhenPushed = YES;
    [self.navController pushViewController:editdetailView animated:YES];

}

/* Telephone Tap */

- (IBAction)telTapped:(id)sender {
    
    PFEditDetailProfileViewController *editdetailView = [[PFEditDetailProfileViewController alloc] init];
    if(IS_WIDESCREEN) {
        editdetailView = [[PFEditDetailProfileViewController alloc] initWithNibName:@"PFEditDetailProfileViewController_Wide" bundle:nil];
    } else {
        editdetailView = [[PFEditDetailProfileViewController alloc] initWithNibName:@"PFEditDetailProfileViewController" bundle:nil];
    }
    editdetailView.delegate = self;
    editdetailView.obj = self.obj;
    editdetailView.titlename = @"แก้ไขเบอร์โทรศัพท์";
    editdetailView.checkstatus = @"phone";
    editdetailView.hidesBottomBarWhenPushed = YES;
    [self.navController pushViewController:editdetailView animated:YES];

}

/* Gender Tap */

- (IBAction)genderTapped:(id)sender {

    PFEditDetailProfileViewController *editdetailView = [[PFEditDetailProfileViewController alloc] init];
    if(IS_WIDESCREEN) {
        editdetailView = [[PFEditDetailProfileViewController alloc] initWithNibName:@"PFEditDetailProfileViewController_Wide" bundle:nil];
    } else {
        editdetailView = [[PFEditDetailProfileViewController alloc] initWithNibName:@"PFEditDetailProfileViewController" bundle:nil];
    }
    editdetailView.delegate = self;
    editdetailView.obj = self.obj;
    editdetailView.titlename = @"แก้ไขเพศ";
    editdetailView.checkstatus = @"gender";
    editdetailView.hidesBottomBarWhenPushed = YES;
    [self.navController pushViewController:editdetailView animated:YES];

}

/* Birthday Tap */

- (IBAction)birthdayTapped:(id)sender {

    PFEditDetailProfileViewController *editdetailView = [[PFEditDetailProfileViewController alloc] init];
    if(IS_WIDESCREEN) {
        editdetailView = [[PFEditDetailProfileViewController alloc] initWithNibName:@"PFEditDetailProfileViewController_Wide" bundle:nil];
    } else {
        editdetailView = [[PFEditDetailProfileViewController alloc] initWithNibName:@"PFEditDetailProfileViewController" bundle:nil];
    }
    editdetailView.delegate = self;
    editdetailView.obj = self.obj;
    editdetailView.titlename = @"แก้ไขวันเกิด";
    editdetailView.checkstatus = @"birthday";
    editdetailView.hidesBottomBarWhenPushed = YES;
    [self.navController pushViewController:editdetailView animated:YES];
    
}

- (void)alertUpload {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"ยกเลิก"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"ถ่ายรูป", @"เลือกรูปจากอัลบั้ม", nil];
    [actionSheet showInView:[[[[UIApplication sharedApplication] keyWindow] subviews] lastObject]];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if ( buttonIndex == 0 ) {
        
        [self useCamera];
        
    } else if ( buttonIndex == 1 ) {
        
        [self useCameraRoll];
        
    }
}

- (void) useCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:   UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker =   [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString *) kUTTypeImage, nil];
        imagePicker.allowsEditing = YES;
        imagePicker.editing = YES;
        imagePicker.navigationBarHidden = YES;
        imagePicker.view.userInteractionEnabled = YES;
        [self presentViewController:imagePicker animated:YES completion:nil];
        newMedia = YES;
    }
}

- (void)useCameraRoll
{
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:242.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0f]];
    
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:0.0f/255.0f green:175.0f/255.0f blue:0.0f/255.0f alpha:1.0f], NSForegroundColorAttributeName, nil]];
    
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        UIImagePickerController *imagePicker =   [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =   UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString *) kUTTypeImage,nil];
        imagePicker.allowsEditing = YES;
        imagePicker.editing = YES;
        [self presentViewController:imagePicker animated:YES completion:nil];
        newMedia = NO;
    }
}

- (NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

- (NSString*)base64forData:(NSData*)theData {
    
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    NSString *base64String = [self base64forData:imageData];
    [self.Api userSetting:@"picture" value:base64String];
    
    [self.view addSubview:self.waitView];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        self.img_thumUser.image = image;
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self.waitView removeFromSuperview];
    [self dismissViewControllerAnimated:YES completion:nil];
}

/* User Setting API */

- (void)PFApi:(id)sender userSettingResponse:(NSDictionary *)response {
    NSLog(@"Upload Success %@",response);
    
    [self.Api user];
    
}

- (void)PFApi:(id)sender userSettingErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
}

- (void)PFEditDetailProfileViewControllerBack {

    [self viewDidLoad];
    
}

@end
