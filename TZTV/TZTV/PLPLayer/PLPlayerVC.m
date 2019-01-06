//
//  PLPlayerVC.m
//  TZTV
//
//  Created by Luosa on 2016/11/10.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "PLPlayerVC.h"
#import "PlayEndVC.h"
#import "LYLiveGiftBarrage.h"
#import "LYLiveGiftView.h"
#import <BarrageRenderer.h>
#import "NSSafeObject.h"
#import "ChatCell.h"
#import "ChatModel.h"
#import "UIImageView+YJ.h"
#import "PLGiftView.h"
#import "PLGoodsView.h"
#import "PLPlayerViewModel.h"

#define enableBackgroundPlay    0

static NSString *status[] = {
    @"PLPlayerStatusUnknow",    //0
    @"PLPlayerStatusPreparing", //1
    @"PLPlayerStatusReady",     //2
    @"PLPlayerStatusCaching",   //3
    @"PLPlayerStatusPlaying",   //4
    @"PLPlayerStatusPaused",    //5
    @"PLPlayerStatusStopped",   //6
    @"PLPlayerStatusError"      //7
};

@interface PLPlayerVC ()<LYLiveGiftViewDelegate,UITableViewDelegate,UITableViewDataSource>
//@property (nonatomic, strong) PLPlayer *player;
@property (nonatomic, assign) int reconnectCount;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UIView      *topView;
@property (weak, nonatomic) IBOutlet UIView      *luoboView;
@property (weak, nonatomic) IBOutlet UIView      *bottomView;
@property (weak, nonatomic) IBOutlet UIButton    *loveBtn;//点赞按钮
@property (weak, nonatomic) IBOutlet UITableView *chatTableView;
@property (weak, nonatomic) IBOutlet UIView      *editingView;//里面包含输入文本框和发送按钮
@property (weak, nonatomic) IBOutlet UIView      *containView;//里面包含editingView和chatTableView
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containViewBottomConstraint;//containView距屏幕底部的约束
@property (weak, nonatomic) IBOutlet UIView     *giftContainView;//上面礼物动画页面
@property (nonatomic, strong) LYLiveGiftBarrage *giftService;
@property (nonatomic, strong) PLGiftView        *plgiftView;//下面礼物列表页面
@property (nonatomic, strong) PLGoodsView       *plgoodsView;
@property (nonatomic,   weak) CAEmitterLayer    *emitterLayer;//粒子动画
@property (nonatomic, strong) BarrageRenderer   *renderer;//弹幕
@property (nonatomic, strong) NSTimer           *timer;
@property (nonatomic, assign) BOOL colsedByUser;
@property (nonatomic, strong) PLPlayerViewModel *playerVM;
@end

@implementation PLPlayerVC

-(PLPlayerViewModel *)playerVM
{
    if (!_playerVM) {
        _playerVM=[PLPlayerViewModel new];
    }
    return _playerVM;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configPLPlayerOption];//加载播放器
    self.view.backgroundColor=[UIColor blackColor];
    [self.chatTableView registerClass:[ChatCell class] forCellReuseIdentifier:[ChatCell cellReuseIdentifier]];
    self.reconnectCount = 0;
    
    _giftService = [[LYLiveGiftBarrage alloc] initBarrageToView:_giftContainView];
    
#if !enableBackgroundPlay
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(startPlayer)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
#endif
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChangeFrame:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    [self startPlayer];
    [self p_initData];
    [self createTimer];
}

-(void)p_initData{
    NSDictionary *json=@{@"live_id":_live_id,
                         @"live_user_id":_live_user_id,
                         @"user_id":[[AccountTool account] pid] ? [[AccountTool account] pid]:@"0"};
    [[self.playerVM configDataWithJson:json] subscribeNext:^(id x) {
        [self p_updateMainView];
    } error:^(NSError *error) {
        [self p_updateMainView];
    }];
}

-(void)p_updateMainView{
    NSDictionary *user=self.playerVM.zhuboInfo[@"user"];
    self.nameLabel.text=user[@"user_nicname"];
    [self.iconIV setCircleImage:user[@"user_image"] andPlaceHolderImg:@"60_60"];
    
    self.zaixianNumLabel.text=[NSString stringWithFormat:@"在线：%d人",[self.playerVM.online_num intValue]];
    self.loveNumLabel.text=[NSString stringWithFormat:@"点赞数：%d",[self.playerVM.like_num intValue]];
    [YJTOOL showMoreLoveAnimateFromView:self.loveBtn addToView:self.view];//冒星星
    [self.chatTableView reloadData];
    [self.chatTableView setContentOffset:CGPointMake(0, MAX(0, self.chatTableView.contentSize.height - self.chatTableView.height))
                                animated:YES];
}

-(void)createTimer{
    //不用scheduled方式初始化的，需要手动addTimer:forMode: 将timer添加到一个runloop中。而scheduled的初始化方法将以默认mode直接添加到当前的runloop中.
    //invalidate 这个是唯一一个可以将计时器从runloop中移出的方法。
    if (self.playerVM.needUpdate) {
        NSLog(@"重新加载初始化数据");
        [self p_initData];
    }else{
        self.timer=[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(getChatAndNum) userInfo:nil repeats:YES];
        //[[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

-(void)getChatAndNum{
    WEAK_SELF
    [[self.playerVM getChatAndNumWithParma:@{@"live_id":_live_id}] subscribeNext:^(id x) {
        [weakSelf p_updateMainView];
    } error:^(NSError *error) {
        [weakSelf p_updateMainView];
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
    [_giftService startBarrage];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self stopPlayer];
    if (self.textField.isEditing) [self.textField resignFirstResponder];
    self.navigationController.navigationBarHidden=NO;
    [_giftService stopBarrage];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

#pragma mark - <PLPlayerDelegate>
//只有在正常连接，正常断开的情况下跳转的状态才会触发这一回调。
//所谓正常连接是指通过调用 -play 方法使得流连接的各种状态，而所谓正常断开是指调用 -stop 方法使得流断开的各种状态。
//以下状态会触发这一回调方法。PLPlayerStatusPreparing  PLPlayerStatusReady PLPlayerStatusCaching
//PLPlayerStatusPlaying PLPlayerStatusPaused PLPlayerStatusStopped
//- (void)player:(nonnull PLPlayer *)player statusDidChange:(PLPlayerStatus)state {
//    // 这里会返回流的各种状态，你可以根据状态做 UI 定制及各类其他业务操作
//    // 除了 Error 状态，其他状态都会回调这个方法
//    if (PLPlayerStatusCaching == state) {
//        [self.activityIndicatorView startAnimating];
//    }else if (PLPlayerStatusStopped == state){
//        if (!self.colsedByUser) {
//            //PLPlayerStatusStopped，该状态仅会在回放时播放结束出现，RTMP 直播结束并不会出现此状态
//
////            [AlertViewManager alertWithMessage:@"已结束播放" andCompleteBlock:^(NSInteger buttonIndex) {
////                if (buttonIndex==1) {
////                    [self stopPlayer];
////                    [self.navigationController popViewControllerAnimated:YES];
////                }
////            }];
//        }
//    }else{
//        [self.activityIndicatorView stopAnimating];
//    }
//}

//最好可以在此时尝试调用 -play 方法进行有限次数的重连。
//采用重连间隔加倍的方式，例如共尝试 2 次重连，第一次等待 0.5s, 第二次等待 1s, 第三次等待 2s
//- (void)player:(nonnull PLPlayer *)player stoppedWithError:(nullable NSError *)error {
//    // 当发生错误时，会回调这个方法
//    [self.activityIndicatorView stopAnimating];
//    [self tryReconnect:error];
//}

- (void)tryReconnect:(nullable NSError *)error {
    if (self.reconnectCount < 2) {
        _reconnectCount ++;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * pow(2, self.reconnectCount) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self.player play];
        });
    }else{
        WEAK_SELF
//        [AlertViewManager alertWithTitle:@"断开连接" message:error.localizedDescription andCompleteBlock:^(NSInteger buttonIndex) {
//            [weakSelf stopPlayer];
//            [weakSelf.navigationController performSelectorOnMainThread:@selector(popViewControllerAnimated:)
//                                                            withObject:@(YES) waitUntilDone:NO];
//        }];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.textField.isEditing) [self.textField resignFirstResponder];
    [self hiddenView];//去除礼物列表
}

#pragma mark - LYLiveGiftViewDelegate  送礼物跑车出场
- (void)giftView:(LYLiveGiftView *)giftView rechargeBtnDidClicked:(UIButton *)rechargeBtn {
    [self.view showAlert:@"前往充值页面"];
}

- (void)giftView:(LYLiveGiftView *)giftView sendBtnDidClickedWithFCount:(NSString *)fCount {
    [self hiddenView];
    [_giftService addBarrageItem:[LYLiveGiftBarrageView barrageWithAvatar:@"zhibo_head_xiao" nickName:@"我最帅" content:@"送一辆保时捷" giftIcon:@"tinyCar"]];
}

//删除View
- (void)hiddenView {
    if (_plgiftView) {
        [UIView animateWithDuration:0.2 animations:^{
            _plgiftView.y = ScreenH;
        } completion:^(BOOL finished) {
            [_plgiftView removeFromSuperview];
            _plgiftView=nil;
        }];
    }
    if (_plgoodsView) {
        [UIView animateWithDuration:0.2 animations:^{
            _plgoodsView.y = ScreenH;
        } completion:^(BOOL finished) {
            [_plgoodsView removeFromSuperview];
            _plgoodsView=nil;
        }];
    }
}

//各按钮点击事件
- (IBAction)btnClicked:(UIButton *)sender {
    if (sender.tag==994) {//关闭按钮
        self.colsedByUser=YES;
        [self stopPlayer];
        [self.navigationController popViewControllerAnimated:YES];
    }else if (sender.tag==999) {//弹出键盘,开始输入聊天
        if ([AccountTool getAccount:YES]==nil) return;
        [_textField becomeFirstResponder];
    }else if (sender.tag==998) {//举报按钮
//        [AlertViewManager alertWithTitle:@"提示" message:@"确定举报该主播?" leftBtn:@"取消" rightBtn:@"确定"
//                        andCompleteBlock:^(NSInteger buttonIndex) {
//            [MBProgressHUD showSuccess:@"举报成功，我们会尽快处理"];
//        }];
    }else if (sender.tag==997){//商品
        _plgoodsView=[[PLGoodsView alloc] initWithFrame:CGRectMake(0, ScreenH, ScreenW, [PLGoodsView view_height])];
        [self.view addSubview:_plgoodsView];
        _plgoodsView.live_user_id=_live_user_id;
        [UIView animateWithDuration:0.2 animations:^{
            _plgoodsView.y -= [PLGoodsView view_height];
        }];
    }else if (sender.tag==996){//礼物
        _plgiftView=[PLGiftView viewFromXib];
        _plgiftView.frame=CGRectMake(0, ScreenH, ScreenW, [PLGiftView view_height]);
        [self.view addSubview:_plgiftView];
        _plgiftView.giftArray=self.playerVM.giftDataArray;
        [UIView animateWithDuration:0.2 animations:^{
            self.plgiftView.y -= [PLGiftView view_height];
        }];
    }else if (sender.tag==995){//点赞
        if ([AccountTool getAccount:YES]==nil) return;
        [YJTOOL showMoreLoveAnimateFromView:_loveBtn addToView:self.view];//冒星星
        Account *account=[AccountTool account];
//        NSString *url=[NSString stringWithFormat:addLikeURL,_live_id,account.pid,account.token];
//        [[YJHttpRequest sharedManager] get:url params:nil success:nil failure:nil];
    }else if (sender.tag==99) {//发送评论
        if (self.textField.text.length==0){
            [MBProgressHUD showToast:@"内容不能为空"];
            return;
        }
        NSDictionary *parma=@{@"live_id":_live_id,@"content":self.textField.text};
        [[self.playerVM sendChatDataWithParma:parma] subscribeNext:^(id x) {
            [self.chatTableView reloadData];
            self.textField.text=@"";
            [self.textField resignFirstResponder];
        } error:^(NSError *error) {
            self.textField.text=@"";
            [self.textField resignFirstResponder];
        }];
    }
}

-(void)configPLPlayerOption{
//    PLPlayerOption *option = [PLPlayerOption defaultOption];
//    //播放器所用RTMP连接的超时断开时间长度，单位为秒。小于等于0表示无超时限制。
//    [option setOptionValue:@10 forKey:PLPlayerOptionKeyTimeoutIntervalForMediaPackets];
//    //一级缓存大小，单位为ms，默认为 1000ms，增大该值可以减小播放过程中的卡顿率，但会增大弱网环境的最大累积延迟。
//    [option setOptionValue:@1000 forKey:PLPlayerOptionKeyMaxL1BufferDuration];
//    //二级缓存大小，单位为ms，默认为 1000ms，增大该值可以减小播放过程中的卡顿率，但会增大弱网环境的最大累积延迟。
//    [option setOptionValue:@1000 forKey:PLPlayerOptionKeyMaxL2BufferDuration];
//    //是否使用video toolbox硬解码
//    [option setOptionValue:@(YES) forKey:PLPlayerOptionKeyVideoToolbox];
//    //配置log级别
//    [option setOptionValue:@(kPLLogWarning) forKey:PLPlayerOptionKeyLogLevel];
//    //解析部分不清楚，建议使用默认规则。
//    //[option setOptionValue:[QNDnsManager new] forKey:PLPlayerOptionKeyDNSManager];
//    YJLog(@"live_rtmp_play_url=====%@",self.live_rtmp_play_url);
//    self.player = [PLPlayer playerWithURL:[NSURL URLWithString:self.live_rtmp_play_url] option:option];
//    self.player.delegate = self;
//    self.player.delegateQueue = dispatch_get_main_queue();
//
//    //PLPlayer 需要注意的是在后台播放时仅有音频，视频会在回到前台时继续播放。
//    self.player.backgroundPlayEnable = enableBackgroundPlay;
    
//    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
//    if (self.player.status != PLPlayerStatusError) {
//        UIView *playerView = self.player.playerView;
//        if (!playerView.superview) {
//            playerView.contentMode = UIViewContentModeScaleToFill;
//            playerView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin
//            | UIViewAutoresizingFlexibleTopMargin
//            | UIViewAutoresizingFlexibleLeftMargin
//            | UIViewAutoresizingFlexibleRightMargin
//            | UIViewAutoresizingFlexibleWidth
//            | UIViewAutoresizingFlexibleHeight;
//            [self.view addSubview:playerView];
//            [self.view sendSubviewToBack:self.player.playerView];
//        }
//        //添加粒子效果
//        [self.view.layer insertSublayer:self.emitterLayer above:playerView.layer];
//        //添加弹幕
//        [playerView addSubview:self.renderer.view];
//        [self.renderer stop];
//    }
}

#pragma mark - 弹幕控制器
-(BarrageRenderer *)renderer{
    if (!_renderer) {
        _renderer=[BarrageRenderer new];
        _renderer.canvasMargin = UIEdgeInsetsMake(ScreenH * 0.3, 10, 10, 10);
    }
    return _renderer;
}

#pragma mark - 弹幕描述符生产方法
- (void)autoSendBarrage{
    NSInteger spriteNumber = [self.renderer spritesNumberWithName:nil];
    if (spriteNumber <= 50) { // 限制屏幕上的弹幕量
        [self.renderer receive:[self walkTextSpriteDescriptorWithDirection:BarrageWalkDirectionR2L]];
    }
}

long _index = 0;
/// 生成精灵描述 - 过场文字弹幕
- (BarrageDescriptor *)walkTextSpriteDescriptorWithDirection:(NSInteger)direction{
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
    descriptor.spriteName = NSStringFromClass([BarrageWalkTextSprite class]);
    descriptor.params[@"text"] = self.danMuText[arc4random_uniform((uint32_t)self.danMuText.count)];
    descriptor.params[@"textColor"] = RANDOM_COLOR;
    descriptor.params[@"speed"] = @(100 * (double)random()/RAND_MAX+50);
    descriptor.params[@"direction"] = @(direction);
    descriptor.params[@"clickAction"] = ^{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"弹幕被点击" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alertView show];
    };
    return descriptor;
}
- (NSArray *)danMuText{
    return [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"danmu.plist" ofType:nil]];
}

#pragma mark - 粒子效果
- (CAEmitterLayer *)emitterLayer
{
    if (!_emitterLayer) {
        CAEmitterLayer *emitterLayer = [CAEmitterLayer layer];
        // 发射器在xy平面的中心位置
        emitterLayer.emitterPosition = CGPointMake(ScreenW-40,ScreenH-60);
        // 发射器的尺寸大小
        emitterLayer.emitterSize = CGSizeMake(20, 20);
        // 渲染模式
        emitterLayer.renderMode = kCAEmitterLayerUnordered;
        // 开启三维效果
        //    _emitterLayer.preservesDepth = YES;
        NSMutableArray *array = [NSMutableArray array];
        // 创建粒子
        for (int i = 1; i<10; i++) {
            // 发射单元
            CAEmitterCell *stepCell = [CAEmitterCell emitterCell];
            // 粒子的创建速率，默认为1/s
            stepCell.birthRate = 1;
            // 粒子存活时间
            stepCell.lifetime = arc4random_uniform(4) + 1;
            // 粒子的生存时间容差
            stepCell.lifetimeRange = 1.5;
            // 颜色
            //fire.color=[[UIColor colorWithRed:0.8 green:0.4 blue:0.2 alpha:0.1]CGColor];
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"good%d_30x30_", i]];
            // 粒子显示的内容
            stepCell.contents = (id)[image CGImage];
            // 粒子的名字
            //            [fire setName:@"step%d", i];
            // 粒子的运动速度
            stepCell.velocity = arc4random_uniform(100) + 100;
            // 粒子速度的容差
            stepCell.velocityRange = 80;
            // 粒子在xy平面的发射角度
            stepCell.emissionLongitude = M_PI+M_PI_2;;
            // 粒子发射角度的容差
            stepCell.emissionRange = M_PI_2/6;
            // 缩放比例
            stepCell.scale = 0.3;
            [array addObject:stepCell];
        }
        emitterLayer.emitterCells = array;
        _emitterLayer = emitterLayer;
    }
    return _emitterLayer;
}
             
- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    if (!self.textField.isEditing) return;
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect beginFrame = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    if (endFrame.size.height == 0) return;
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    _containViewBottomConstraint.constant = beginFrame.origin.y < endFrame.origin.y ? 0 : endFrame.size.height;
    [UIView animateWithDuration:duration delay:0.0f options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:^{
        [self.view layoutIfNeeded];
        _editingView.alpha = !(beginFrame.origin.y < endFrame.origin.y);
    } completion:nil];
}

-(UIActivityIndicatorView *)activityIndicatorView
{
    if (!_activityIndicatorView) {
        _activityIndicatorView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activityIndicatorView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
        _activityIndicatorView.hidesWhenStopped=YES;
        [self.view addSubview:_activityIndicatorView];
        [_activityIndicatorView stopAnimating];
    }
    return _activityIndicatorView;
}

-(void)dealloc
{
    [self stopPlayer];
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.playerVM.chatArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatCell *cell=[tableView dequeueReusableCellWithIdentifier:[ChatCell cellReuseIdentifier] forIndexPath:indexPath];
    cell.chatM=[self.playerVM.chatArray safeObjectAtIndex:indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatModel *chatM=[self.playerVM.chatArray safeObjectAtIndex:indexPath.row];
    return chatM.cellHeight;
}

- (void)startPlayer {
//    [self.activityIndicatorView startAnimating];
//    [UIApplication sharedApplication].idleTimerDisabled = YES;//保持屏幕常亮
//    [self.player play];
//    [self.renderer start];//弹幕
    
    //开启弹幕定时器
    //    NSSafeObject *safeObj = [[NSSafeObject alloc] initWithObject:self withSelector:@selector(autoSendBarrage)];
    //    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:safeObj selector:@selector(excute) userInfo:nil repeats:YES];
}

-(void)stopPlayer{
//    if ([_timer isValid]) {
//        [_timer invalidate];
//        _timer=nil;
//    }
//    if (_player) {
//        _player.delegate=nil;
//        _player.delegateQueue=nil;
//        _player.backgroundPlayEnable=NO;
//        [_player stop];
//        [_player.playerView removeFromSuperview];
//        _player=nil;
//    }
//    if (_emitterLayer) {//去除精灵动画
//        [_emitterLayer removeFromSuperlayer];
//        _emitterLayer = nil;
//    }
//    if (_renderer) {//去除弹幕
//        [_renderer stop];
//        [_renderer.view removeFromSuperview];
//        _renderer = nil;
//    }
//    [UIApplication sharedApplication].idleTimerDisabled = NO;//取消屏幕常亮
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [[self.view subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

@end







