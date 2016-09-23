//
//  BroadcastModelViewController.m
//  iOSDemo
//
//  Created by 赵云锋 on 16/8/23.
//  Copyright © 2016年 gensee. All rights reserved.
//

#import "BroadcastPXViewController.h"
#import <RtSDK/RtSDK.h>
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"
#import "ShareManager.h"
#import "UserDefaults.h"
@interface BroadcastPXViewController ()<GSBroadcastDelegate, GSBroadcastInvestigationDelegate, GSBroadcastVideoDelegate, GSBroadcastDesktopShareDelegate>
{
    BOOL videoFullScreen; //视频全屏
    BOOL statusPlay;
    BOOL statusCamera;
    BOOL statusMicrophone;
    BOOL statusShare;
    BOOL statusSetCameraFrontOrBehind;
    BOOL statusTapScreen;
}
@property (assign, nonatomic)CGRect originalVideoFrame;
@property (assign, nonatomic)long long userID; // 当前激活的视频ID
@property (assign, nonatomic)BOOL isCameraVideoDisplaying;
@property (assign, nonatomic)BOOL isLodVideoDisplaying;
@property (assign, nonatomic)BOOL isDesktopShareDisplaying;

@property (strong, nonatomic)MBProgressHUD *progressHUD;
@property (strong, nonatomic)GSBroadcastManager *broadcastManager;
@property (strong, nonatomic)GSVideoView *videoView;

@property (weak, nonatomic) IBOutlet UIButton *btnPlay;
@property (weak, nonatomic) IBOutlet UIButton *btnClose;
@property (weak, nonatomic) IBOutlet UIButton *btnCamera;
@property (weak, nonatomic) IBOutlet UIButton *btnMicrophone;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (weak, nonatomic) IBOutlet UIButton *btnSetCameraFrontOrBehind;



@end

@implementation BroadcastPXViewController
{
    AVCaptureVideoPreviewLayer *_previewLayer;
}
-(void)viewWillAppear:(BOOL)animated{
    statusPlay=true;
    statusCamera=true;
    statusMicrophone = true;
    statusSetCameraFrontOrBehind = true;
    statusTapScreen = false;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self.btnPlay addTarget:self action:@selector(handlePlayStatus) forControlEvents:UIControlEventTouchUpInside];
    [self.btnClose addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnCamera addTarget:self action:@selector(handleCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.btnMicrophone addTarget:self action:@selector(handleMicrophone) forControlEvents:UIControlEventTouchUpInside];
    [self.btnSetCameraFrontOrBehind addTarget:self action:@selector(handleSetCameraFrontOrBehind) forControlEvents:UIControlEventTouchUpInside];
    [self.btnShare addTarget:self action:@selector(handleShare) forControlEvents:UIControlEventTouchUpInside];
    [self initBroadCastManager];
    [self enterBackground];
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = left;
}

-(void)handleShare{
    NSString *sTitle = @"无界互联"; //Only support QQ and Weixin
    NSString *sDesc = @"无界互联正在直播中";
    //NSString *sUrl = @"http://wujie.woojoin.com/10007.html";
    NSString *sid = [UserDefaults seerseeliveId];
    NSString *sUrl  = [NSString stringWithFormat:@"%@%@%@", @"http://wujie.woojoin.com/",sid,@".html"];
    
    UIImage *image=[UIImage imageNamed:@"ic_launcher.png"];
    SMImage *sImage = [[SMImage alloc] initWithImage:image];
    [[ShareManager sharedManager] setContentWithTitle:sTitle description:sDesc image:sImage url:sUrl];
    [[ShareManager sharedManager] showShareWindow];
}

-(void)handlePlayStatus{
    if(statusPlay){
        statusPlay=false;
        [_btnPlay setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        [self setStatusZhiboPause];
    }else{
        statusPlay=true;
        [_btnPlay setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
        [self setStatusZhibo];
    }
}

-(void)handleCamera{
    if(statusCamera){
        [self.broadcastManager inactivateCamera];
        statusCamera=false;
    }else{
        [self.broadcastManager activateCamera];
        statusCamera=true;
    }
}

-(void)handleMicrophone{
    if(statusMicrophone){
        [self closeMyMicrophone];
        statusMicrophone=false;
    }else{
        [self openMyMicrophone];
        statusMicrophone=true;
    }
}

-(void)handleSetCameraFrontOrBehind{
    if(statusSetCameraFrontOrBehind){
        statusSetCameraFrontOrBehind=false;
        [self.broadcastManager switchToBackCamera:YES landScape:YES];
    }else{
        statusSetCameraFrontOrBehind=true;
        [self.broadcastManager switchToBackCamera:NO landScape:YES];
    }
}

-(void)btnsShow{
    [self.view bringSubviewToFront:_btnClose];
    [self.view bringSubviewToFront:_btnCamera];
    [self.view bringSubviewToFront:_btnMicrophone];
    [self.view bringSubviewToFront:_btnShare];
    [self.view bringSubviewToFront:_btnSetCameraFrontOrBehind];
    
}
-(void)btnsHide{
    [self.view sendSubviewToBack:_btnClose];
    [self.view sendSubviewToBack:_btnCamera];
    [self.view sendSubviewToBack:_btnMicrophone];
    [self.view sendSubviewToBack:_btnShare];
    [self.view sendSubviewToBack:_btnSetCameraFrontOrBehind];
}

-(BOOL)shouldAutorotate{
    return NO;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationLandscapeRight;
}

- (void)back:(id)sender
{
    [self.broadcastManager leaveAndShouldTerminateBroadcast:NO];
    [self.broadcastManager invalidate];
    [self.broadcastManager setStatus:GSBroadcastStatusPause];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

//设置后台运行
- (void)enterBackground
{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [session setActive:YES error:nil];
}

//打开摄像头
- (void)openMyCamera
{
    //    [self.broadcastManager activateCamera];
    [self.broadcastManager switchToBackCamera:NO landScape:YES];
    statusCamera=true;
}

//关闭摄像头
- (void)closeMyCamra
{
    //[self.broadcastManager inactivateCamera];
    [self.broadcastManager switchToBackCamera:YES landScape:YES];
    statusCamera=false;
}

//打开麦克风
- (void)openMyMicrophone
{
    [self.broadcastManager activateMicrophone];
    
    //    [self.broadcastManager setCameraLanscape:YES];
    
    //    [self.broadcastManager switchToBackCamera:YES landScape:NO];
}

//关闭麦克风
- (void)closeMyMicrophone
{
    [self.broadcastManager inactivateMicrophone];
    
    //    [self.broadcastManager switchToBackCamera:YES landScape:YES];
}

//开始直播
- (void)setStatusZhibo
{
    [self.broadcastManager setStatus:GSBroadcastStatusRunning];
    statusPlay=true;
}
//关闭直播
- (void)setStatusZhiboPause
{
    [self.broadcastManager setStatus:GSBroadcastStatusPause];
    statusPlay=false;
}
- (void)broadcastManager:(GSBroadcastManager *)manager didSetStatus:(GSBroadcastStatus)status{
    
}
- (void)setup
{
    _originalVideoFrame = CGRectMake(0, 0, self.view.bounds.size.height, self.view.bounds.size.width);
    self.videoView = [[GSVideoView alloc]initWithFrame:_originalVideoFrame];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleVideoViewTap:)];
    [self.videoView addGestureRecognizer:tapGes];
    
    //    UISwipeGestureRecognizer *swipeGes = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleVideoViewSwipe:)];
    //    [self.videoView addGestureRecognizer:swipeGes];
    self.videoView.videoViewContentMode = GSVideoViewContentModeRatioFit;
    
    [self.view addSubview:self.videoView];
}

- (void)initBroadCastManager
{
    self.broadcastManager = [GSBroadcastManager sharedBroadcastManager];
    self.broadcastManager.broadcastDelegate = self;
    self.broadcastManager.videoDelegate = self;
    self.broadcastManager.desktopShareDelegate = self;
    self.broadcastManager.investigationDelegate = self;
    
    self.broadcastManager.videoRotateFlag=YES;
    
    if (![_broadcastManager connectBroadcastWithConnectInfo:self.connectInfo]) {
        
        [self.progressHUD show:NO];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"WrongConnectInfo", @"参数不正确") delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"知道了") otherButtonTitles:nil, nil];
        [alertView show];
    }
    else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"连接房间成功";
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        
        [hud hide:YES afterDelay:3];
    }
}

//手势识别
- (void)handleVideoViewTap:(UITapGestureRecognizer*)recognizer
{
    
    if(statusTapScreen)
    {
        [self btnsHide];
        statusTapScreen=false;
    }else{
        [self btnsShow];
        statusTapScreen=true;
    }
    [self.broadcastManager displayVideo:self.userID];
}

- (void)handleVideoViewSwipe:(UISwipeGestureRecognizer*)recognizer
{
    [self btnsHide];
}

#pragma mark-
#pragma mark GSBroadcastManagerDelegate

// 直播初始化代理
- (void)broadcastManager:(GSBroadcastManager*)manager didReceiveBroadcastConnectResult:(GSBroadcastConnectResult)result
{
    switch (result) {
            case GSBroadcastConnectResultSuccess:
            
            // 直播初始化成功，加入直播
            if (![self.broadcastManager join]) {
                
                [self.progressHUD hide:YES];
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:  NSLocalizedString(@"BroadcastConnectionError",  @"直播连接失败提示") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",  @"确认") otherButtonTitles:nil, nil];
                [alertView show];
            }
            else{
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
                // Configure for text only and offset down
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"加入房间成功";
                hud.margin = 10.f;
                hud.removeFromSuperViewOnHide = YES;
                
                [hud hide:YES afterDelay:6];
                [self.broadcastManager switchToBackCamera:NO landScape:YES];
            }
            
            break;
            
            case GSBroadcastConnectResultInitFailed:
            
            case GSBroadcastConnectResultJoinCastPasswordError:
            
            case GSBroadcastConnectResultWebcastIDInvalid:
            
            case GSBroadcastConnectResultRoleOrDomainError:
            
            case GSBroadcastConnectResultLoginFailed:
            
            case GSBroadcastConnectResultNetworkError:
            
            case GSBroadcastConnectResultWebcastIDNotFound:
        {
            [self.progressHUD hide:YES];
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:  NSLocalizedString(@"BroadcastConnectionError",  @"直播连接失败提示") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",  @"确认") otherButtonTitles:nil, nil];
            [alertView show];
        }
            break;
        default:
            break;
    }
}

/*
 直播连接代理
 rebooted为YES，表示这次连接行为的产生是由于根服务器重启而导致的重连
 */
- (void)broadcastManager:(GSBroadcastManager*)manager didReceiveBroadcastJoinResult:(GSBroadcastJoinResult)joinResult selfUserID:(long long)userID rootSeverRebooted:(BOOL)rebooted;
{
    //1
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"连接中。。。";
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:3];
    
    [self.progressHUD hide:YES];
    [self.broadcastManager setStatus:GSBroadcastStatusRunning];
    // 服务器重启导致重连
    if (rebooted) {
        // 相应处理
    }
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.manager =  self.broadcastManager;
}

// 断线重连
- (void)broadcastManagerWillStartRoomReconnect:(GSBroadcastManager*)manager
{
    //    [self.progressHUD show:YES];
    //    self.progressHUD.labelText = NSLocalizedString(@"Reconnect", @"正在重连");
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"正在重连";
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:3];
    
}

- (void)broadcastManager:(GSBroadcastManager*)manager didSelfLeaveBroadcastFor:(GSBroadcastLeaveReason)leaveReason
{
    [self.broadcastManager invalidate];
    [self.progressHUD hide:YES];
}


#pragma mark -
#pragma mark GSBroadcastVideoDelegate
// 收到一路视频
- (void)broadcastManager:(GSBroadcastManager*)manager didUserJoinVideo:(GSUserInfo *)userInfo
{
    //    // 收到插播视频
    //    if (userInfo.userID == LOD_USER_ID) {
    //
    //        // 如果正在播放摄像头视频
    //        if (self.isCameraVideoDisplaying)
    //        {
    //            // 停止播放摄像头视频
    //            [self.broadcastManager undisplayVideo:self.userID ];
    //        }
    //        // 显示插播视频
    //        [self.broadcastManager displayVideo:userInfo.userID];
    //
    //        self.userID = LOD_USER_ID;
    //    }
    //3
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"收到视频成功";
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:3];
    [self.broadcastManager displayVideo:userInfo.userID];
    [self.broadcastManager setVideo:userInfo.userID active:YES];
}

// 某一路摄像头视频被激活
- (void)broadcastManager:(GSBroadcastManager*)manager didSetVideo:(GSUserInfo*)userInfo active:(BOOL)active
{
    //7
    if (active && !self.isDesktopShareDisplaying && !self.isLodVideoDisplaying) {
        // 将上一次激活的视频关闭
        [self.broadcastManager undisplayVideo:self.userID];
        
        [self.broadcastManager displayVideo:userInfo.userID];
        self.userID = userInfo.userID;
    }
    
}

// 某一路视频播放代理
- (void)broadcastManager:(GSBroadcastManager*)manager didDisplayVideo:(GSUserInfo*)userInfo
{
    //4
    if (self.isDesktopShareDisplaying)
    {
        [self.broadcastManager undisplayVideo:userInfo.userID];
    }
    
    if (userInfo.userID == LOD_USER_ID) {
        self.isLodVideoDisplaying = YES;
    }
    else
    {
        self.isCameraVideoDisplaying = YES;
    }
}

// 某一路视频关闭播放代理
- (void)broadcastManager:(GSBroadcastManager*)manager didUndisplayVideo:(long long)userID
{
    if (userID == LOD_USER_ID) {
        self.isLodVideoDisplaying = NO;
    }
    else
    {
        self.isCameraVideoDisplaying = NO;
    }
}

// 摄像头或插播视频每一帧的数据代理
- (void)broadcastManager:(GSBroadcastManager*)manager userID:(long long)userID renderVideoFrame:(GSVideoFrame*)videoFrame
{
    // 指定Videoview渲染每一帧数据
    //    [_videoView renderVideoFrame:videoFrame];
    //6
}

#pragma mark -
#pragma mark GSBroadcastDesktopShareDelegate

// 桌面共享视频连接代理
- (void)broadcastManager:(GSBroadcastManager*)manager didReceiveDesktopShareModuleInitResult:(BOOL)result;
{
    
}

// 开启桌面共享代理
- (void)broadcastManager:(GSBroadcastManager*)manager didActivateDesktopShare:(long long)userID
{
    // 停止显示视频
    if (self.isCameraVideoDisplaying)
    {
        [self.broadcastManager undisplayVideo:self.userID];
    }
    
    self.isDesktopShareDisplaying = YES;
}


// 桌面共享视频每一帧的数据代理
- (void)broadcastManager:(GSBroadcastManager*)manager renderDesktopShareFrame:(UIImage*)videoFrame
{
    // 指定Videoview渲染每一帧数据
    //    [self.videoView renderVideoFrame:videoFrame];
    if (self.isDesktopShareDisplaying) {
        [self.videoView renderAsVideoByImage:videoFrame];
    }
    
    
}


// 桌面共享关闭代理
- (void)broadcastManagerDidInactivateDesktopShare:(GSBroadcastManager*)manager
{
    // 显示视频
    [self.broadcastManager displayVideo:self.userID];
    
    self.isDesktopShareDisplaying = NO;
}


- (BOOL)broadcastManagerDidStartCaptureVideo:(GSBroadcastManager *)manager
{
    //2
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"开始捕获视频";
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:3];
    
    [self performSelector:@selector(setUpPreview) withObject:nil afterDelay:1];
    
    return YES;
    
}

- (void)setUpPreview
{
    //5
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"正在渲染视频";
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:3];
    
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    CGFloat y = [[UIApplication sharedApplication] statusBarFrame].size.height;
    double version = [[UIDevice currentDevice].systemVersion doubleValue];//判定系统版本。
    if (version < 7.0) {
        y -= 64;
    }
    
    _originalVideoFrame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    self.videoView = [[GSVideoView alloc]initWithFrame:_originalVideoFrame];
    
    
    _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.broadcastManager.avsession];
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill; // 设置预览时的视频缩放方式
    [[_previewLayer connection] setVideoOrientation:AVCaptureVideoOrientationLandscapeRight]; // 设置视频的朝向
    
    _previewLayer.frame = _originalVideoFrame;
    [self.view.layer addSublayer:_previewLayer];
    [self.view bringSubviewToFront:_btnPlay];
}


#pragma mark -
#pragma mark GSBroadcastAudioDelegate

// 音频模块连接代理
- (void)broadcastManager:(GSBroadcastManager*)manager didReceiveAudioModuleInitResult:(BOOL)result
{
    if (!result) {
        NSLog(@"音频加载失败");
    }
}


#pragma mark -
#pragma mark System Default Code

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    // 退出直播，但不结束直播, 若参数为YES,直播将同时结束
    [self.broadcastManager leaveAndShouldTerminateBroadcast:NO];
    // 释放资源
    [self.broadcastManager invalidate];
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


@end