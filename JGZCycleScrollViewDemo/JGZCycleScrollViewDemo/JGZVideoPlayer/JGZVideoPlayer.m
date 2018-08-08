//
//  JGZVideoPlayer.m
//  JGZCycleScrollViewDemo
//
//  Created by jgzhu on 2018/8/7.
//  Copyright © 2018年 jgzhu. All rights reserved.
//

#import "JGZVideoPlayer.h"


@interface JGZVideoPlayer()


@property (nonatomic,strong)AVPlayerLayer *PlayerView;

@end

@implementation JGZVideoPlayer

+(instancetype)ShareManger{
        static JGZVideoPlayer *VideoPlayerManage = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            VideoPlayerManage=[[JGZVideoPlayer alloc] init];
            
        });
        return VideoPlayerManage;
}
-(instancetype)init{
    if (self=[super init]) {
        self.backgroundColor=[UIColor redColor];
    }
    return self;
}
-(void)setVideoUrl:(NSURL *)VideoUrl{
    _VideoUrl=VideoUrl;
    self.IsPlaying=NO;
    self.PlayerItem=nil;
    self.Player=nil;
    self.PlayerView=nil;
    [self.PlayerItem cancelPendingSeeks];
    [self.PlayerItem.asset cancelLoading];
    [self.Player replaceCurrentItemWithPlayerItem:nil];
    [self.PlayerView removeFromSuperlayer];
    self.PlayerItem=[[AVPlayerItem alloc] initWithURL:VideoUrl];
    self.Player=[AVPlayer playerWithPlayerItem:self.PlayerItem];
    self.PlayerView = [AVPlayerLayer playerLayerWithPlayer:self.Player];
    //self.PlayerView.fillMode=AVLayerVideoGravityResizeAspect;
     self.PlayerView.videoGravity = AVLayerVideoGravityResizeAspectFill;
    //self.PlayerView.frame = CGRectMake(0, 0, se, <#CGFloat height#>);
   // self.PlayerView.backgroundColor=[UIColor yellowColor].CGColor;
    [self.layer addSublayer:self.PlayerView];
    
  
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.PlayerView.frame = self.bounds;
}
-(void)Play{
     [self.Player play];
    self.IsPlaying=YES;
}
-(void)RemoveAll{
    self.IsPlaying=NO;
    [self.PlayerItem cancelPendingSeeks];
        [self.PlayerItem.asset cancelLoading];
        [self.Player replaceCurrentItemWithPlayerItem:nil];
        [self.PlayerView removeFromSuperlayer];
        self.PlayerItem=nil;
        self.Player=nil;
        self.PlayerView=nil;
}
-(void)Pause{
    self.IsPlaying=NO;
     [self.Player pause];
//
}
@end
