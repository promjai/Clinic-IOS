//
//  PFCommentViewController.m
//  Times Clinic
//
//  Created by Pariwat on 9/3/15.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import "PFCommentViewController.h"

@interface PFCommentViewController ()

@end

@implementation PFCommentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.0f/255.0f green:175.0f/255.0f blue:0.0f/255.0f alpha:1.0f]];
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.Api = [[PFApi alloc] init];
    self.Api.delegate = self;
    
    /* NavigationBar */
    [self setNavigationBar];
    
    [self.comment becomeFirstResponder];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

/* Set NavigationBar */

- (void)setNavigationBar {
    
    self.navigationItem.title = @"ข้อความ";
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"ส่ง" style:UIBarButtonItemStyleDone target:self action:@selector(sentcomment)];
    [rightButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                         [UIFont fontWithName:@"Helvetica" size:17.0],NSFontAttributeName,nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    
}

/* Sent Comment */

- (void)sentcomment {
    if (self.comment.text.length > 10) {
        
        [self.Api sendComment:self.comment.text];
    
    } else {

        [[[UIAlertView alloc] initWithTitle:nil
                                    message:@"กรุณากรอกมากกว่า 10 ตัวอักษร."
                                   delegate:nil
                          cancelButtonTitle:@"ตกลง"
                          otherButtonTitles:nil] show];
        
    }
}

/* Sent Comment API */

- (void)PFApi:(id)sender sendCommentResponse:(NSDictionary *)response {
    NSLog(@"%@",response);
    
    if ([[[response objectForKey:@"error"] objectForKey:@"type"] isEqualToString:@"Error"]) {
    
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:nil
                                                          message:@"ส่งข้อความล้มเหลว"
                                                         delegate:nil
                                                cancelButtonTitle:@"ตกลง"
                                                otherButtonTitles:nil];
        [message show];
    
    } else {
    
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"ข้อความถูกส่งแล้ว"
                                                          message:@"ขอขอบคุณสำหรับคำแนะนำ ติชมของท่าน ทางคลินิกยินดีจะนำไปปรับปรุงการบริการให้ดียิ่งขึ้น"
                                                         delegate:self
                                                cancelButtonTitle:@"เสร็จ"
                                                otherButtonTitles:nil];
        [message show];
    
    }
    
}

- (void)PFApi:(id)sender sendCommentErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        
        [self.comment resignFirstResponder];

    }
}

@end
