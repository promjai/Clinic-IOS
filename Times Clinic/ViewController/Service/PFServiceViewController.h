//
//  PFServiceViewController.h
//  Times Clinic
//
//  Created by Pariwat Promjai on 2/27/2558 BE.
//  Copyright (c) 2558 Pariwat Promjai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PFServiceViewController : UIViewController

@property (assign, nonatomic) id delegate;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmented;

@end
