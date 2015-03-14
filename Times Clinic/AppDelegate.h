//
//  AppDelegate.h
//  Times Clinic
//
//  Created by Pariwat Promjai on 2/27/2558 BE.
//  Copyright (c) 2558 Pariwat Promjai. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PFUpdateViewController.h"
#import "PFServiceViewController.h"
#import "PFTimesViewController.h"
#import "PFContactViewController.h"

@interface AppDelegate : UIResponder <UITabBarControllerDelegate>

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) PFUpdateViewController *update;
@property (strong, nonatomic) PFServiceViewController *service;
@property (strong, nonatomic) PFTimesViewController *times;
@property (strong, nonatomic) PFContactViewController *contact;

@end

