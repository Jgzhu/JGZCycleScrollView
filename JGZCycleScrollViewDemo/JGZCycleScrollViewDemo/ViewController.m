//
//  ViewController.m
//  JGZCycleScrollViewDemo
//
//  Created by jgzhu on 2018/8/5.
//  Copyright © 2018年 jgzhu. All rights reserved.
//

#import "ViewController.h"
#import "JGZCycleScrollView.h"
#import "JGZCycleScrollViewModel.h"
@interface ViewController ()<JGZCycleScrollViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    JGZCycleScrollViewModel *model1=[[JGZCycleScrollViewModel alloc] init];
    model1.type=ModelLocalImage;
    model1.ImageName=@"h1.jpg";
    
    JGZCycleScrollViewModel *model2=[[JGZCycleScrollViewModel alloc] init];
    model2.type=ModelNetImage;
    model2.ImageUrlString=@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1533533518563&di=f39312202d90581305fb61c41a7a0700&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F0117e2571b8b246ac72538120dd8a4.jpg%401280w_1l_2o_100sh.jpg";
    model2.imgCornerRadius=10;
    
    JGZCycleScrollViewModel *model3=[[JGZCycleScrollViewModel alloc] init];
    model3.type=ModelLocalImage;
    model3.ImageName=@"h3.jpg";
    
    JGZCycleScrollViewModel *model4=[[JGZCycleScrollViewModel alloc] init];
    model4.type=ModelLocalImage;
    model4.ImageName=@"h4.jpg";
    
    NSArray *ModelArr =@[model1,model2,model3,model4];
    
    JGZCycleScrollView *banner = [JGZCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 135) shouldInfiniteLoop:YES ModelArray:ModelArr];
    //    banner.placeholderImage = [UIImage imageNamed:@"placeholderImage"];
    //    banner.cellPlaceholderImage = [UIImage imageNamed:@"placeholderImage"];
    banner.autoScrollTimeInterval = 3;
    banner.autoScroll = YES;
    banner.isZoom = YES;
    banner.itemSpace = 0;
    banner.imgCornerRadius = 10;
    banner.itemWidth = self.view.frame.size.width - 100;
    banner.delegate = self;
    [self.view addSubview:banner];
}

//点击图片的代理
-(void)cycleScrollView:(JGZCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"index = %ld",(long)index);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
