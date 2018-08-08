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
#import "JGZVideoPlayer.h"
//#import "SelVideoPlayer.h"
//#import "SelPlayerConfiguration.h"
@interface ViewController ()<JGZCycleScrollViewDelegate>
//@property (nonatomic, strong) SelVideoPlayer *player;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    JGZCycleScrollViewModel *model1=[[JGZCycleScrollViewModel alloc] init];
    model1.type=ModelLocalImage;
    model1.ImageName=@"h1";
    model1.indexInteger=0;
    
    JGZCycleScrollViewModel *model2=[[JGZCycleScrollViewModel alloc] init];
    model2.type=ModelVideo;
    model2.ImageUrlString=@"h2";
    model2.VideoUrl=[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"big_buck_bunny"ofType:@"mp4"] isDirectory:YES];
    model2.imgCornerRadius=10;
    //model2.indexInteger=1;
    
    JGZCycleScrollViewModel *model3=[[JGZCycleScrollViewModel alloc] init];
    model3.type=ModelLocalImage;
    model3.ImageName=@"h3";
    model3.indexInteger=2;
    
    JGZCycleScrollViewModel *model4=[[JGZCycleScrollViewModel alloc] init];
    model4.type=ModelVideo;
    model4.ImageName=@"h4";
    model4.VideoUrl=[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"start"ofType:@"mp4"] isDirectory:YES];
    model4.CurrentTime=0;
    model4.indexInteger=3;
    NSArray *ModelArr =@[model1,model2,model3,model4];
    
    JGZCycleScrollView *banner = [JGZCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 135) shouldInfiniteLoop:YES ModelArray:ModelArr];
    //    banner.placeholderImage = [UIImage imageNamed:@"placeholderImage"];
    //    banner.cellPlaceholderImage = [UIImage imageNamed:@"placeholderImage"];
    banner.autoScrollTimeInterval = 15;
    banner.autoScroll = YES;
    banner.isZoom = YES;
    banner.itemSpace = 0;
    banner.imgCornerRadius = 10;
    banner.itemWidth = self.view.frame.size.width - 100;
    banner.delegate = self;
    [self.view addSubview:banner];
//    JGZVideoPlayer *VideoPlayerManager=[JGZVideoPlayer ShareManger];
//    VideoPlayerManager.frame=CGRectMake(0, 100, self.view.frame.size.width, 135);
//    VideoPlayerManager.VideoUrl=[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"big_buck_bunny"ofType:@"mp4"] isDirectory:YES];;
//    [self.view addSubview:VideoPlayerManager];
    
//    SelPlayerConfiguration *configuration = [[SelPlayerConfiguration alloc]init];
//    //self.configuration=configuration;
//    configuration.shouldAutoPlay = YES;
//    configuration.supportedDoubleTap = YES;
//    configuration.shouldAutorotate = YES;
//    configuration.repeatPlay = YES;
//    configuration.statusBarHideState = SelStatusBarHideStateFollowControls;
//    NSString *audioPath = [[NSBundle mainBundle] pathForResource:@"big_buck_bunny"ofType:@"mp4"];
//    //configuration.sourceUrl = [NSURL URLWithString:@"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"];
//    configuration.sourceUrl=[NSURL fileURLWithPath:audioPath isDirectory:YES];
//    configuration.videoGravity = SelVideoGravityResizeAspectFill;
//    //        self.player.playerConfiguration=configuration;
//    CGFloat width = self.view.frame.size.width;
//    _player = [[SelVideoPlayer alloc]initWithFrame:CGRectMake(0, 0, width, self.view.frame.size.height*0.5) configuration:configuration];
//    //[_player _pauseVideo];
//
//    [self.view addSubview:_player];
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
