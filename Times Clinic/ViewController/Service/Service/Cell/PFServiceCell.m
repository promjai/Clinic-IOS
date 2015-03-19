//
//  PFServiceCell.m
//  Times Clinic
//
//  Created by Pariwat Promjai on 3/18/2558 BE.
//  Copyright (c) 2558 Pariwat Promjai. All rights reserved.
//

#import "PFServiceCell.h"

@implementation PFServiceCell

- (void)awakeFromNib {
    // Initialization code
    
    [self.bg_view.layer setMasksToBounds:YES];
    [self.bg_view.layer setCornerRadius:5.0f];
    
    [self.img_thumb.layer setMasksToBounds:YES];
    [self.img_thumb.layer setCornerRadius:5.0f];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
