//
//  PLPlayerVC.m
//  TZTV
//
//  Created by Luosa on 2016/11/10.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "PLPlayerVC.h"
//#import <PLPlayerKit/PLPlayerKit.h>

//@interface PLPlayerVC ()<PLPlayerDelegate>
//@property (nonatomic, strong) PLPlayer *player;
//@end

@implementation PLPlayerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
    [self.view updateConstraintsIfNeeded];//强制更新约束
    [self.view layoutIfNeeded];//强制刷新界面
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden=NO;
}

- (IBAction)closeClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    PLPlayerOption *option = [PLPlayerOption defaultOption];
//    // 更改需要修改的 option 属性键所对应的值
//    [option setOptionValue:@15 forKey:PLPlayerOptionKeyTimeoutIntervalForMediaPackets];
//    [option setOptionValue:@2000 forKey:PLPlayerOptionKeyMaxL1BufferDuration];
//    [option setOptionValue:@1000 forKey:PLPlayerOptionKeyMaxL2BufferDuration];
//    [option setOptionValue:@(NO) forKey:PLPlayerOptionKeyVideoToolbox];
//    [option setOptionValue:@(kPLLogWarning) forKey:PLPlayerOptionKeyLogLevel];
//    
//    NSURL *url = [NSURL URLWithString:@"直播的 rtmp 地址"];
//    self.player = [PLPlayer playerWithURL:url option:option];
//    self.player.delegate = self;
//    [self.view addSubview:self.player.playerView];
//    
//    //设置 player 相关属性支持后台播放
//    //PLPlayer 需要注意的是在后台播放时仅有音频，视频会在回到前台时继续播放。
//    self.player.backgroundPlayEnable = YES;
//    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
//    
//    // 播放
//    [self.player play];
//    
//    // 停止
//    [self.player stop];
//    
//    // 暂停
//    [self.player pause];
//    
//    // 继续播放
//    [self.player resume];
//    
//}
//
//// 实现 <PLPlayerDelegate> 来控制流状态的变更
//
////只有在正常连接，正常断开的情况下跳转的状态才会触发这一回调。
////所谓正常连接是指通过调用 -play 方法使得流连接的各种状态，而所谓正常断开是指调用 -stop 方法使得流断开的各种状态。
////以下状态会触发这一回调方法。PLPlayerStatusPreparing  PLPlayerStatusReady PLPlayerStatusCaching
////PLPlayerStatusPlaying PLPlayerStatusPaused PLPlayerStatusStopped
//- (void)player:(nonnull PLPlayer *)player statusDidChange:(PLPlayerStatus)state {
//    // 这里会返回流的各种状态，你可以根据状态做 UI 定制及各类其他业务操作
//    // 除了 Error 状态，其他状态都会回调这个方法
//}
//
////最好可以在此时尝试调用 -play 方法进行有限次数的重连。
////采用重连间隔加倍的方式，例如共尝试 3 次重连，第一次等待 0.5s, 第二次等待 1s, 第三次等待 2s
//- (void)player:(nonnull PLPlayer *)player stoppedWithError:(nullable NSError *)error {
//    // 当发生错误时，会回调这个方法
//}



@end
