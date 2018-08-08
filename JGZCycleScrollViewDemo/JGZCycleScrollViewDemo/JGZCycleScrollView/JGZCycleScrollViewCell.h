//
//  JGZCycleScrollViewCell.h
//  JGZCycleScrollViewDemo
//
//  Created by jgzhu on 2018/8/6.
//  Copyright © 2018年 jgzhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGZCycleScrollViewModel.h"
#import "JGZCycleScrollView.h"
@interface JGZCycleScrollViewCell : UICollectionViewCell
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,assign) CGFloat imgCornerRadius;
@property (nonatomic,strong)JGZCycleScrollViewModel *model;
@property (nonatomic)BOOL IsStart;
@end
