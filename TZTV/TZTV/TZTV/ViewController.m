//
//  ViewController.m
//  TZTV
//
//  Created by Luosa on 2016/11/7.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "ViewController.h"
#import <PLMediaStreamingKit/PLCameraStreamingKit.h>

@interface ViewController ()
@property (nonatomic, strong) PLCameraStreamingSession *session;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *streamJSON =@{@"id": @"stream_id",
                                @"title": @"stream_title",
                                @"hub": @"hub_id",
                                @"publishKey": @"publish_key",
                                @"publishSecurity": @"dynamic", // or static
                                @"disabled": @(NO),
                                @"profiles": @[@"480p", @"720p"],    // or empty Array []
                                @"hosts": @{}
                                };
    PLStream *stream = [PLStream streamWithJSON:streamJSON];
    
    PLVideoCaptureConfiguration *videoCaptureConfiguration = [PLVideoCaptureConfiguration defaultConfiguration];
    PLAudioCaptureConfiguration *audioCaptureConfiguration = [PLAudioCaptureConfiguration defaultConfiguration];
    PLVideoStreamingConfiguration *videoStreamingConfiguration = [PLVideoStreamingConfiguration defaultConfiguration];
    PLAudioStreamingConfiguration *audioStreamingConfiguration = [PLAudioStreamingConfiguration defaultConfiguration];
    
    self.session = [[PLCameraStreamingSession alloc] initWithVideoCaptureConfiguration:videoCaptureConfiguration audioCaptureConfiguration:audioCaptureConfiguration videoStreamingConfiguration:videoStreamingConfiguration audioStreamingConfiguration:audioStreamingConfiguration stream:stream videoOrientation:AVCaptureVideoOrientationPortrait];
    //预览摄像头拍摄效果
    [self.view addSubview:self.session.previewView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"start" forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 100, 44);
    button.center = CGPointMake(CGRectGetMidX([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds) - 80);
    [button addTarget:self action:@selector(actionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    //如果运行后，点击按钮提示 Oops.，就要检查一下你之前创建 PLStream 对象时填写的 StreamJson 是否有漏填或者填错的内容。
    
}

- (void)actionButtonPressed:(id)sender {
//    [self.session startWithCompleted:^(BOOL success) {
//        if (success) {
//            NSLog(@"Streaming started.");
//        } else {
//            NSLog(@"Oops.");
//        }
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
/*
 PLVideoCaptureConfiguration 视频采集配置
 PLAudioCaptureConfiguration 音频采集配置
 PLVideoStreamingConfiguration 视频编码配置
 PLAudioStreamingConfiguration 音频编码配置
 
 配置生效的时刻有两个：
 在 PLCameraStreamingSession init 时传递对应的 configuration
 在推流前、推流中、推流结束后调用 - (void)reloadVideoStreamingConfiguration:(PLVideoStreamingConfiguration *)videoStreamingConfiguration videoCaptureConfiguration:(PLVideoCaptureConfiguration *)videoCaptureConfiguration; 重置 configuration
 需要注意的是，通过 reload 方法重置 configuration 时，需要确保传递的 configuration 与当前 session 已经持有的不是一个对象。
 */

@end
