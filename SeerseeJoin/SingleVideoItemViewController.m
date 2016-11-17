//
//  SingleVideoItemViewController.m
//  iOSDemo
//
//  Created by Gaojin Hsu on 3/18/15.
//  Copyright (c) 2015 gensee. All rights reserved.
//

#import "SingleVideoItemViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"
#import "MBProgressHUD.h"




/*
 以视频形式展现的数据有两种，一种是真正意义上的视频即『视频』（Video），另一种是『桌面共享』（DesktopShare）; 尽管
 他们的形式很接近，但是它们所需要实现的代理是不同的，所以要对它们分开处理， 视频需要实现GSBroadcastVideoDelegate，
 而桌面共享需要实现GSBroadcastDesktopShareDelegate；『视频』（Video）又可以细分为『摄像头视频』（Camera Video）』和
 『插播』（Lod Video），他们之间没有本质的区别，唯一的区别是插播的UserID 是固定值（LOD_USER_ID），插播是指在直播端客户端播放媒体文件，
 而所谓的一路视频的场景是指只有一个View可以显示视频，但是有的直播端（有时候也称教师端，一般是PC或Mac客户端）能同时发送桌面共享和视频，
 因此需要自己实现逻辑控制他们的播放优先级，一般来说桌面共享和插播的优先级要大于摄像头视频，桌面共享和和插播在直播端是无法同时打开的，
 因此他们之前没有优先级之分。下面的例子是实现一路视频，桌面共享或者插播的优先级要大于摄像头视频。
 */


#define DegreesToRadians(x) ((x) * M_PI / 180.0)

@interface SingleVideoItemViewController ()<GSBroadcastDelegate, GSBroadcastVideoDelegate, GSBroadcastDesktopShareDelegate, GSBroadcastAudioDelegate>
{
   BOOL videoFullScreen; //视频全屏


}


@property (strong, nonatomic)GSBroadcastManager *broadcastManager;
@property (strong, nonatomic)GSVideoView *videoView;
@property (assign, nonatomic)long long userID; // 当前激活的视频ID
@property (assign, nonatomic)BOOL isCameraVideoDisplaying;
@property (assign, nonatomic)BOOL isLodVideoDisplaying;
@property (assign, nonatomic)BOOL isDesktopShareDisplaying;
@property (strong, nonatomic)MBProgressHUD *progressHUD;
@property (assign, nonatomic)CGRect originalVideoFrame;
@property (weak, nonatomic) IBOutlet UIButton *receiveVideoBtn;
@property (weak, nonatomic) IBOutlet UIButton *rejectVideoBtn;
@property (weak, nonatomic) IBOutlet UIButton *receiveAudioBtn;
@property (weak, nonatomic) IBOutlet UIButton *rejectAudioBtn;

@end

@implementation SingleVideoItemViewController

#pragma mark -
#pragma mark View Did Load/Undload

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *isException= [defaults objectForKey:IsException];
    if ([isException isEqualToString:@"YES"]) {
        UIAlertView *alert =
        [[UIAlertView alloc]
         initWithTitle:NSLocalizedString(@"错误报告", nil)
         message:@"检测到程序意外终止，是否发送错误报告"
         delegate:self
         cancelButtonTitle:NSLocalizedString(@"忽略", nil)
         otherButtonTitles:NSLocalizedString(@"发送", nil), nil];
        alert.tag=1004;
        [alert show];
    }
    [defaults setObject:@"NO" forKey:IsException];
    

    
    self.progressHUD = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:self.progressHUD];
    self.progressHUD.labelText =  NSLocalizedString(@"BroadcastConnecting",  @"直播连接提示");
    [self.progressHUD show:YES];

    
    [self initBroadCastManager];
    
    [self setup];
    
    [self enterBackground];
    
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithTitle:@"back" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = left;

}

- (void)back:(id)sender
{
//    [self.progressHUD show:YES];
//    self.progressHUD.labelText = @"Leaving...";
    [self.broadcastManager leaveAndShouldTerminateBroadcast:NO];
    [self.broadcastManager invalidate];
//    [self.progressHUD hide:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

//设置后台运行
- (void)enterBackground
{
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [session setActive:YES error:nil];
}



#pragma mark - AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
   if (alertView.tag==1004)
    {
        
        if (buttonIndex==1) {
            
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^(){
                
                GSDiagnosisInfo *DiagnosisInfo =[[GSDiagnosisInfo alloc] init];
                [DiagnosisInfo ReportDiagonse];
            });
            
        }else if (buttonIndex==0)
        {
            
        }
    }
    
}




- (void)initBroadCastManager
{
    self.broadcastManager = [GSBroadcastManager sharedBroadcastManager];
    self.broadcastManager.broadcastDelegate = self;
    self.broadcastManager.videoDelegate = self;
    self.broadcastManager.desktopShareDelegate = self;
    self.broadcastManager.audioDelegate = self;
    self.broadcastManager.hardwareAccelerateDecodeSupport = YES;

    if (![_broadcastManager connectBroadcastWithConnectInfo:self.connectInfo]) {
        
        [self.progressHUD show:NO];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"WrongConnectInfo", @"参数不正确") delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"知道了") otherButtonTitles:nil, nil];
        [alertView show];

    }

}

- (void)setup
{

    CGFloat y = self.navigationController.navigationBar.frame.size.height+[[UIApplication sharedApplication] statusBarFrame].size.height;
    
    double version = [[UIDevice currentDevice].systemVersion doubleValue];//判定系统版本。
    if (version < 7.0) {
        y -= 64;
    }
    
    _originalVideoFrame = CGRectMake(0, y, self.view.frame.size.width, self.view.frame.size.width - 70);
    self.videoView = [[GSVideoView alloc]initWithFrame:_originalVideoFrame];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleVideoViewTap:)];
    tapGes.numberOfTapsRequired = 2;
    [self.videoView addGestureRecognizer:tapGes];
    self.videoView.videoViewContentMode = GSVideoViewContentModeRatioFill;
    
    [self.view addSubview:self.videoView];
}

#pragma mark -
#pragma mark Actions

- (void)switchFullScreen:(UIGestureRecognizer*)tapGes
{
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.allowRotation =  !appDelegate.allowRotation;
    
    //强制旋转
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {

            [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIDeviceOrientationPortrait] forKey:@"orientation"];

    } else {

            [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIInterfaceOrientationLandscapeRight ] forKey:@"orientation"];
        
    }

}


//自动旋转
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)
interfaceOrientation duration:(NSTimeInterval)duration {
    
    if (!UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        self.videoView.frame = _originalVideoFrame;
        
        [_receiveAudioBtn setHidden:NO];
        [_receiveVideoBtn setHidden:NO];
        [_rejectAudioBtn setHidden:NO];
        [_rejectVideoBtn setHidden:NO];
        
    }else {
        
        [_receiveAudioBtn setHidden:YES];
        [_receiveVideoBtn setHidden:YES];
        [_rejectAudioBtn setHidden:YES];
        [_rejectVideoBtn setHidden:YES];
        
        CGFloat y = self.navigationController.navigationBar.frame.size.height+[[UIApplication sharedApplication] statusBarFrame].size.height;
        
        double version = [[UIDevice currentDevice].systemVersion doubleValue];//判定系统版本。
        if (version < 7.0) {
            y = 0;
        }

//        int widthP=self.view.frame.size.width;
//        int heigthP=self.view.frame.size.height;
//        NSLog(@"%d-%d--%f",widthP,heigthP,y);
//        y=600
        self.videoView.frame = CGRectMake(0, y, self.view.frame.size.width, self.view.frame.size.height - y);
        
        
    }
    
}

/**
 *  视频播放旋转
 *
 *  @param recognizer
 */
//- (void)handleVideoViewTap:(UITapGestureRecognizer*)recognizer
//{
//    if (!videoFullScreen)
//    {
//        videoFullScreen = YES;
//        [_receiveAudioBtn setHidden:YES];
//        [_receiveVideoBtn setHidden:YES];
//        [_rejectAudioBtn setHidden:YES];
//        [_rejectVideoBtn setHidden:YES];
//        
//        [self.view setBackgroundColor:[UIColor blackColor]];
//        float statusheight = [[UIApplication sharedApplication] statusBarFrame].size.height;
//        [self.navigationController.navigationBar setHidden:YES];
//        
//        [UIView beginAnimations : @"video full screen" context:nil];
//        [UIView setAnimationDuration:0.3];
//        [UIView setAnimationBeginsFromCurrentState:YES];
//        self.videoView.frame =  CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);//self.view.bounds;
//
//        float navHeight = self.navigationController.navigationBar.frame.size.height;
//        CGPoint center = CGPointMake(self.view.center.x, self.view.center.y - navHeight/2 - statusheight/2);
//        self.videoView.center = center;
//        self.videoView.transform = CGAffineTransformMakeRotation(DegreesToRadians(90));
//        
//        [UIView commitAnimations];
//        [self.navigationController.navigationBar setHidden:YES];
//        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
//    }
//    else
//    {
//        videoFullScreen = NO;
//        
//        [_receiveAudioBtn setHidden:NO];
//        [_receiveVideoBtn setHidden:NO];
//        [_rejectAudioBtn setHidden:NO];
//        [_rejectVideoBtn setHidden:NO];
//        
//        [self.view setBackgroundColor:[UIColor whiteColor]];
// 
//        [UIView beginAnimations : @"video exits full screen" context:nil];
//        [UIView setAnimationDuration:0.2];
//        [UIView setAnimationBeginsFromCurrentState:YES];
//        self.videoView.transform = CGAffineTransformMakeRotation(DegreesToRadians(0));
//        
//        CGFloat y = self.navigationController.navigationBar.frame.size.height+[[UIApplication sharedApplication] statusBarFrame].size.height;
//        double version = [[UIDevice currentDevice].systemVersion doubleValue];//判定系统版本。
//        if (version < 7.0) {
//            y = 0;
//        }
//        self.videoView.frame = CGRectMake(0, y, _originalVideoFrame.size.width, _originalVideoFrame.size.height);
//    
//        [UIView commitAnimations];
//        [self.navigationController.navigationBar setHidden:NO];
//        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
//   
//    }
//}

-(void)handleDocViewTap:(UITapGestureRecognizer*)recongnizer
{
    
}

- (void)handleVideoViewTap:(UITapGestureRecognizer*)recognizer
{
    if (!videoFullScreen)
    {
        [UIView animateWithDuration:0.5 animations:^{
            self.view.transform = CGAffineTransformMakeRotation(M_PI/2);
            self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
            self.videoView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
            
            videoFullScreen = YES;

            [_receiveAudioBtn setHidden:YES];
            [_receiveVideoBtn setHidden:YES];
            [_rejectAudioBtn setHidden:YES];
            [_rejectVideoBtn setHidden:YES];
            
            self.navigationController.navigationBarHidden = YES;
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
        }];
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            self.view.transform = CGAffineTransformInvert(CGAffineTransformMakeRotation(0));
            self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);

            self.videoView.frame = _originalVideoFrame;
            videoFullScreen = NO;
            [_receiveAudioBtn setHidden:NO];
            [_receiveVideoBtn setHidden:NO];
            [_rejectAudioBtn setHidden:NO];
            [_rejectVideoBtn setHidden:NO];
            
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
            self.navigationController.navigationBarHidden = NO;
        }];
    }
}

- (IBAction)turnOnVideo:(id)sender {
    
    [self.broadcastManager displayVideo:self.userID];
}

- (IBAction)turnOffVideo:(id)sender {
    
    [self.broadcastManager undisplayVideo:self.userID];
    
}

- (IBAction)turnOnSpeaker:(id)sender {
    [self.broadcastManager activateSpeaker];
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker
                                    error:nil];
    [audioSession setActive:YES error:nil];
}

- (IBAction)trunOffSpeaker:(id)sender {
    [self.broadcastManager inactivateSpeaker];
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
}

#pragma mark -
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
            
            case  GSBroadcastConnectResultThirdTokenError:
        {
            [self.progressHUD hide:YES];
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:  NSLocalizedString(@"第三方K值验证错误",  @"直播连接失败提示") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",  @"确认") otherButtonTitles:nil, nil];
            [alertView show];
        }
            
            
        default:
            [self.progressHUD hide:YES];
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:  NSLocalizedString(@"BroadcastConnectionError",  @"直播连接失败提示") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",  @"确认") otherButtonTitles:nil, nil];
            [alertView show];
            break;
    }
}

/*
 直播连接代理
 rebooted为YES，表示这次连接行为的产生是由于根服务器重启而导致的重连
 */
- (void)broadcastManager:(GSBroadcastManager*)manager didReceiveBroadcastJoinResult:(GSBroadcastJoinResult)joinResult selfUserID:(long long)userID rootSeverRebooted:(BOOL)rebooted;
{
    [self.progressHUD hide:YES];
    
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
    [self.progressHUD show:YES];
    self.progressHUD.labelText = NSLocalizedString(@"Reconnect", @"正在重连");
    
}

- (void)broadcastManager:(GSBroadcastManager *)manager didSetStatus:(GSBroadcastStatus)status
{
    
}

- (void)broadcastManager:(GSBroadcastManager*)manager didSelfLeaveBroadcastFor:(GSBroadcastLeaveReason)leaveReason
{
    [self.broadcastManager invalidate];
    [self.progressHUD hide:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark GSBroadcastVideoDelegate

// 视频模块连接代理
- (void)broadcastManager:(GSBroadcastManager*)manager didReceiveVideoModuleInitResult:(BOOL)result
{
    
}

// 摄像头是否可用代理
- (void)broadcastManager:(GSBroadcastManager*)manager isCameraAvailable:(BOOL)isAvailable
{
    
}

// 摄像头打开代理
- (void)broadcastManagerDidActivateCamera:(GSBroadcastManager*)manager
{
    
}

// 摄像头关闭代理
- (void)broadcastManagerDidInactivateCamera:(GSBroadcastManager*)manager
{
    
}

// 收到一路视频
- (void)broadcastManager:(GSBroadcastManager*)manager didUserJoinVideo:(GSUserInfo *)userInfo
{
    // 收到插播视频
    if (userInfo.userID == LOD_USER_ID) {
        
        // 如果正在播放摄像头视频
        if (self.isCameraVideoDisplaying)
        {
            // 停止播放摄像头视频
            [self.broadcastManager undisplayVideo:self.userID ];
        }
        // 显示插播视频
        [self.broadcastManager displayVideo:userInfo.userID];
        
        self.userID = LOD_USER_ID;
    }
}

// 某个用户退出视频
- (void)broadcastManager:(GSBroadcastManager*)manager didUserQuitVideo:(long long)userID
{
    [self.broadcastManager undisplayVideo:userID];
}

// 某一路摄像头视频被激活
- (void)broadcastManager:(GSBroadcastManager*)manager didSetVideo:(GSUserInfo*)userInfo active:(BOOL)active
{
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
    [_videoView renderVideoFrame:videoFrame];
}

- (void)OnVideoData4Render:(long long)userId width:(int)nWidth nHeight:(int)nHeight frameFormat:(unsigned int)dwFrameFormat displayRatio:(float)fDisplayRatio data:(void *)pData len:(int)iLen
{
    [_videoView hardwareAccelerateRender:pData size:iLen];
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
    
      self.isDesktopShareDisplaying = NO;
    // 显示视频
    [self.broadcastManager displayVideo:self.userID];
    
  
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc
{

    
}

@end
