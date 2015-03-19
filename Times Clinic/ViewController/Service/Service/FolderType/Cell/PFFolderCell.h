//
//  PFFolderCell.h
//  Times Clinic
//
//  Created by Pariwat Promjai on 3/19/2558 BE.
//  Copyright (c) 2558 Pariwat Promjai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PFFolderCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *img_thumb;
@property (strong, nonatomic) IBOutlet UILabel *lb_name;
@property (strong, nonatomic) IBOutlet UILabel *lb_price;

@end
