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
#import "membersTableViewCell.h"
#import "QuestionTableViewCell.h"
#import "MemberBase.h"
#import <NSString+Color.h>
#import "KeyboardToolBar.h"
#import "UITableView+EmptyData.h"

@interface BroadcastPXViewController ()<GSBroadcastDelegate, GSBroadcastInvestigationDelegate, GSBroadcastVideoDelegate, GSBroadcastDesktopShareDelegate,GSBroadcastDocumentDelegate,UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate,GSBroadcastQaDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    BOOL videoFullScreen; //视频全屏
    BOOL statusCamera;
    BOOL statusMicrophone;
    BOOL statusShare;
    BOOL statusSetCameraFrontOrBehind;
    BOOL statusTapScreen;
    UIImagePickerController *_imagePickerController;
    //MemberBase *mb;
}
@property (assign, nonatomic)CGRect originalVideoFrame;
@property (assign, nonatomic)CGRect originalVideoOnlineFrame;
@property (assign, nonatomic)CGRect originalDocFrame;

@property (assign, nonatomic)long long userID; // 当前激活的视频ID
@property (assign, nonatomic)BOOL isCameraVideoDisplaying;
@property (assign, nonatomic)BOOL isLodVideoDisplaying;
@property (assign, nonatomic)BOOL isDesktopShareDisplaying;

@property (strong, nonatomic)MBProgressHUD *progressHUD;
@property (strong, nonatomic)GSBroadcastManager *broadcastManager;
@property (strong, nonatomic)GSVideoView *videoView;
@property (strong, nonatomic)GSVideoView *videoViewOnline;
@property (strong, nonatomic)GSDocView *videoViewDoc;
@property (strong, nonatomic)GSDocument *globaldocument;

@property (strong, nonatomic)NSMutableDictionary *questionsDic;
@property (strong, nonatomic)NSMutableArray *questionArray;
@property (strong, nonatomic)NSMutableArray *questionArrayNew;
@property unsigned int globalPageID;

@property (weak, nonatomic) IBOutlet UIButton *btnPlay;
@property (weak, nonatomic) IBOutlet UIButton *btnRecording;
@property (weak, nonatomic) IBOutlet UIButton *btnMembers;
@property (weak, nonatomic) IBOutlet UIButton *btnDoc;

@property (weak, nonatomic) IBOutlet UIButton *btnClose;
@property (weak, nonatomic) IBOutlet UIButton *btnCamera;
@property (weak, nonatomic) IBOutlet UIButton *btnMicrophone;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (weak, nonatomic) IBOutlet UIButton *btnSetCameraFrontOrBehind;
@property (weak, nonatomic) IBOutlet UIButton *btnUploadImg;
@property (weak, nonatomic) IBOutlet UIButton *btnSwitchDoc;
@property (weak, nonatomic) IBOutlet UIButton *btnQuestion;
@property (weak, nonatomic) IBOutlet UIButton *btnVoice;
@property (weak, nonatomic) IBOutlet UIButton *btnConfig;

@property (strong,nonatomic) NSMutableArray *membersArr;
@property (strong,nonatomic) NSMutableDictionary *membersDic;
@property (strong,nonatomic) NSMutableArray *docArr;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelCount;
@property (weak, nonatomic) IBOutlet UIView *toolBar;

@property (weak, nonatomic) IBOutlet UITableView *membersTable;
@property (weak, nonatomic) IBOutlet UITableView *questionTable;
@property (weak, nonatomic) IBOutlet UITableView *docTable;

@property (weak, nonatomic) IBOutlet UIView *viewQuestion;
@property (weak, nonatomic) IBOutlet UITextField *txtQuestionInput;
@property (weak, nonatomic) IBOutlet UIButton *btnQuestionSend;
@property (strong, nonatomic) NSString *questionAnswering;
@end

@implementation BroadcastPXViewController
{
    AVCaptureVideoPreviewLayer *_previewLayer;
}

#pragma mark lifecycle -生命周期
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    statusCamera=true;
    statusMicrophone = true;
    statusSetCameraFrontOrBehind = true;
    statusTapScreen = false;
    
    [self.btnPlay.layer setBorderWidth:1];
    self.btnPlay.layer.borderColor=[UIColor whiteColor].CGColor;
    [self.btnRecording.layer setBorderWidth:1];
    self.btnRecording.layer.borderColor=[UIColor whiteColor].CGColor;
    [self.btnUploadImg.layer setBorderWidth:1];
    self.btnUploadImg.layer.borderColor=[UIColor whiteColor].CGColor;
    [self.btnSwitchDoc.layer setBorderWidth:1];
    self.btnSwitchDoc.layer.borderColor=[UIColor whiteColor].CGColor;
    NSLog(@"viewDidAppear():视图2,收到的参数:from=%@",[self.parameter objectForKey:@"castname"]);
    self.labelTitle.text =[self.parameter objectForKey:@"castname"];
    
    
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _membersDic = [[NSMutableDictionary alloc] init];
    _membersArr = [[NSMutableArray alloc] init];
    _docArr = [[NSMutableArray alloc]init];
    _questionsDic = [NSMutableDictionary dictionary];
    _questionArray = [NSMutableArray array];
    
    self.toolBar.backgroundColor = [[UIColor grayColor]colorWithAlphaComponent:0.7f];
    [self setupTable];
    [self setupActionSheet];
    [self setupDoc];
    [self setup];
    [self.btnPlay addTarget:self action:@selector(handlePlayStatus:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnRecording addTarget:self action:@selector(handRecordingStatus:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnClose addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnCamera addTarget:self action:@selector(handleCamera:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnMicrophone addTarget:self action:@selector(handleMicrophone:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnSetCameraFrontOrBehind addTarget:self action:@selector(handleSetCameraFrontOrBehind:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnVoice addTarget:self action:@selector(handVoice:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnShare addTarget:self action:@selector(handleShare) forControlEvents:UIControlEventTouchUpInside];
    [self.btnUploadImg addTarget:self action:@selector(handleUploadImg) forControlEvents:UIControlEventTouchUpInside];
    [self.btnSwitchDoc addTarget:self action:@selector(handleSwitchDoc) forControlEvents:UIControlEventTouchUpInside];
    [self.btnDoc addTarget:self action:@selector(handleDoc) forControlEvents:UIControlEventTouchUpInside];
    [self.btnConfig addTarget:self action:@selector(handleConfig) forControlEvents:UIControlEventTouchUpInside];
    [self.btnMembers addTarget:self action:@selector(handleMembers) forControlEvents:UIControlEventTouchUpInside];
    [self.btnQuestion addTarget:self action:@selector(handQuestion) forControlEvents:UIControlEventTouchUpInside];
    [self.btnQuestionSend addTarget:self action:@selector(sendQuestion) forControlEvents:UIControlEventTouchUpInside];
    [self initBroadCastManager];
    [self enterBackground];
    [self setupOnline];
    [self setupQuestion];
}

#pragma setup - 初始化方法

- (void)setup
{
    
}

-(void)setupActionSheet{
    
}

-(void)setupTable{
    self.membersTable.dataSource = self;
    self.membersTable.delegate = self;
    
    self.docTable.dataSource = self;
    self.docTable.delegate = self;
}

-(void)setupDoc
{
    
    _originalDocFrame = CGRectMake(0, 0, self.view.bounds.size.height, self.view.bounds.size.width);
    self.videoViewDoc = [[GSDocView alloc]initWithFrame:_originalDocFrame];
    [self.videoViewDoc setGlkBackgroundColor:0 green:0 blue:0];
    self.videoViewDoc.zoomEnabled = YES;
    self.videoViewDoc.fullMode = NO;
    
    UISwipeGestureRecognizer *recognizer;
    recognizer= [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleDocViewSwipe:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.videoViewDoc addGestureRecognizer:recognizer];
    
    
    recognizer= [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleDocViewSwipe:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.videoViewDoc addGestureRecognizer:recognizer];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleDocViewTap:)];
    [self.videoViewDoc addGestureRecognizer:tapGes];
    
    
    [self.view addSubview:self.videoViewDoc];
}

- (void)setupOnline
{
    _originalVideoOnlineFrame = CGRectMake(0, 0, self.view.bounds.size.height, self.view.bounds.size.width);
    self.videoViewOnline = [[GSVideoView alloc]initWithFrame:_originalVideoOnlineFrame];
    self.videoViewOnline.videoViewContentMode = GSVideoViewContentModeRatioFill;
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleVideoViewTap:)];
    [self.videoViewOnline addGestureRecognizer:tapGes];
    [self.view addSubview:self.videoViewOnline];
    
    
    
}

-(void) setupQuestion
{
    [KeyboardToolBar registerKeyboardToolBarWithTextField:self.txtQuestionInput];
    [self.questionTable setDelegate:self];//指定委托
    [self.questionTable setDataSource:self];//指定数据委托
    [self.questionTable setBackgroundColor:[UIColor colorWithWhite:0.7 alpha:0.5]];
}

#pragma mark - UITable相关设置

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Incomplete implementation, return the number of sections
    
    if([tableView isEqual:self.membersTable])
    {
        return 1;
    }
    if([tableView isEqual:self.questionTable])
    {
        NSUInteger c = _questionArray.count;
        [tableView tableViewDisplayWitMsg:@"暂无聊天内容" ifNecessaryForRowCount:c];
        return _questionArray.count;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete implementation, return the number of rows
    
    if([tableView isEqual:self.membersTable])
    {
        
        return self.membersArr.count;
    }
    if([tableView isEqual:self.questionTable])
    {
        NSUInteger c =((GSQuestion*)[_questionsDic objectForKey:_questionArray[section]]).answers.count;
        if(c<=0)
        {
            c=1;
        }
        return c;
    }
    if([tableView isEqual:self.docTable])
    {
        NSUInteger c = [_docArr count];
        [tableView tableViewDisplayWitMsg:@"暂无文档" ifNecessaryForRowCount:[_docArr count]];
        return self.docArr.count;
    }
    return 1;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView isEqual:self.docTable])
    {
        cell.backgroundColor = [UIColor clearColor];
        cell.backgroundView.backgroundColor = [UIColor clearColor];
        return;
    }
    if([tableView isEqual:self.membersTable])
    {
        cell.backgroundColor = [UIColor colorWithWhite:0.3f alpha:0.3f];
        cell.backgroundView.backgroundColor = [UIColor colorWithWhite:0.3f alpha:0.3f];
        return;
    }
    
    if([tableView isEqual:self.questionTable])
    {
        cell.backgroundColor = [UIColor colorWithWhite:0.3f alpha:0.3f];
        cell.backgroundView.backgroundColor = [UIColor colorWithWhite:0.3f alpha:0.3f];
        return;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if([tableView isEqual:self.membersTable])
    {
        membersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"membersCell" forIndexPath:indexPath];
        
        if(self.membersArr!=nil&&self.membersArr!=NULL)
        {
            //            NSObject *a = self.membersArr[indexPath.row];
            //
            //            cell.mName.text =[a valueForKey:@"userName"];
            //
            //            cell.btnMainVideo.tag = indexPath.row;
            //            [cell.btnMainVideo addTarget:self action:@selector(handMainVideoUser:) forControlEvents:UIControlEventTouchUpInside];
            //
            //            cell.btnShotof.tag =indexPath.row;
            //            [cell.btnShotof setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:0.6]];//par1(0~1之间，从黑到白,alpha0~1  透明到不透明)
            //            [cell.btnShotof addTarget:self action:@selector(handShotOffUser:) forControlEvents:UIControlEventTouchUpInside];
            //
            //            cell.btnMic.tag = indexPath.row;
            //            [cell.btnMic addTarget:self action:@selector(handMicUser:) forControlEvents:UIControlEventTouchUpInside];
            //
            //            cell.btnCamera.tag = indexPath.row;
            //            [cell.btnCamera addTarget:self action:@selector(handCameraUser:) forControlEvents:UIControlEventTouchUpInside];
            NSString *uid = self.membersArr[indexPath.row];
            GSUserInfo *gsUserinfo = [_membersDic objectForKey:uid];
            
            cell.mName.text =gsUserinfo.userName;
            
            cell.btnMainVideo.tag = indexPath.row;
            [cell.btnMainVideo addTarget:self action:@selector(handMainVideoUser:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.btnShotof.tag =indexPath.row;
            [cell.btnShotof setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:0.6]];//par1(0~1之间，从黑到白,alpha0~1  透明到不透明)
            [cell.btnShotof addTarget:self action:@selector(handShotOffUser:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.btnMic.tag = indexPath.row;
            [cell.btnMic addTarget:self action:@selector(handMicUser:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.btnCamera.tag = indexPath.row;
            [cell.btnCamera addTarget:self action:@selector(handCameraUser:) forControlEvents:UIControlEventTouchUpInside];
            
            [self synchronousMemberStatus:uid btncamera:cell.btnCamera btnmic:cell.btnMic];
        }
        return cell;
    }
    if([tableView isEqual:self.questionTable])
    {
        QuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QuestionCell"];
        if (!cell) {
            cell = [[QuestionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QuestionCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        NSArray *answers = ((GSQuestion*)[_questionsDic objectForKey:_questionArray[indexPath.section]]).answers;
        NSString *answername =answers.count>0?((GSAnswer*)answers[indexPath.row]).ownerName:@"";
        NSString *answercontent =answers.count>0?((GSAnswer*)answers[indexPath.row]).answerContent:@"";
        
        NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
        //[formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss:SSS"];
        [formatter setDateFormat:@"hh:mm:ss"];
        NSString *date =  [formatter stringFromDate:[NSDate date]];
        NSString *timeLocal = [[NSString alloc] initWithFormat:@"%@", date];
        //NSLog(@"%@", timeLocal);
        
        if(answers.count>0)
        {
            NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@" [%@]:%@         [%@]回复:%@   %@",
                                                                                                    ((GSQuestion*)[_questionsDic objectForKey:_questionArray[indexPath.section]]).ownerName,
                                                                                                    ((GSQuestion*)[_questionsDic objectForKey:_questionArray[indexPath.section]]).questionContent,
                                                                                                    answername,
                                                                                                    answercontent,
                                                                                                    timeLocal
                                                                                                    ]];
            NSRange range=[[hintString string]rangeOfString:[NSString stringWithFormat:@"[%@]回复", answername]];
            [hintString addAttribute:NSForegroundColorAttributeName value:[@"#00a2ff" representedColor] range:range];
            cell.labelContent.attributedText = hintString;
        }
        else{
            NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@" [%@]:%@  %@",
                                                                                                    ((GSQuestion*)[_questionsDic objectForKey:_questionArray[indexPath.section]]).ownerName,
                                                                                                    ((GSQuestion*)[_questionsDic objectForKey:_questionArray[indexPath.section]]).questionContent,
                                                                                                    timeLocal
                                                                                                    ]];
            cell.labelContent.attributedText = hintString;
        }
        
        
        cell.btnReply.tag = indexPath.section;
        [cell.btnReply setTintColor:[UIColor orangeColor]];
        [cell.btnReply addTarget:self action:@selector(handleReply:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    if([tableView isEqual:self.docTable])
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DocCell"];
        if(self.docArr!=nil&&self.docArr!=NULL)
        {
            NSObject *a = self.docArr[indexPath.row];
            cell.textLabel.text =[a valueForKey:@"docName"];
            cell.textLabel.textColor = [UIColor whiteColor];
        }
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView isEqual:self.docTable])
    {
        NSObject *a = self.docArr[indexPath.row];
        
        int docid =[[a valueForKey:@"docID"] intValue];
        
        [self.broadcastManager publishDocGotoPage:docid pageId:0 sync2other:YES];
    }
}

#pragma mark - AlertView，UIActionSheet代理
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //long t =alertView.tag;
    if (buttonIndex == 1) {
        UITextField *txt = [alertView textFieldAtIndex:0];
        //获取txt内容即可
        [self.broadcastManager answerQuestion:_questionAnswering answer:txt.text];
    }
}

//UIActionSheet的协议方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        _imagePickerController = [[UIImagePickerController alloc] init];//初始化
        _imagePickerController.delegate = self;
        _imagePickerController.allowsEditing = YES;//设置可编辑
        _imagePickerController.sourceType = sourceType;
        
        [self presentViewController:_imagePickerController animated:YES completion:^{
            NSLog(@"进入相机");
        }];
    }
    else if(buttonIndex==1){
        _imagePickerController = [[UIImagePickerController alloc]init];
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //创建源类型
        UIImagePickerControllerSourceType mySourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _imagePickerController.sourceType = mySourceType;
        //设置代理
        _imagePickerController.delegate = self;
        //设置可编辑
        _imagePickerController.allowsEditing = YES;
        //通过模态的方式推出系统相册
        [self presentViewController:_imagePickerController animated:YES completion:^{
            NSLog(@"进入相册");
        }];
        
        
    }
}

#pragma mark - 用户列表方法处理
//踢出用户
-(void)handShotOffUser:(UIButton*)btn{
    NSLog(@"vvv%ld",(long)btn.tag);
    NSString *uid =self.membersArr[btn.tag];
    bool res = [self.broadcastManager ejectUser:[uid longLongValue]];
    if(res){
        [self.membersArr removeObjectAtIndex:btn.tag];
        [self.membersDic removeObjectForKey:uid];
    }
    NSLog(@"vvv");
}

//设为主视屏
-(void)handMainVideoUser:(UIButton*)btn{
    [self.broadcastManager setVideo:[self.membersArr[btn.tag] longLongValue] active:YES];
}

//关闭打开麦克风－列表
-(void)handMicUser:(UIButton*)btn{
    NSString *uid = _membersArr[btn.tag];
    GSUserInfo *userInfo =[self.membersDic objectForKey:uid];
    bool ismic = userInfo.isMicrophoneOpen;
    if(ismic==true)
    {
        //状态打开，关闭麦克风
        bool a= [self.broadcastManager inactivateUserMicrophone:userInfo.userID];
    }
    
    if(ismic==false)
    {
        //状态关闭，打开麦克风
        bool b= [self.broadcastManager activateUserMicrophone:userInfo.userID];
        NSLog(@"sdfsd");
    }
    NSLog(@"mic");
}

//关闭打开摄像头－列表
-(void)handCameraUser:(UIButton*)btn{
    int index = btn.tag;
    NSString *uid = _membersArr[btn.tag];
    GSUserInfo *userInfo =[self.membersDic objectForKey:uid];
    bool iscamera = userInfo.isCameraOpen;
    
    if(iscamera==true)
    {
        bool res = [self.broadcastManager inactivateUserCamera:userInfo.userID];
        if(res)
        {
            userInfo.isCameraOpen =false;
            [btn setBackgroundImage:[UIImage imageNamed:@"camera.png"] forState:UIControlStateNormal];
        }
    }
    if(iscamera==false)
    {
        bool res = [self.broadcastManager activateUserCamera:userInfo.userID];
        if(res)
        {
            userInfo.isCameraOpen =true;
            [btn setBackgroundImage:[UIImage imageNamed:@"camera0.png"] forState:UIControlStateNormal];
        }
    }
}

#pragma mark - 主界面方法处理

-(void)synchronousMemberSelfStatus:(NSString*)uid
{
    GSUserInfo *g = [_membersDic objectForKey:uid];
    
    if(g.isCameraOpen==true)
    {
        self.btnCamera.tag = 1;
        [self.btnCamera setBackgroundImage:[UIImage imageNamed:@"camera.png"] forState:UIControlStateNormal];
    }
    else
    {
        self.btnCamera.tag = 0;
        [self.btnCamera setBackgroundImage:[UIImage imageNamed:@"camera0.png"] forState:UIControlStateNormal];
    }
    
    //    if(g.isMicrophoneOpen==true)
    //    {
    //        self.btnMicrophone.tag = 1;
    //        [self.btnMicrophone setBackgroundImage:[UIImage imageNamed:@"mic1"] forState:UIControlStateNormal];
    //    }
    //    else{
    //        self.btnMicrophone.tag = 0;
    //        [self.btnMicrophone setBackgroundImage:[UIImage imageNamed:@"mic0"] forState:UIControlStateNormal];
    //    }
}

-(void)synchronousMemberStatus:(NSString*)uid btncamera:(UIButton*)btncamera btnmic:(UIButton*)btnmic
{
    GSUserInfo *g = [_membersDic objectForKey:uid];
    
    if(g.isCameraOpen==true)
    {
        [btncamera setBackgroundImage:[UIImage imageNamed:@"camera.png"] forState:UIControlStateNormal];
    }
    else
    {
        [btncamera setBackgroundImage:[UIImage imageNamed:@"camera0.png"] forState:UIControlStateNormal];
    }
    
    if(g.isMicrophoneOpen==true)
    {
        [btnmic setBackgroundImage:[UIImage imageNamed:@"mic1"] forState:UIControlStateNormal];
    }
    else{
        [btnmic setBackgroundImage:[UIImage imageNamed:@"mic0"] forState:UIControlStateNormal];
    }
}

-(void)handleMembers{
    
    if(self.btnMembers.tag==1)
    {
        [self.view sendSubviewToBack:self.membersTable];
        self.btnMembers.tag = 0;
        
    }
    else{
        [self hiddleTables];
        [self.membersTable reloadData];
        [self.view bringSubviewToFront:self.membersTable];
        self.btnMembers.tag = 1;
    }
}

-(void)handleDoc{
    
    if(self.btnDoc.tag==1)
    {
        self.btnDoc.tag=0;
        [self.view sendSubviewToBack:_videoViewDoc];
        [self.view sendSubviewToBack:_btnUploadImg];
        [self.view sendSubviewToBack:_btnSwitchDoc];
        [self.view sendSubviewToBack:_docTable];
    }
    else
    {
        [self hiddleTables];
        [self.docTable reloadData];
        
        [self.view bringSubviewToFront:_videoViewDoc];
        
        
        [self.view bringSubviewToFront:_btnSwitchDoc];
        [self.view bringSubviewToFront:_btnUploadImg];
        [self.view bringSubviewToFront:_docTable];
        [self.view bringSubviewToFront:_toolBar];
        [self.view.layer addSublayer:_previewLayer];
        self.btnDoc.tag=1;
    }
}

-(void)handleConfig{
    if(statusTapScreen)
    {
        [self btnsHide];
        statusTapScreen=false;
    }else{
        [self btnsShow];
        statusTapScreen=true;
    }
}

-(void)handQuestion{
    if(self.btnQuestion.tag==1)
    {
        [self.view sendSubviewToBack:self.questionTable];
        [self.view sendSubviewToBack:self.viewQuestion];
        [self.btnQuestion setImage:[UIImage imageNamed:@"chat.png"] forState:UIControlStateNormal];
        self.btnQuestion.tag = 0;
    }
    else{
        [self hiddleTables];
        [self.questionTable reloadData];
        [self.view bringSubviewToFront:self.questionTable];
        [self.view bringSubviewToFront:self.viewQuestion];
        self.btnQuestion.tag = 1;
    }
}

-(void)hiddleTables{
    if(self.btnQuestion.tag==1)
    {
        [self.view sendSubviewToBack:self.questionTable];
        [self.view sendSubviewToBack:self.viewQuestion];
        self.btnQuestion.tag = 0;
    }
    if(self.btnDoc.tag==1)
    {
        self.btnDoc.tag=0;
        [self.view sendSubviewToBack:_videoViewDoc];
        [self.view sendSubviewToBack:_btnUploadImg];
        [self.view sendSubviewToBack:_btnSwitchDoc];
        [self.view sendSubviewToBack:_docTable];
    }
    if(self.btnMembers.tag==1)
    {
        [self.view sendSubviewToBack:self.membersTable];
        self.btnMembers.tag = 0;
    }
    [self btnsHide];
    statusTapScreen=false;
}

-(void)sendQuestion{
    //发送问题
    bool res = [self.broadcastManager askQuestion:_txtQuestionInput.text];
    if(res){
        self.txtQuestionInput.text = @"";
    }
    NSLog(@"send");
}

-(void)handleUploadImg{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
    //展示行为列表
    [sheet showInView:self.view];
}

-(void)handleSwitchDoc{
    NSInteger t = self.btnSwitchDoc.tag;
    if(t==0)
    {
        self.btnSwitchDoc.tag=1;
        [self.docTable setHidden:NO];
    }
    else if(t==1)
    {
        self.btnSwitchDoc.tag=0;
        [self.docTable setHidden:YES];
    }
}

-(void)handleReply:(UIButton*)btn{
    _questionAnswering =((GSQuestion*)[_questionsDic objectForKey:_questionArray[btn.tag]]).questionID;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您的回答" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    UITextField *txtName = [alert textFieldAtIndex:0];
    txtName.placeholder = @"说点什么吧";
    alert.tag = 1;
    [alert show];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
        NSLog(@"取消") ;
    }];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //取得所选取的图片,原大小,可编辑等，info是选取的图片的信息字典
    UIImage *selectImage = [info objectForKey:UIImagePickerControllerEditedImage];
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    UIImage* imageItem = selectImage;
    
    if ([mediaType isEqualToString:@"public.image"]){
        
        imageItem= [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    if(imageItem == nil)
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"选择图片失败,请重新选择" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置时间格式
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    unsigned int m_docId= [self.broadcastManager publishDocOpen:str];
    unsigned int pageHandle=0;
    
    CGFloat imageH= imageItem.size.height;
    CGFloat imageW= imageItem.size.width;
    
    int bitCounts=32;
    NSString* titleText=@"example";
    NSString* fullText=@"example";
    
    NSString* aniCfg=@"";
    NSString* pageComment=@"";
    
    //    NSData *imageData = 0(imageItem);
    
    NSData *imageData = UIImageJPEGRepresentation([self scaleAndRotateImage: imageItem],0.93);
    BOOL isSuccess=   [self.broadcastManager publishDocTranslataData:m_docId pageHandle:pageHandle pageWidth:imageW pageHeight:imageH bitCounts:bitCounts titleText:titleText fullText:fullText aniCfg:aniCfg pageComment:pageComment data:imageData];
    
    
    [self.broadcastManager publishDocTranslateEnd:m_docId bSuccess:isSuccess];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
    
    //10-20
    [picker dismissViewControllerAnimated:YES completion:^{
        NSLog(@"模态返回") ;
    }];
}

- (UIImage *)scaleAndRotateImage:(UIImage *)image {
    
    int kMaxResolution = 640; // Or whatever
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = roundf(bounds.size.width / ratio);
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = roundf(bounds.size.height * ratio);
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}


-(void)handleShare{
    NSString *sTitle = @"无界互联"; //Only support QQ and ;
    NSString *sDesc = @"无界互联正在直播中";
    //NSString *sUrl = @"http://wujie.woojoin.com/10007.html";
    NSString *sid = [UserDefaults seerseeliveId];
    NSString *sUrl  = [NSString stringWithFormat:@"%@%@%@", @"http://wujie.woojoin.com/",sid,@".html"];
    
    UIImage *image=[UIImage imageNamed:@"ic_launcher.png"];
    SMImage *sImage = [[SMImage alloc] initWithImage:image];
    [[ShareManager sharedManager] setContentWithTitle:sTitle description:sDesc image:sImage url:sUrl];
    [[ShareManager sharedManager] showShareWindow];
}

-(void)handlePlayStatus:(UIButton*)btn{
    long index = btn.tag;
    switch (index) {
        case 1:
            [self.broadcastManager setStatus:GSBroadcastStatusPause];
            break;
        case 2:
            [self.broadcastManager setStatus:GSBroadcastStatusRunning];
            break;
        case 3:
            [self.broadcastManager setStatus:GSBroadcastStatusRunning];
            break;
        default:
            [self.broadcastManager setStatus:GSBroadcastStatusRunning];
            break;
    }
}

-(void)handRecordingStatus:(UIButton*)btn{
    bool a;
    long index = btn.tag;
    switch (index) {
        case 1:
            a = [self.broadcastManager setRecordingStatus:GSBroadcastStatusPause];
            break;
        case 2:
            [self.broadcastManager setRecordingStatus:GSBroadcastStatusRunning];
            break;
        case 3:
            a =[self.broadcastManager setRecordingStatus:GSBroadcastStatusRunning];
            break;
        default:
            [self.broadcastManager setRecordingStatus:GSBroadcastStatusRunning];
            break;
    }
}

-(void)handleCamera:(UIButton*)btn{
    long s = btn.tag;
    if(s==1){
        [self.broadcastManager inactivateCamera];
        btn.tag=0;
        [btn setBackgroundImage:[UIImage imageNamed:@"camera0.png"] forState:UIControlStateNormal];
    }else{
        [self.broadcastManager activateCamera];
        btn.tag=1;
        [btn setBackgroundImage:[UIImage imageNamed:@"camera.png"] forState:UIControlStateNormal];
    }
}

-(void)handleMicrophone:(UIButton*)btn{
    long s = btn.tag;
    if(s==1){
        [self.broadcastManager inactivateMicrophone];
        btn.tag=0;
        [btn setBackgroundImage:[UIImage imageNamed:@"mic0.png"] forState:UIControlStateNormal];
    }else{
        [self.broadcastManager activateMicrophone];
        btn.tag=1;
        [btn setBackgroundImage:[UIImage imageNamed:@"mic1.png"] forState:UIControlStateNormal];
    }
}

-(void)handleSetCameraFrontOrBehind:(UIButton*)btn{
    long s = btn.tag;
    if(s==1){
        [self.broadcastManager switchToBackCamera:YES landScape:YES];
        btn.tag=0;
    }else{
        [self.broadcastManager switchToBackCamera:NO landScape:YES];
        btn.tag=1;
    }
}

-(void)handVoice:(UIButton*)btn{
    long s = btn.tag;
    if(s==1){
        [self.broadcastManager inactivateSpeaker];
        btn.tag=0;
        [btn setImage:[UIImage imageNamed:@"speaker_off.png"] forState:UIControlStateNormal];
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setActive:NO error:nil];
    }else{
        
        [self.broadcastManager activateSpeaker];
        btn.tag=1;
        [btn setImage:[UIImage imageNamed:@"speaker_on.png"] forState:UIControlStateNormal];
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker
                                        error:nil];
        [audioSession setActive:YES error:nil];
        
    }
}

-(void)btnsShow{
    [self.view bringSubviewToFront:_btnClose];
    [self.view bringSubviewToFront:_btnCamera];
    [self.view bringSubviewToFront:_btnMicrophone];
    [self.view bringSubviewToFront:_btnShare];
    [self.view bringSubviewToFront:_btnSetCameraFrontOrBehind];
    [self.view bringSubviewToFront:_btnVoice];
}
-(void)btnsHide{
    [self.view sendSubviewToBack:_btnClose];
    [self.view sendSubviewToBack:_btnCamera];
    [self.view sendSubviewToBack:_btnMicrophone];
    [self.view sendSubviewToBack:_btnShare];
    [self.view sendSubviewToBack:_btnSetCameraFrontOrBehind];
    [self.view sendSubviewToBack:_btnVoice];
}

- (void)back:(id)sender
{
    [self.broadcastManager leaveAndShouldTerminateBroadcast:NO];
    [self.broadcastManager invalidate];
    [self.broadcastManager setStatus:GSBroadcastStatusPause];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
#pragma mark -页面设置

-(BOOL)shouldAutorotate{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeRight;
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationLandscapeRight;
}


//设置后台运行
- (void)enterBackground
{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [session setActive:YES error:nil];
}
#pragma mark -手势识别
//手势识别
- (void)handleVideoViewTap:(UITapGestureRecognizer*)recognizer
{
    //    if(statusTapScreen)
    //    {
    //        [self btnsHide];
    //        statusTapScreen=false;
    //    }else{
    //        [self btnsShow];
    //        statusTapScreen=true;
    //    }
    [self btnsHide];
    statusTapScreen=false;
}

- (void)handleDocViewTap:(UITapGestureRecognizer*)recognizer
{
    self.btnSwitchDoc.tag=0;
    [self.docTable setHidden:YES];
}

//
-(void)handleDocViewSwipe:(UISwipeGestureRecognizer*)recognizer
{
    if(recognizer.direction ==UISwipeGestureRecognizerDirectionLeft)
    {
        unsigned int p =_globalPageID-1;
        [self.broadcastManager publishDocGotoPage:self.globaldocument.docID pageId:p sync2other:YES];
        NSLog(@"左滑动");
    }
    if(recognizer.direction ==UISwipeGestureRecognizerDirectionRight)
    {
        unsigned int p =_globalPageID+1;
        [self.broadcastManager publishDocGotoPage:self.globaldocument.docID pageId:p sync2other:YES];
        NSLog(@"右滑动");
    }
}

- (void)handleVideoViewSwipe:(UISwipeGestureRecognizer*)recognizer
{
    [self btnsHide];
}

#pragma mark -展示互动相关

/**
 *  索取直播设置信息代理
 *
 *  @param manager 触发此代理的GSBroadcastManager对象
 *  @param key     键
 *  @param value   值
 *  @see  GSBroadcastManager
 */
- (void)broadcastManager:(GSBroadcastManager*)manager querySettingsInfoKey:(NSString*)key numberValue:(int*)value{
    NSLog(@"broadcastManager");
    if([key isEqualToString:@"save.video.width"]){
        *value = 352;
    }else if([key isEqualToString:@"save.video.height"]){
        *value = 288;
    }
}

- (void)broadcastManager:(GSBroadcastManager *)manager didSetupCustomBitRate:(VTCompressionSessionRef)session{
    NSLog(@"didSetupCustomBitRate");
}

- (void)broadcastManager:(GSBroadcastManager *)manager didSetStatus:(GSBroadcastStatus)status{
    switch (status) {
        case GSBroadcastStatusRunning:
            NSLog(@"1");
            [self.btnPlay setTitle:@"直播中" forState:UIControlStateNormal];
            [self.btnPlay setBackgroundColor:[UIColor redColor]];
            [self.btnPlay.layer setBorderWidth:0];
            self.btnPlay.layer.borderColor=[UIColor whiteColor].CGColor;
            self.btnPlay.tag =1;
            break;
        case GSBroadcastStatusStop:
            NSLog(@"2");
            [self.btnPlay setTitle:@"直播停止" forState:UIControlStateNormal];
            [self.btnPlay setBackgroundColor:[UIColor colorWithWhite:0.03f alpha:0.03f]];
            [self.btnPlay.layer setBorderWidth:1];
            self.btnPlay.layer.borderColor=[UIColor whiteColor].CGColor;
            self.btnPlay.tag =2;
            break;
        case GSBroadcastStatusPause:
            NSLog(@"3");
            [self.btnPlay setTitle:@"直播暂停" forState:UIControlStateNormal];
            [self.btnPlay setBackgroundColor:[UIColor colorWithWhite:0.03f alpha:0.03f]];
            [self.btnPlay.layer setBorderWidth:1];
            self.btnPlay.layer.borderColor=[UIColor whiteColor].CGColor;
            self.btnPlay.tag =3;
            break;
        default:
            break;
    }
}
- (void)broadcastManager:(GSBroadcastManager*)manager didSetRecordingStatus:(GSBroadcastStatus)status{
    switch (status) {
        case GSBroadcastStatusRunning:
            NSLog(@"1");
            [self.btnRecording setTitle:@"录制中" forState:UIControlStateNormal];
            [self.btnRecording setBackgroundColor:[UIColor redColor]];
            [self.btnPlay.layer setBorderWidth:0];
            self.btnPlay.layer.borderColor=[UIColor whiteColor].CGColor;
            self.btnRecording.tag =1;
            break;
        case GSBroadcastStatusStop:
            NSLog(@"2");
            [self.btnRecording setTitle:@"录制停止" forState:UIControlStateNormal];
            [self.btnRecording setBackgroundColor:[UIColor colorWithWhite:0.03f alpha:0.03f]];
            [self.btnPlay.layer setBorderWidth:1];
            self.btnPlay.layer.borderColor=[UIColor whiteColor].CGColor;
            self.btnRecording.tag =2;
            break;
        case GSBroadcastStatusPause:
            NSLog(@"3");
            [self.btnRecording setTitle:@"录制暂停" forState:UIControlStateNormal];
            [self.btnRecording setBackgroundColor:[UIColor colorWithWhite:0.03f alpha:0.03f]];
            [self.btnPlay.layer setBorderWidth:1];
            self.btnPlay.layer.borderColor=[UIColor whiteColor].CGColor;
            self.btnRecording.tag =3;
            break;
        default:
            break;
    }
}

- (void)initBroadCastManager
{
    self.broadcastManager = [GSBroadcastManager sharedBroadcastManager];
    self.broadcastManager.broadcastDelegate = self;
    self.broadcastManager.videoDelegate = self;
    self.broadcastManager.desktopShareDelegate = self;
    self.broadcastManager.investigationDelegate = self;
    self.broadcastManager.documentView = self.videoViewDoc;
    self.broadcastManager.documentDelegate = self;
    self.broadcastManager.qaDelegate=self;
    
    self.broadcastManager.videoRotateFlag=YES;
    
    if (![_broadcastManager connectBroadcastWithConnectInfo:self.connectInfo]) {
        
        [self.progressHUD show:NO];
        //        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"WrongConnectInfo", @"参数不正确") delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"知道了") otherButtonTitles:nil, nil];
        //        [alertView show];
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"发生错误，请重试"
                                                                       message:@""
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  [self dismissViewControllerAnimated:YES completion:^{
                                                                      //NSLog(@"dismissViewControllerAnimated成功");
                                                                  }];
                                                              }];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
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
//- (IBAction)receive:(UIButton *)sender {
//    [self.broadcastManager displayVideo:self.userID];
//
//}

// 直播初始化代理
- (void)broadcastManager:(GSBroadcastManager*)manager didReceiveBroadcastConnectResult:(GSBroadcastConnectResult)result
{
    switch (result) {
        case GSBroadcastConnectResultSuccess:
            
            // 直播初始化成功，加入直播
            if (![self.broadcastManager join]) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
                // Configure for text only and offset down
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"连接直播失败";
                hud.margin = 10.f;
                hud.removeFromSuperViewOnHide = YES;
            }
            else{
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
                // Configure for text only and offset down
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"正在加入房间...";
                hud.margin = 10.f;
                hud.removeFromSuperViewOnHide = YES;
                
                [hud hide:YES afterDelay:10];
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
            //            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:  NSLocalizedString(@"BroadcastConnectionError",  @"直播连接失败提示") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",  @"确认") otherButtonTitles:nil, nil];
            //            [alertView show];
            
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"发生错误，请重试"
                                                                           message:@""
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {
                                                                      [self dismissViewControllerAnimated:YES completion:^{
                                                                          //NSLog(@"dismissViewControllerAnimated成功");
                                                                      }];
                                                                  }];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
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
    
    if(joinResult == GSBroadcastJoinResultHostExist)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"直播组织者已经存在，无法进入";
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        
        
        [self.progressHUD hide:YES];
        [self.view bringSubviewToFront:_toolBar];
    }
    
    //[self.broadcastManager setStatus:GSBroadcastStatusRunning];
    // 服务器重启导致重连
    if (rebooted) {
        // 相应处理
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"连接中。。。";
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        
        [hud hide:YES afterDelay:3];
        
        [self.progressHUD hide:YES];
    }
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.manager =  self.broadcastManager;
}

// 断线重连
- (void)broadcastManagerWillStartRoomReconnect:(GSBroadcastManager*)manager
{
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


// 文档模块连接代理
- (void)broadcastManager:(GSBroadcastManager*)manager didReceiveDocModuleInitResult:(BOOL)result
{
}

// 文档打开代理
- (void)broadcastManager:(GSBroadcastManager *)manager didOpenDocument:(GSDocument *)doc
{
    bool isexist = false;
    
    for(int i=0;i<_docArr.count;i++)
    {
        unsigned docID = [[_docArr[i] valueForKey:@"docID"] unsignedIntValue];
        if(docID==doc.docID)
        {
            isexist =true;
            break;
        }
    }
    
    if(!isexist)
    {
        [_docArr addObject:doc];
        [self.docTable reloadData];
    }
    self.globaldocument = doc;
    [self.broadcastManager publishDocGotoPage:doc.docID pageId:0 sync2other:YES];
}

// 文档关闭代理
- (void)broadcastManager:(GSBroadcastManager *)manager didCloseDocument:(unsigned int)docID
{
    //int a= 1;
    for (int i = 0; i < _docArr.count; i++) {
        
        //处理数组中数据
        if(docID==[[_docArr[i] valueForKey:@"docID"] intValue])
        {
            [_docArr removeObjectAtIndex:i];
        }
        
    }
    [self.docTable reloadData];
}

// 文档切换代理
- (void)broadcastManager:(GSBroadcastManager *)manager didSlideToPage:(unsigned int)pageID ofDoc:(unsigned int)docID step:(int)step
{
    _globalPageID = pageID;
}

// 问答模块连接代理
- (void)broadcastManager:(GSBroadcastManager*)broadcastManager didReceiveQaModuleInitResult:(BOOL)result
{
    
}

// 问答设置状态改变代理
- (void)broadcastManager:(GSBroadcastManager*)broadcastManager didSetQaEnabled:(BOOL)enabled QuestionAutoDispatch:(BOOL)autoDispatch QuestionAutoPublish:(BOOL)autoPublish
{
    
}

// 问题的状态改变代理，包括收到一个新问题，问题被发布，取消发布等
- (void)broadcastManager:(GSBroadcastManager*)broadcastManager question:(GSQuestion*)question updatesOnStatus:(GSQaStatus)status
{
    switch (status) {
        case GSQaStatusNewAnswer:
        {
            if ([self.questionArray containsObject:question.questionID]) {
                
                [self.questionsDic setObject:question forKey:question.questionID];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.questionTable reloadData];
                [self.btnQuestion setImage:[UIImage imageNamed:@"chat_new.png"] forState:UIControlStateNormal];
            });
        }
            
            break;
            
        case GSQaStatusQuestionPublish:
        {
            [self.questionsDic setObject:question forKey:question.questionID];
            
            if (![_questionArray containsObject:question.questionID]) {
                
                [_questionArray addObject:question.questionID];
                
            }
            
            //通知主线程刷新
            dispatch_async(dispatch_get_main_queue(), ^{
                //回调或者说是通知主线程刷新，
                [self.questionTable reloadData];
                self.btnQuestion.tag =1;
                [self.btnQuestion setImage:[UIImage imageNamed:@"chat_new.png"] forState:UIControlStateNormal];
            });
        }
            break;
            
            
        case GSQaStatusQuestionCancelPublish:
        {
            [self.questionsDic removeObjectForKey:question.questionID];
            if ([self.questionArray containsObject:question.questionID]) {
                NSUInteger index = [self.questionArray indexOfObject:question.questionID];
                [self.questionArray removeObjectAtIndex:index];
            }
        }
            
            break;
            
        case GSQaStatusNewQuestion:
        {
            [self.questionsDic setObject:question forKey:question.questionID];
            if (![_questionArray containsObject:question.questionID]) {
                [_questionArray addObject:question.questionID];
            }
            
            //通知主线程刷新
            dispatch_async(dispatch_get_main_queue(), ^{
                //回调或者说是通知主线程刷新，
                [self.questionTable reloadData];
                self.btnQuestion.tag =1;
            });
        }
            break;
        default:
            break;
    }
}
//收到一路视频
- (void)broadcastManager:(GSBroadcastManager*)manager didUserJoinVideo:(GSUserInfo *)userInfo
{
    //3
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"收到视频成功";
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:3];
    if(userInfo.isOrganizer==YES)
    {
        [self.broadcastManager displayVideo:userInfo.userID];
        [self.broadcastManager setVideo:userInfo.userID active:YES];
    }
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
    
    //    if(userInfo.userID ==self.userID)
    //    {
    //        NSString *uid = [NSString stringWithFormat:@"%lld",userInfo.userID];
    //        if([_membersArr containsObject:uid])
    //        {
    //            [_membersDic setObject:userInfo forKey:uid];
    //        }
    //        [self synchronousMemberSelfStatus:uid];
    //    }
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
    [_videoViewOnline renderVideoFrame:videoFrame];
    //6
}

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
    //本地照相机视频流
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
    int a = self.view.frame.size.height-5-105;
    _originalVideoFrame = CGRectMake(5,a, 140, 105);//4:3
    self.videoView = [[GSVideoView alloc]initWithFrame:_originalVideoFrame];
    
    
    _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.broadcastManager.avsession];
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill; // 设置预览时的视频缩放方式
    [[_previewLayer connection] setVideoOrientation:AVCaptureVideoOrientationLandscapeRight]; // 设置视频的朝向
    
    _previewLayer.frame = _originalVideoFrame;
    
    
    [self.view.layer addSublayer:_previewLayer];
    [self.view bringSubviewToFront:_toolBar];
}

// 音频模块连接代理
- (void)broadcastManager:(GSBroadcastManager*)manager didReceiveAudioModuleInitResult:(BOOL)result
{
    if (!result) {
        NSLog(@"音频加载失败");
    }
}

/**
 *  其他用户加入房间代理
 *
 *  @param manager  触发此代理的GSBroadcastManager对象
 *  @param userInfo 用户信息
 *  @see GSBroadcastManager
 *  @see GSUserInfo
 */
- (void)broadcastManager:(GSBroadcastManager*)manager didReceiveOtherUser:(GSUserInfo*)userInfo
{
    //    bool isexist = false;
    //
    //        for(int i=0;i<_membersArr.count;i++)
    //        {
    //            LONGLONG uid = [[_membersArr[i] valueForKey:@"userID"] longLongValue];
    //            if(uid==userInfo.userID)
    //            {
    //                isexist =true;
    //                break;
    //            }
    //        }
    //
    //    if(!isexist)
    //    {
    //        [_membersArr addObject:userInfo];
    //    }
    //
    //    _labelCount.text =[NSString stringWithFormat:@"%lu人在线",(unsigned long)[_membersArr count]];
    
    NSString *uid =[NSString stringWithFormat:@"%lld",userInfo.userID];
    [self.membersDic setObject:userInfo forKey: uid];
    
    if (![_membersArr containsObject:uid]) {
        
        [_membersArr addObject:uid];
        _labelCount.text =[NSString stringWithFormat:@"%lu人在线",(unsigned long)[_membersArr count]];
        [self.membersTable reloadData];
        
        GSUserInfo *myinfo = [self.broadcastManager queryMyUserInfo];
        if(userInfo.userID== myinfo.userID)
        {
            [self synchronousMemberSelfStatus:uid];
        }
    }
    
}


/**
 *  其他用户离开房间
 *
 *  @param manager 触发此代理的GSBroadcastManager对象
 *  @param userID  离开直播的用户ID
 *  @see GSBroadcastManager
 */
- (void)broadcastManager:(GSBroadcastManager*)manager didLoseOtherUser:(long long)userID
{
    NSString *uid =[NSString stringWithFormat:@"%lld",userID];
    if([_membersArr containsObject:uid])
    {
        [_membersArr removeObject:uid];
        [_membersDic removeObjectForKey:uid];
        _labelCount.text =[NSString stringWithFormat:@"%lu人在线",(unsigned long)[_membersArr count]];
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            //回调或者说是通知主线程刷新，
            [self.membersTable reloadData];
        });
    }
    
}
- (void)broadcastManager:(GSBroadcastManager*)manager didUpdateUserInfo:(GSUserInfo*)userInfo updateFlag:(GSUserInfoUpdate)flag
{
    NSLog(@"updateuser");
    NSString *uid =[NSString stringWithFormat:@"%lld",userInfo.userID];
    if([_membersArr containsObject:uid])
    {
        [self.membersDic setObject:userInfo forKey:uid];
        
        GSUserInfo *myinfo= [self.broadcastManager queryMyUserInfo];
        
        if(myinfo)
        {
            if(userInfo.userID==myinfo.userID)
            {
                //通知主线程刷新
                dispatch_async(dispatch_get_main_queue(), ^{
                    //回调或者说是通知主线程刷新，
                    [self synchronousMemberSelfStatus:uid];
                    [self.membersTable reloadData];
                });
            }
            else{
                //通知主线程刷新
                dispatch_async(dispatch_get_main_queue(), ^{
                    //回调或者说是通知主线程刷新，
                    [self.membersTable reloadData];
                });
            }
        }
        
    }
}

- (void)dealloc
{
    // 退出直播，但不结束直播, 若参数为YES,直播将同时结束
    [self.broadcastManager leaveAndShouldTerminateBroadcast:NO];
    // 释放资源
    [self.broadcastManager invalidate];
    
}

#pragma mark -
#pragma mark System Default Code

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
