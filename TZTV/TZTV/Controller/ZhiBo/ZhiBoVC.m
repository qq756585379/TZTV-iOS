//
//  ZhiBoVC.m
//  TZTV
//
//  Created by Luosa on 2016/12/16.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "ZhiBoVC.h"
#import "ZhiBoViewModel.h"
#import "ChatCell.h"
#import "ChatModel.h"

@interface ZhiBoVC () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,   copy) NSDictionary *streamStateDictionary;
@property (nonatomic,   copy) NSDictionary *authorizationDictionary;
@property (nonatomic,   copy) NSDictionary *stateFeedbackDictionary;
@property (nonatomic, assign) BOOL needProcessVideo;
@property (nonatomic, assign) int  reconnectCount;
@property (nonatomic, strong) NSTimer        *timer;
@property (nonatomic, strong) ZhiBoViewModel *zhiboVM;
@end

@implementation ZhiBoVC

-(ZhiBoViewModel *)zhiboVM
{
    if (!_zhiboVM) {
        _zhiboVM=[ZhiBoViewModel new];
    }
    return _zhiboVM;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _prepareForCameraSetting];
    [self checkAndRequestPermission];
    [self.chatTV registerClass:[ChatCell class] forCellReuseIdentifier:[ChatCell cellReuseIdentifier]];
    
    Account *account=[AccountTool account];
//    [self.zhuboIcon setCircleImage:account.user_image andPlaceHolderImg:@"头像"];
    
//    [self.session startWithPushURL:[NSURL URLWithString:_info[@"live_rtmp_publish_url"]] feedback:^(PLStreamStartStateFeedback feedback) {
//        NSString *log = [NSString stringWithFormat:@"session start state %lu",(unsigned long)feedback];
//        NSLog(@"%@", log);
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (PLStreamStartStateSuccess == feedback) {
//                NSLog(@"推流成功");
//            }else{
//                [AlertViewManager alertWithMessage:@"推流失败了" andCompleteBlock:^(NSInteger buttonIndex) {
//                    [self.navigationController popViewControllerAnimated:YES];
//                }];
//            }
//        });
//    }];
    
    [self createTimer];
}

-(void)createTimer
{
    self.timer=[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(getChatAndNum) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

-(void)getChatAndNum{
    [self.zhiboVM loadDataFromNetworkWith:self.info];
    RACSignal *zipSignal = [self.zhiboVM.requestCommand execute:nil];
    WEAK_SELF
    [zipSignal subscribeNext:^(id x) {
        weakSelf.zaixianNumLabel.text=[NSString stringWithFormat:@"在线：%d人",[weakSelf.zhiboVM.online_num intValue]];
        weakSelf.dianzanshuLabel.text=[NSString stringWithFormat:@"点赞数：%@",weakSelf.zhiboVM.like_num];
        [YJTOOL showMoreLoveAnimateFromView:weakSelf.shareBtn addToView:weakSelf.view];//冒星星
        [weakSelf.chatTV reloadData];
        [weakSelf.chatTV setContentOffset:CGPointMake(0, MAX(0, weakSelf.chatTV.contentSize.height - weakSelf.chatTV.height)) animated:YES];
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
    [UIApplication sharedApplication].idleTimerDisabled = YES;//保持屏幕常亮
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden=NO;
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}

- (IBAction)btnClicked:(UIButton *)sender {
    if (sender.tag==222) {//切换摄像头
//        [self.session toggleCamera];
    }
    if (sender.tag==333) {//关闭
        [self stopPlayer];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)_prepareForCameraSetting{
    CGSize videoSize = CGSizeMake(ScreenW , ScreenH);
    //当前使用默认配置，之后可以深入研究按照自己的需求做更改。
//    PLAudioCaptureConfiguration   *audioCaptureConfiguration = [PLAudioCaptureConfiguration defaultConfiguration];
//    PLAudioStreamingConfiguration *audioStreamingConfiguration = [PLAudioStreamingConfiguration defaultConfiguration];
//
//    PLVideoCaptureConfiguration *videoCaptureConfiguration = [[PLVideoCaptureConfiguration alloc] initWithVideoFrameRate:24 sessionPreset:AVCaptureSessionPresetMedium previewMirrorFrontFacing:YES previewMirrorRearFacing:NO streamMirrorFrontFacing:NO streamMirrorRearFacing:NO cameraPosition:AVCaptureDevicePositionFront videoOrientation:AVCaptureVideoOrientationPortrait];
    
    // iOS 8 及以上系统版本可用 VideoToolbox 编码器，编码效率更优  768 * 1024
//    PLVideoStreamingConfiguration *videoStreamConfiguration = [[PLVideoStreamingConfiguration alloc] initWithVideoSize:videoSize expectedSourceVideoFrameRate:24 videoMaxKeyframeInterval:72 averageVideoBitRate:720 * 1280 videoProfileLevel:AVVideoProfileLevelH264HighAutoLevel videoEncoderType:PLH264EncoderType_VideoToolbox];
    
    //创建推流 session 对象
//    _session=[[PLCameraStreamingSession alloc] initWithVideoCaptureConfiguration:videoCaptureConfiguration
//                                                       audioCaptureConfiguration:audioCaptureConfiguration videoStreamingConfiguration:videoStreamConfiguration audioStreamingConfiguration:audioStreamingConfiguration stream:nil];
//    _session.delegate=self;
//    [self.view addSubview:self.session.previewView];
//    [self.view sendSubviewToBack:self.session.previewView];
    
//    self.streamStateDictionary = @{@(PLStreamStateUnknow):                      @"Unknow",
//                                            @(PLStreamStateConnecting):         @"Connecting",
//                                            @(PLStreamStateConnected):          @"Connected",
//                                            @(PLStreamStateDisconnecting):      @"Disconnecting",
//                                            @(PLStreamStateDisconnected):       @"Disconnected",
//                                            @(PLStreamStateAutoReconnecting):   @"AutoReconnecting",
//                                            @(PLStreamStateError):              @"Error",
//                                            };
//    self.authorizationDictionary = @{@(PLAuthorizationStatusNotDetermined):             @"NotDetermined",
//                                              @(PLAuthorizationStatusRestricted):       @"Restricted",
//                                              @(PLAuthorizationStatusDenied):           @"Denied",
//                                              @(PLAuthorizationStatusAuthorized):       @"Authorized",
//                                              };
}

- (void)checkAndRequestPermission
{
//    PLAuthorizationStatus status = [PLCameraStreamingSession cameraAuthorizationStatus];
//    if (PLAuthorizationStatusNotDetermined == status) {
//        [PLCameraStreamingSession requestCameraAccessWithCompletionHandler:^(BOOL granted) {
//            if (granted) {//授权
//
//            }else{//未授权
//
//            }
//        }];
//    } else if (PLAuthorizationStatusAuthorized == status) {
//        /// 已授权
//    } else {
//        /// 拒绝授权
//    }
}

-(void)stopPlayer
{
//    if (self.session) {
//        [self.session stop];
//        [self.session.previewView removeFromSuperview];
//        [self.session destroy];
//        self.session=nil;
//    }
//    if ([self.timer isValid]) {
//        [self.timer invalidate];
//        self.timer=nil;
//    }
}

-(void)dealloc
{
    [self stopPlayer];
}

#pragma mark - PLCameraStreamingSessionDelegate
/// @abstract 流状态已变更的回调
//- (void)cameraStreamingSession:(PLCameraStreamingSession *)session streamStateDidChange:(PLStreamState)state{
//    NSLog(@"%@", [NSString stringWithFormat:@"session state changed%@", self.streamStateDictionary[@(state)]]);
//}
/// @abstract 因产生了某个 error 而断开时的回调
//- (void)cameraStreamingSession:(PLCameraStreamingSession *)session didDisconnectWithError:(NSError *)error{
//    NSLog(@"%@", [NSString stringWithFormat:@"session disconnected due to error %@", error]);
//    [self tryReconnect:error];
//}

- (void)tryReconnect:(nullable NSError *)error
{
    if (self.reconnectCount < 2) {
        _reconnectCount ++;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * pow(2, self.reconnectCount) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self.session restartWithFeedback:^(PLStreamStartStateFeedback feedback) {
//
//            }];
        });
    }else{
//        [AlertViewManager alertWithTitle:@"断开连接" message:error.localizedDescription andCompleteBlock:^(NSInteger buttonIndex) {
//            [weakSelf stopPlayer];
//            [weakSelf.navigationController performSelectorOnMainThread:@selector(popViewControllerAnimated:)
//                                                            withObject:@(YES) waitUntilDone:NO];
//        }];
    }
}

/// @abstract 当开始推流时，会每间隔 3s 调用该回调方法来反馈该 3s 内的流状态，包括视频帧率、音频帧率、音视频总码率
//- (void)cameraStreamingSession:(PLCameraStreamingSession *)session streamStatusDidUpdate:(PLStreamStatus *)status{
//    NSLog(@"%@", [NSString stringWithFormat:@"session status %@", status]);
//}
/// @abstract 摄像头授权状态发生变化的回调
//- (void)cameraStreamingSession:(PLCameraStreamingSession *)session didGetCameraAuthorizationStatus:(PLAuthorizationStatus)status{
//    NSLog(@"%@", [NSString stringWithFormat:@"camera authorization status changed %@", self.authorizationDictionary[@(status)]]);
//}
/// @abstract 麦克风授权状态发生变化的回调
//- (void)cameraStreamingSession:(PLCameraStreamingSession *)session didGetMicrophoneAuthorizationStatus:(PLAuthorizationStatus)status{
//    NSLog(@"%@", [NSString stringWithFormat:@"microphone  authorization status changed %@", self.authorizationDictionary[@(status)]]);
//}

// @abstract 获取到摄像头原数据时的回调, 便于开发者做滤镜等处理，需要注意的是这个回调在 camera 数据的输出线程，请不要做过于耗时的操作，否则可能会导致推流帧率下降
//- (CVPixelBufferRef)cameraStreamingSession:(PLCameraStreamingSession *)session cameraSourceDidGetPixelBuffer:(CVPixelBufferRef)pixelBuffer
//{
//    if (self.needProcessVideo) {
//        size_t w = CVPixelBufferGetWidth(pixelBuffer);
//        size_t h = CVPixelBufferGetHeight(pixelBuffer);
//        size_t par = CVPixelBufferGetBytesPerRow(pixelBuffer);
//        CVPixelBufferLockBaseAddress(pixelBuffer, 0);
//        uint8_t *pimg = CVPixelBufferGetBaseAddress(pixelBuffer);
//        for (int i = 0; i < w; i ++){
//            for (int j = 0; j < h; j++){
//                pimg[j * par + i * 4 + 1] = 255;
//            }
//        }
//        CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
//    }
//    return pixelBuffer;
//}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.zhiboVM.chatArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatCell *cell=[tableView dequeueReusableCellWithIdentifier:[ChatCell cellReuseIdentifier] forIndexPath:indexPath];
    cell.chatM=[self.zhiboVM.chatArray safeObjectAtIndex:indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatModel *chatM=[self.zhiboVM.chatArray safeObjectAtIndex:indexPath.row];
    return chatM.cellHeight;
}

@end
