//
//  PFServiceViewController.m
//  Times Clinic
//
//  Created by Pariwat Promjai on 2/27/2558 BE.
//  Copyright (c) 2558 Pariwat Promjai. All rights reserved.
//

#import "PFServiceViewController.h"

@interface PFServiceViewController ()

@end

@implementation PFServiceViewController

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
    
    /* NavigationBar */
    [self setNavigationBar];
    
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

    NSArray * buttonNames = [[NSArray alloc]initWithObjects:@"บริการ",@"โปรโมชั่น", nil];
    self.segmented = [[UISegmentedControl alloc]initWithItems:buttonNames];
    self.segmented.selectedSegmentIndex = 0;
    [self.segmented addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = self.segmented;
    
}

-(void)segmentAction:(UISegmentedControl *)sender
{
    if (self.segmented.selectedSegmentIndex == 0) {
        NSLog(@"0");
    }
    if (self.segmented.selectedSegmentIndex == 1) {
        NSLog(@"1");
        
    }
}

@end
