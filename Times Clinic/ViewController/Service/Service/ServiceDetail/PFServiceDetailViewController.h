//
//  PFServiceDetailViewController.h
//  Times Clinic
//
//  Created by Pariwat Promjai on 3/18/2558 BE.
//  Copyright (c) 2558 Pariwat Promjai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <FacebookSDK/FacebookSDK.h>

@protocol PFServiceDetailViewControllerDelegate <NSObject>

- (void)PFImageViewController:(id)sender viewPicture:(UIImage *)image;

@end

@interface PFServiceDetailViewController : UIViewController

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) NSDictionary *obj;

@end
