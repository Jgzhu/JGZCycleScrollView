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
#import "JGZCycleScrollViewCell.h"
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
@interface JGZCycleScrollView ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) JGZCycleScrollViewFlowLayout *flowLayout;
@property (nonatomic,strong) UIImageView *backgroundImageView;
@property (nonatomic,strong) NSArray *ModelArray;//图片数组
@property (nonatomic,assign) NSInteger totalItems;//item总数
@property (nonatomic,strong) NSTimer *timer;

@end

static NSString *const cellID = @"cellID";
@implementation JGZCycleScrollView
{
    float _oldPoint;
    NSInteger _dragDirection;
}

-(UIPageControl *)pageControl
{
    if(_pageControl == nil)
    {
        _pageControl = [[UIPageControl alloc]init];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    }
    return _pageControl;
}
-(JGZCycleScrollViewFlowLayout *)flowLayout
{
    if(_flowLayout == nil)
    {
        _flowLayout = [[JGZCycleScrollViewFlowLayout alloc]init];
        _flowLayout.isZoom = self.isZoom;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.minimumLineSpacing = 0;
        
    }
    return _flowLayout;
}
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
        [_collectionView registerClass:[JGZCycleScrollViewCell class] forCellWithReuseIdentifier:cellID];
        
    }
    return _collectionView;
}
+(instancetype)cycleScrollViewWithFrame:(CGRect)frame shouldInfiniteLoop:(BOOL)infiniteLoop ModelArray:(NSArray<JGZCycleScrollViewModel *> *)ModelArray{
    JGZCycleScrollView *CycleScrollView=[[JGZCycleScrollView alloc] initWithFrame:frame];
    CycleScrollView.infiniteLoop = infiniteLoop;
    CycleScrollView.autoScroll = infiniteLoop;
    CycleScrollView.ModelArray = ModelArray;
    return CycleScrollView;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self initialization];
        [self addSubview:self.collectionView];
        [self addSubview:self.pageControl];
        
    }
    return self;
}



-(void)initialization
{
    //初始化
    _infiniteLoop = YES;
    _autoScroll = YES;
    _isZoom = NO;
    _itemWidth = self.bounds.size.width;
    _itemSpace = 0;
    _imgCornerRadius = 0;
    _autoScrollTimeInterval = 2;
    _pageControl.currentPage = 0;
    _bannerImageViewContentMode = UIViewContentModeScaleToFill;
}
-(CGFloat )defaultSpace
{
    return (kScreenWidth - self.itemWidth)/2;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
   
    self.collectionView.frame = self.bounds;
    self.pageControl.frame = CGRectMake(0, self.bounds.size.height - 30, self.bounds.size.width, 30);
    self.flowLayout.itemSize = CGSizeMake(_itemWidth, self.bounds.size.height);
    self.flowLayout.minimumLineSpacing = self.itemSpace;
    
    if(self.collectionView.contentOffset.x == 0 && _totalItems > 0)
    {
        NSInteger targeIndex = 0;
        if(self.infiniteLoop)
        {//无线循环
            // 如果是无限循环，应该默认把 collection 的 item 滑动到 中间位置。
            // 注意：此处 totalItems 的数值，其实是图片数组数量的 100 倍。
            // 乘以 0.5 ，正好是取得中间位置的 item 。图片也恰好是图片数组里面的第 0 个。
            targeIndex = _totalItems * 0.5;
        }else
        {
            targeIndex = 0;
        }
        //设置图片默认位置
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:targeIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        _oldPoint = self.collectionView.contentOffset.x;
        self.collectionView.userInteractionEnabled = YES;
        
    }
}
#pragma mark  - event

#pragma mark  - delegate
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.collectionView.userInteractionEnabled = NO;
    if (!self.ModelArray.count) return; // 解决清除timer时偶尔会出现的问题
    self.pageControl.currentPage = [self currentIndex] % self.ModelArray.count;
   
     self.indecue = [self currentIndex];
   
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
   
    _oldPoint = scrollView.contentOffset.x;
    if (self.autoScroll) {
        [self invalidateTimer];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.autoScroll) {
        [self setupTimer];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:self.collectionView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
   
     NSLog(@"%ld",(long) [self currentIndex]);
      self.indecue = [self currentIndex];
   // [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%ld",(long)self.indecue] object:[NSNumber numberWithInteger:self.indecue]];
    self.collectionView.userInteractionEnabled = YES;
    if (!self.ModelArray.count) return; // 解决清除timer时偶尔会出现的问题
}

/* JGZCycleScrollViewCell *cell=(JGZCycleScrollViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.pageControl.currentPage inSection:0]];
 
 if (cell.model.type==ModelVideo) {
 cell.IsStart=YES;
 }else{
 cell.IsStart=NO;
 }*/
//手离开屏幕的时候
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if(!self.infiniteLoop) return;//如果不是无限轮播，则返回
    
    //如果是向右滑或者滑动距离大于item的一半，则像右移动一个item+space的距离，反之向左
    float currentPoint = scrollView.contentOffset.x;
    float moveWidth = currentPoint-_oldPoint;
    int shouldPage = moveWidth/(self.itemWidth/2);
    if (velocity.x>0 || shouldPage > 0) {
        _dragDirection = 1;
    }else if (velocity.x<0 || shouldPage < 0){
        _dragDirection = -1;
    }else{
        _dragDirection = 0;
    }
    self.collectionView.userInteractionEnabled = NO;
    //
    NSInteger currentIndex = (_oldPoint + (self.itemWidth + self.itemSpace) * 0.5) / (self.itemSpace + self.itemWidth);
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:currentIndex + _dragDirection inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
}

- (void)scrollViewWillBeginDecelerating: (UIScrollView *)scrollView{
    if(!self.infiniteLoop) return;//如果不是无限轮播，则返回
    
    //松开手指滑动开始减速的时候，设置滑动动画
    NSInteger currentIndex = (_oldPoint + (self.itemWidth + self.itemSpace) * 0.5) / (self.itemSpace + self.itemWidth);
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:currentIndex + _dragDirection inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

#pragma mark  - 数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _totalItems;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JGZCycleScrollViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
   
    long itemIndex = (int) indexPath.item % self.ModelArray.count;
    JGZCycleScrollViewModel *model=self.ModelArray[itemIndex];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    cell.imageView.clipsToBounds=YES;
    cell.imgCornerRadius=self.imgCornerRadius;
    cell.model=model;
    return cell;
}
//-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
//    for (JGZCycleScrollViewCell *Cell1 in  self.collectionView.visibleCells) {
//        if (Cell1.model.type==ModelVideo) {
//            if (Cell1==cell) {
//                Cell1.IsStart=YES;
//            }else{
//               Cell1.IsStart=NO;
//            }
//            
//        }
//    }
//    JGZCycleScrollViewCell *ScrollViewCell=(JGZCycleScrollViewCell *)cell;
//    if (ScrollViewCell.model.type==ModelVideo) {
//        ScrollViewCell.IsStart=YES;
//    }
//
//}
//-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
//    JGZCycleScrollViewCell *ScrollViewCell=(JGZCycleScrollViewCell*)cell;
//     if (ScrollViewCell.model.type==ModelVideo) {
//    ScrollViewCell.IsStart=NO;
//     }
//}
#pragma mark  - 代理方法

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:didSelectItemAtIndex:)]) {
        [self.delegate cycleScrollView:self didSelectItemAtIndex:[self currentIndex] % self.ModelArray.count];
    }
}
#pragma mark  - notification

#pragma mark  - private
- (void)setupTimer
{
    [self invalidateTimer]; // 创建定时器前先停止定时器，不然会出现僵尸定时器，导致轮播频率错误
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTimeInterval target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    _timer = timer;
    
}
- (void)invalidateTimer
{
    [_timer invalidate];
    _timer = nil;
}
-(void)automaticScroll
{
    if(_totalItems == 0) return;
    
    NSInteger currentIndex = [self currentIndex];
    
    NSInteger targetIndex = currentIndex + 1;
    
    [self scrollToIndex:targetIndex];
}
-(NSInteger)currentIndex
{
    if(self.collectionView.frame.size.width == 0 || self.collectionView.frame.size.height == 0)
        return 0;
    NSInteger index = 0;
    
    if (_flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {//水平滑动
        index = (self.collectionView.contentOffset.x + (self.itemWidth + self.itemSpace) * 0.5) / (self.itemSpace + self.itemWidth);
    }else{
        index = (self.collectionView.contentOffset.y + _flowLayout.itemSize.height * 0.5)/ _flowLayout.itemSize.height;
    }
    return MAX(0,index);
}
-(void)scrollToIndex:(NSInteger)index
{
    if(index >= _totalItems) //滑到最后则调到中间
    {
        if(self.infiniteLoop)
        {
            index = _totalItems * 0.5;
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        }
        return;
    }
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
}
#pragma mark  - public
/**设置分页滑动属性（如果infiniteLoop属性为yes，则设置无效）*/
-(void)setCollectionViewPagingEnabled:(BOOL)pagingEnabled
{
    if(self.infiniteLoop == NO)
    {
        self.collectionView.pagingEnabled = pagingEnabled;
    }
}
#pragma mark  - setter or getter
- (void)setPlaceholderImage:(UIImage *)placeholderImage
{
    _placeholderImage = placeholderImage;
    
    if (!self.backgroundImageView) {
        UIImageView *bgImageView = [UIImageView new];
        bgImageView.frame = self.collectionView.frame;
        bgImageView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:bgImageView];
        [self insertSubview:bgImageView belowSubview:self.collectionView];
        self.backgroundImageView = bgImageView;
    }
    self.backgroundImageView.image = placeholderImage;
}
-(void)setItemWidth:(CGFloat)itemWidth
{
    _itemWidth = itemWidth;
    self.flowLayout.itemSize = CGSizeMake(itemWidth, self.bounds.size.height);
}
-(void)setItemSpace:(CGFloat)itemSpace
{
    _itemSpace = itemSpace;
    self.flowLayout.minimumLineSpacing = itemSpace;
}
-(void)setIsZoom:(BOOL)isZoom
{
    _isZoom = isZoom;
    self.flowLayout.isZoom = isZoom;
}
-(void)setModelArray:(NSArray *)ModelArray{
    _ModelArray=ModelArray;
    self.pageControl.numberOfPages = ModelArray.count;
    //如果循环则100倍，
    _totalItems = self.infiniteLoop?ModelArray.count * 100:ModelArray.count;
    if(_ModelArray.count > 1)
    {
        self.collectionView.scrollEnabled = YES;
        [self setAutoScroll:self.autoScroll];
    }else
    {
        //不循环
        self.collectionView.scrollEnabled = NO;
        [self invalidateTimer];
    }
    
    [self.collectionView reloadData];
}

-(void)setAutoScroll:(BOOL)autoScroll
{
    if(self.infiniteLoop)
    {
        _autoScroll = autoScroll;
        //创建之前，停止定时器
        [self invalidateTimer];
        
        if (_autoScroll) {
            [self setupTimer];
        }
    }
    
}
@end
