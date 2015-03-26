//
//  PFNotificationCell.h
//  Times Clinic
//
//  Created by Pariwat Promjai on 3/24/2558 BE.
//  Copyright (c) 2558 Pariwat Promjai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PFNotificationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lb_topic;
@property (weak, nonatomic) IBOutlet UILabel *lb_time;
@property (weak, nonatomic) IBOutlet UILabel *lb_msg;
@property (weak, nonatomic) IBOutlet UIImageView *bg;

@end
