//
//  JGZCycleScrollView.m
//  JGZCycleScrollViewDemo
//
//  Created by jgzhu on 2018/8/5.
//  Copyright © 2018年 jgzhu. All rights reserved.
//

#import "JGZCycleScrollView.h"
#import "JGZCycleScrollViewFlowLayout.h"
#import "JGZCycleScrollViewModel.h"
@interface JGZCycleScrollView ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) JGZCycleScrollViewFlowLayout *flowLayout;
@end


@implementation JGZCycleScrollView
-(UICollectionView *)collectionView
{
    if(_collectionView == nil)
    {
        _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollsToTop = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        
        //注册cell
       // [_collectionView registerClass:[DCCycleScrollViewCell class] forCellWithReuseIdentifier:cellID];
        
    }
    return _collectionView;
}
+(instancetype)cycleScrollViewWithFrame:(CGRect)frame shouldInfiniteLoop:(BOOL)infiniteLoop ModelArray:(NSArray<JGZCycleScrollViewModel *> *)ModelArray{
    JGZCycleScrollView *CycleScrollView=[[JGZCycleScrollView alloc] initWithFrame:frame];
    
    return CycleScrollView;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self addSubview:self.collectionView];
    }
    return self;
}
@end
