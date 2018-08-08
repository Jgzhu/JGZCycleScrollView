//
//  JGZVideoPlayer.h
//  JGZCycleScrollViewDemo
//
//  Created by jgzhu on 2018/8/7.
//  Copyright © 2018年 jgzhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import<AVFoundation/AVFoundation.h>
@interface JGZVideoPlayer : UIView
+(instancetype)ShareManger;
@property (nonatomic,strong)NSURL *VideoUrl;
@property (nonatomic,strong)AVPlayer *Player;
@property (nonatomic,strong)AVPlayerItem *PlayerItem;
@property (nonatomic)BOOL IsPlaying;
-(void)Pause;
-(void)Play;
-(void)RemoveAll;
@end
