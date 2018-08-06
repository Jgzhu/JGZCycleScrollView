//
//  JGZCycleScrollViewCell.m
//  JGZCycleScrollViewDemo
//
//  Created by jgzhu on 2018/8/6.
//  Copyright © 2018年 jgzhu. All rights reserved.
//

#import "JGZCycleScrollViewCell.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImageView+WebCache.h"
@implementation JGZCycleScrollViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self.contentView addSubview:self.imageView];
    }
    return self;
}
-(void)setModel:(JGZCycleScrollViewModel *)model{
    _model=model;
    if (model.type==ModelLocalImage) {
        self.imageView.image=[UIImage imageNamed:model.ImageName];
    }else if (model.type==ModelNetImage){
        
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.ImageUrlString] placeholderImage:[UIImage imageNamed:@"placeholderImage"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {

             self.imageView.image=[self imageCompressForWidthScale:image targetWidth:[UIScreen mainScreen].bounds.size.width];
            [self layoutIfNeeded];
        
//            self.imageView.image=[self imageCompressForWidthScale:image targetWidth:[UIScreen mainScreen].bounds.size.width];
//            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.imageView.bounds cornerRadius:self.model.imgCornerRadius];
//            CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
//            //设置大小
//            maskLayer.frame = self.bounds;
//            //设置图形样子
//            maskLayer.path = maskPath.CGPath;
//            self.imageView.layer.mask = maskLayer;
            
        }];
       
        
    }
}

//指定宽度按比例缩放
-(UIImage *) imageCompressForWidthScale:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth{
    
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            
        }else if(widthFactor < heightFactor){
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        
        NSLog(@"scale image fail");
    }
    UIGraphicsEndImageContext();
    return newImage;
}

-(void)layoutIfNeeded{
    self.imageView.frame = self.bounds;
    self.imageView.layer.cornerRadius=10;
    self.imageView.layer.masksToBounds=YES;
}
-(void)layoutSubviews
{
    self.imageView.frame = self.bounds;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.imageView.bounds cornerRadius:self.imgCornerRadius];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    //设置大小
    maskLayer.frame = self.bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    self.imageView.layer.mask = maskLayer;
    
}

-(UIImageView *)imageView
{
    if(_imageView == nil)
    {
        _imageView = [[UIImageView alloc]init];
    }
    return _imageView;
}
@end
