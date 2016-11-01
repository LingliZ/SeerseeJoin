//
//  DownLoadViewController.m
//  VodSDKDemo
//
//  Created by gs_mac_wjj on 15/9/21.
//  Copyright © 2015年 Gensee. All rights reserved.
//

#import "DownLoadViewController.h"
#import <VodSDK/VodSDK.h>
#import "UserDefaults.h"
//#import "ViewController.h"
#import "MBProgressHUD.h"
#import "RecordingPlayViewController.h"
@interface DownLoadViewController ()<VodDownLoadDelegate>

{
    downItem *downloadItem;
}

@property (nonatomic, weak) IBOutlet UILabel *lable;
@property (nonatomic, weak) IBOutlet UIProgressView *progressbar;
@property (nonatomic, weak) IBOutlet UIButton *downloadBtn;
@property (nonatomic, weak) IBOutlet UIButton *pauseDownloadBtn;
@property (nonatomic, weak) IBOutlet UIButton *deleteDownloadBtn;
@property (nonatomic, weak) IBOutlet UIButton *vodPlayBtn;

@property (nonatomic,strong) VodDownLoader *voddownloader;
@property (nonatomic ,strong) NSString *vodId;

@end

@implementation DownLoadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    控件初始化
    self.lable.text = @"下载进度: 0%";
    self.progressbar.progress = 0.0;
    self.vodPlayBtn.enabled = NO;
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(clickBackButton)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    [self.downloadBtn addTarget:self action:@selector(doDownloader) forControlEvents:UIControlEventTouchUpInside];
    [self.pauseDownloadBtn addTarget:self action:@selector(doPauseDownload) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteDownloadBtn addTarget:self action:@selector(doDeleteDownload) forControlEvents:UIControlEventTouchUpInside];
    [self.vodPlayBtn addTarget:self action:@selector(doVodPlay) forControlEvents:UIControlEventTouchUpInside];
    
    if (!self.voddownloader) {
        self.voddownloader = [[VodDownLoader alloc]init];
    }
    self.voddownloader.delegate = self;
    
}

//Navigation返回按钮方法
- (void)clickBackButton
{
    self.voddownloader = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

//添加到下载( 开始下载 )
- (void)doDownloader
{
    [self.voddownloader addItem:_domain number:_number loginName:nil vodPassword:_vodPassword loginPassword:nil downFlag:0 serType:_seviceType oldVersion:NO
                         kToken:nil];

    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

//暂停下载
- (void)doPauseDownload
{
    [_voddownloader stop:_vodId];
}

//删除下载
- (void)doDeleteDownload
{
    [self.voddownloader delete:_vodId];
    [self.progressbar setProgress:0.0];
    self.lable.text = @"下载进度: 0%";
    _vodPlayBtn.enabled = NO;
}

//离线播放
- (void)doVodPlay
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    //ViewController *vodViewController = [board instantiateViewControllerWithIdentifier:@"player"];
    RecordingPlayViewController *vodViewController = [board instantiateViewControllerWithIdentifier:@"player"];
    [vodViewController setItem:downloadItem];
    [vodViewController setIsLivePlay:NO];
    [self.navigationController pushViewController:vodViewController animated:YES];
}

#pragma mark - VodDownLoadDelegate
//下载进度代理
- (void)onDLPosition:(NSString *)downLoadId percent:(float)percent
{
    NSString *percentstr = [NSString stringWithFormat:@"下载进度: %f",percent];
    _lable.text = percentstr;
    [_progressbar setProgress:percent/100 animated:YES];
}

//下载开始代理
- (void)onDLStart:(NSString *)downLoadId{
    NSLog(@"APP:下载开始");
}

//下载完成代理
- (void) onDLFinish:(NSString*) downLoadId
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"下载完成" ,@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"知道了",@"") otherButtonTitles:nil, nil];
    [alertView show];
    _vodPlayBtn.enabled = YES;
}

//下载出错代理
- (void)onDLError:(NSString *)downloadID Status:(VodDownLoadStatus)errorCode
{
    NSLog(@"APP:下载出错");
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"下载出错" ,@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"知道了",@"") otherButtonTitles:nil, nil];
    [alertView show];
}

//添加到下载代理
- (void)onAddItemResult:(RESULT_TYPE)resultType voditem:(downItem *)item{
    NSLog(@"APP: onAddItemResult:(RESULT_TYPE)resultType voditem:(downItem*)item");
    if (resultType == RESULT_SUCCESS) {
        _vodId = item.strDownloadID;
        downloadItem = [[VodManage shareManage]findDownItem:_vodId];
        [self.voddownloader download:downloadItem chatPost:NO];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"未知错误" ,@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"知道了",@"") otherButtonTitles:nil, nil];
        [alertView show];
    }
}

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

@end
