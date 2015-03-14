//
//  PFCommentViewController.h
//  Times Clinic
//
//  Created by Pariwat on 9/3/15.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PFApi.h"

@interface PFCommentViewController : UIViewController

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) PFApi *Api;

@property (strong, nonatomic) IBOutlet UITextView *comment;

@end
