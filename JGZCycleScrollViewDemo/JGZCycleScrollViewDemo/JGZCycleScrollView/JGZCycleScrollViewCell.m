
//  JGZCycleScrollViewCell.m
//  JGZCycleScrollViewDemo
//
//  Created by jgzhu on 2018/8/6.
//  Copyright © 2018年 jgzhu. All rights reserved.
//

#import "JGZCycleScrollViewCell.h"
#import "UIImageView+WebCache.h"
#import "JGZVideoPlayer.h"
#import "UIView+WebCache.h"

@interface JGZCycleScrollViewCell()
/** 时间监听器 */
@property (nonatomic, strong) id timeObserve;
@property (nonatomic,strong)JGZVideoPlayer *VideoPlayerManager;
@property (nonatomic,strong)UIButton *VolumeBtn;
@end

@implementation JGZCycleScrollViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, 135)];
        self.imageView.layer.cornerRadius=10;
        self.imageView.layer.masksToBounds=YES;

        [self.contentView addSubview:self.imageView];
        
        self.VolumeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        self.VolumeBtn.backgroundColor=[UIColor yellowColor];
    self.VolumeBtn.frame=CGRectMake(self.bounds.size.width-60, self.bounds.size.height-60, 60, 60);
        [self.VolumeBtn addTarget:self action:@selector(VolumeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.VolumeBtn];
      
    }
    return self;
}
-(void)VolumeBtnClick:(UIButton *)btn{
    if (btn.isSelected==NO) {
        btn.selected=YES;
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        CGFloat currentVol = audioSession.outputVolume;
        self.VideoPlayerManager.Player.volume=currentVol;
    }else{
         btn.selected=NO;
        self.VideoPlayerManager.Player.volume=0;
    }
   
}
-(void)setModel:(JGZCycleScrollViewModel *)model{
    _model=model;
    if (model.type==ModelLocalImage) {
        self.VideoPlayerManager=nil;
        [self deleteplayerview];
//        self.VideoPlayerManager.hidden=YES;
//        [self.VideoPlayerManager Pause];
//        [self.VideoPlayerManager removeFromSuperview];
        self.imageView.image=[UIImage imageNamed:model.ImageName];

    }else if (model.type==ModelNetImage){
        self.VideoPlayerManager=nil;
        [self deleteplayerview];
//        self.VideoPlayerManager.hidden=YES;
//        [self.VideoPlayerManager Pause];
//         [self.VideoPlayerManager removeFromSuperview];
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.ImageUrlString] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];

    }else if (model.type==ModelVideo){
         self.imageView.image=[UIImage imageNamed:model.ImageName];
        self.VideoPlayerManager=nil;
        [self deleteplayerview];
        self.VideoPlayerManager=[[JGZVideoPlayer alloc] init];
       // NSLog(@"音量--%f",self.VideoPlayerManager.Player.volume);

        self.VideoPlayerManager.frame=CGRectMake(0, 0, self.imageView.bounds.size.width, self.imageView.bounds.size.height);
        self.VideoPlayerManager.tag=1001;

        [self.imageView addSubview:self.VideoPlayerManager];
        self.VideoPlayerManager.VideoUrl=self.model.VideoUrl;


    }
}

-(void)setIsStart:(BOOL)IsStart{
    _IsStart=IsStart;
    self.VideoPlayerManager.hidden=NO;
    if (IsStart==YES) {

         //self.VideoPlayerManager.Player.volume=0;
        self.VideoPlayerManager.hidden=NO;
        CMTime dragedCMTime = CMTimeMake(self.model.CurrentTime, 1);
        [self.VideoPlayerManager.Player seekToTime:dragedCMTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];

        if (self.VideoPlayerManager.IsPlaying==NO) {
             [self.VideoPlayerManager Play];
        }

      
        [self createTimer];

    }else{
       
        [self deleteplayerview];
        [self.VideoPlayerManager Pause];
//        self.imageView.image=[UIImage imageNamed:@""];
//        NSLog(@"图片%@",self.model.ImageName);
//         self.imageView.image=[UIImage imageNamed:self.model.ImageName];
//       // [self.VideoPlayerManager removeFromSuperview];
       // self.VideoPlayerManager.hidden=YES;
    }
}
-(void)deleteplayerview{
    if (self.timeObserve) {
        [self.VideoPlayerManager.Player removeTimeObserver:self.timeObserve];
        self.timeObserve = nil;
    }
    for (UIView *view in self.imageView.subviews) {
        if (view.tag==1001&&view!=self.VideoPlayerManager) {
            JGZVideoPlayer *playerview=(JGZVideoPlayer *)view;
            [playerview RemoveAll];
            [view removeFromSuperview];
        }
    }
}

/** 创建定时器 */
- (void)createTimer {
    __weak typeof(self) weakSelf = self;
    self.timeObserve = [self.VideoPlayerManager.Player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1, 1) queue:nil usingBlock:^(CMTime time){
        AVPlayerItem *currentItem = weakSelf.VideoPlayerManager.PlayerItem;
        NSArray *loadedRanges = currentItem.seekableTimeRanges;
        if (loadedRanges.count > 0 && currentItem.duration.timescale != 0) {
            NSInteger currentTime = (NSInteger)CMTimeGetSeconds([currentItem currentTime]);
            
            CGFloat totalTime = (CGFloat)currentItem.duration.value / currentItem.duration.timescale;
            currentTime=currentTime+1;
            if (currentTime>=totalTime) {
                weakSelf.model.CurrentTime= 0;
                CMTime dragedCMTime = CMTimeMake(0, 1);
                [weakSelf.VideoPlayerManager.Player seekToTime:dragedCMTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
            }else{
                weakSelf.model.CurrentTime= currentTime;
            }
          
        }
    }];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
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
