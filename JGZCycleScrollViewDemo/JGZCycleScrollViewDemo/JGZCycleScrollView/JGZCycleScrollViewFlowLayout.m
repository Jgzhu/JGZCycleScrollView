//
//  JGZCycleScrollViewFlowLayout.m
//  JGZCycleScrollViewDemo
//
//  Created by jgzhu on 2018/8/5.
//  Copyright © 2018年 jgzhu. All rights reserved.
//

#import "JGZCycleScrollViewFlowLayout.h"
#import "JGZCycleScrollViewCell.h"
#import "JGZCycleScrollView.h"
@implementation JGZCycleScrollViewFlowLayout
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    // 1.获取cell对应的attributes对象
    NSArray* arrayAttrs = [[NSArray alloc] initWithArray:[super layoutAttributesForElementsInRect:rect] copyItems:NO];
    //    NSArray *arrayAttrs = [super layoutAttributesForElementsInRect:rect];
    
    if(!self.isZoom) return arrayAttrs;
    
    
    // 2.计算整体的中心点的x值
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.bounds.size.width * 0.5;
    
    // 3.修改一下attributes对象
    for (UICollectionViewLayoutAttributes *attr in arrayAttrs) {
        // 3.1 计算每个cell的中心点距离
        CGFloat distance = ABS(attr.center.x - centerX);
        
        // 3.2 距离越大，缩放比越小，距离越小，缩放比越大
        CGFloat factor = 0.001;
        CGFloat scale = 1 / (1 + distance * factor);
        //NSLog(@"%f",scale);
        JGZCycleScrollViewCell *cell=  (JGZCycleScrollViewCell *) [self.collectionView cellForItemAtIndexPath:attr.indexPath];
        
        //CGRect cellFrame=[cell.imageView convertRect:cell.imageView.frame toView:[UIApplication sharedApplication].keyWindow];
//        NSLog(@"%@",cellFrame);
        if (scale==1) {

            if (cell.model.type==ModelVideo) {

                cell.IsStart=YES;
            }
            else{
              cell.IsStart=NO;
            }

        }
        else{
            if (cell.model.type==ModelVideo) {
//                if (distance<self.collectionView.bounds.size.width * 0.5) {
//                    cell.IsStart=YES;
//                }else{
                cell.IsStart=NO;
               // }
            }
        }
     
        attr.transform = CGAffineTransformMakeScale(scale, scale);
    }
    return arrayAttrs;
}
/*!
 *  多次调用 只要滑出范围就会 调用
 *  当CollectionView的显示范围发生改变的时候，是否重新发生布局
 *  一旦重新刷新 布局，就会重新调用
 *  1.layoutAttributesForElementsInRect：方法
 *  2.preparelayout方法
 */
//- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
//    
//     JGZCycleScrollViewCell *cell=  (JGZCycleScrollViewCell *) [self.collectionView cellForItemAtIndexPath:indexPath];
//    return nil;
//}
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return true;
}

@end
