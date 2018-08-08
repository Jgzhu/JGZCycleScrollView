//
//  JGZCycleScrollViewModel.h
//  JGZCycleScrollViewDemo
//
//  Created by jgzhu on 2018/8/5.
//  Copyright © 2018年 jgzhu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ModelType) {
    ModelLocalImage,
    ModelNetImage,
    ModelVideo
};

@interface JGZCycleScrollViewModel : UICollectionViewFlowLayout
@property (nonatomic,assign)ModelType type;
@property (nonatomic,copy)NSString *ImageName;
@property (nonatomic,copy)NSString *ImageUrlString;
@property (nonatomic,assign) CGFloat imgCornerRadius;
@property (nonatomic,strong)NSURL *VideoUrl;
@property (nonatomic,assign)NSInteger CurrentTime;

@property (nonatomic,assign)NSInteger indexInteger;
@end
