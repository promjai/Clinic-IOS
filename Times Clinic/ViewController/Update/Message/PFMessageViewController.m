//
//  PFMessageViewController.m
//  Times Clinic
//
//  Created by Pariwat Promjai on 3/27/2558 BE.
//  Copyright (c) 2558 Pariwat Promjai. All rights reserved.
//

#import "PFMessageViewController.h"

@interface PFMessageViewController ()

@end

@implementation PFMessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.0f/255.0f green:175.0f/255.0f blue:0.0f/255.0f alpha:1.0f]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    /* NavigationBar */
    [self setNavigationBar];
    
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
    
    self.navigationItem.title = @"ข้อความ";
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    
}

/* Set View */

- (void)setView {
    
    self.lb_detail.text = self.message;
    
    CGRect frame = self.lb_detail.frame;
    frame.size = [self.lb_detail sizeOfMultiLineLabel];
    [self.lb_detail sizeOfMultiLineLabel];
    
    [self.lb_detail setFrame:frame];
    int lines = self.lb_detail.frame.size.height/15;
    self.lb_detail.numberOfLines = lines;
    
    if (lines > 1) {
        
        UILabel *descText = [[UILabel alloc] initWithFrame:frame];
        descText.textColor = RGB(0, 0, 0);
        descText.text = self.lb_detail.text;
        descText.numberOfLines = lines;
        [descText setFont:[UIFont boldSystemFontOfSize:15]];
        self.lb_detail.alpha = 0;
        [self.headerView addSubview:descText];
        
        self.headerView.frame = CGRectMake(self.headerView.frame.origin.x, self.headerView.frame.origin.y, self.headerView.frame.size.width, self.headerView.frame.size.height+self.lb_detail.frame.size.height-20);
        
    }
    
    self.tableView.tableHeaderView = self.headerView;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        // 'Back' button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        if([self.delegate respondsToSelector:@selector(PFMessageViewControllerBack)]){
            [self.delegate PFMessageViewControllerBack];
        }
    }
}

@end
