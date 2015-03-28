//
//  CycleScrollView.h
//  PagedScrollView
//
//  Created by 陈政 on 14-1-23.
//  Copyright (c) 2014年 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CycleScrollView : UIView

@property (nonatomic , readonly) UIScrollView *scrollView;
/**
 *  @param frame             frame
 *  @param animationDuration
 *
 *  @return instance
 */
- (id)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration;

@property (nonatomic , copy) NSInteger (^totalPagesCount)(void);

@property (nonatomic , copy) UIView *(^fetchContentViewAtIndex)(NSInteger pageIndex);

@property (nonatomic , copy) void (^TapActionBlock)(NSInteger pageIndex);

@end