//
//  JGZCycleScrollView.h
//  JGZCycleScrollViewDemo
//
//  Created by jgzhu on 2018/8/5.
//  Copyright © 2018年 jgzhu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JGZCycleScrollViewModel;
@interface JGZCycleScrollView : UIView
+(instancetype)cycleScrollViewWithFrame:(CGRect)frame shouldInfiniteLoop:(BOOL)infiniteLoop ModelArray:(NSArray<JGZCycleScrollViewModel *> *)ModelArray;
@end
