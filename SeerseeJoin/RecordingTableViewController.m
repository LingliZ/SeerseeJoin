//
//  RecordingTableViewController.m
//  SeerseeJoin
//
//  Created by 赵云锋 on 16/10/21.
//  Copyright © 2016年 hawaii. All rights reserved.
//

#import "RecordingTableViewController.h"
#import <NSString+Color.h>
#import "MemberCenterViewController.h"
#import <AFNetworking.h>
#import "AppConfig.h"
#import "UserDefaults.h"
#import "RecordingTableViewCell.h"
#import "RecordingPlayViewController.h"
#import "DownLoadViewController.h"
#import <MBProgressHUD.h>

@interface RecordingTableViewController ()<UITextFieldDelegate,VodDownLoadDelegate>
{
        BOOL islivePlay;
}
@property (strong, nonatomic)NSArray *nsmres;
@property (nonatomic, strong) VodDownLoader *voddownloader;
@property (nonatomic, strong) RecordingPlayViewController *liveViewController;
@property (nonatomic, strong) DownLoadViewController *downloadViewController;
@end

@implementation RecordingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self initnav];
    [self loadData];
    
    if (!_voddownloader) {
        _voddownloader = [[VodDownLoader alloc]init];
    }
    _voddownloader.delegate = self;
}

-(void)loadData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //http://[host]/home/api/user_vod_list
    NSString* URL = [NSString stringWithFormat:@"%@%@", [AppConfig websiteurl], @"home/api/user_vod_list"];
    NSString *uid = [UserDefaults userId];
    NSDictionary *param = @{@"uid":uid};
    [manager GET:URL parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             _nsmres = responseObject;
             [self.tableView reloadData];
         }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             NSLog(@"%@",error);  //这里打印错误信息
             
         }];
}

-(void)initnav{
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
    [rightButton setImage:[UIImage imageNamed:@"profile.png"]forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(gotoMemberCenter) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
    //[leftButton setTitle:@"▲" forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"home.png"]forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(gotoPop) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    UIBarButtonItem*leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    self.navigationItem.leftBarButtonItem= leftItem;
    //[UIBarButtonItem appearance]
    
    //标题
    [self.navigationItem setTitle:@"培训"];
    [self.navigationController.navigationBar setBarTintColor:[@"#00a2ff" representedColor]];
}

-(void)gotoMemberCenter{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MemberCenterViewController *controller = [board instantiateViewControllerWithIdentifier:@"MemberCenterViewController"];
    [self.navigationController pushViewController:controller animated:true];
}
-(void)gotoPop{
    [self.navigationController popViewControllerAnimated:true];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.nsmres.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    
    // Configure the cell...
    RecordingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecordingTableViewCell" forIndexPath:indexPath];
    
    if(self.nsmres!=nil&&self.nsmres!=NULL)
    {
        NSDictionary *info = self.nsmres[indexPath.row];
        NSString *rid =[info objectForKey:@"id"];
        cell.labelTitle.text = [info objectForKey:@"title"];
        
        
        //NSString *a = [self timetostr:[info objectForKey:@"start_time"]];
        NSString *str =[NSString stringWithFormat:@"%@  至  %@",[self timetostr:[info objectForKey:@"start_time"]] ,[self timetostr:[info objectForKey:@"end_time"]]];
        cell.labelDate.text = str;
        cell.btnPlay.tag=indexPath.row;
        [cell.btnPlay addTarget:self action:@selector(handPlay:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}

-(void)handPlay:(UIButton*)btn
{
    islivePlay = YES;
    //    存入输入的数据
//    [[NSUserDefaults standardUserDefaults] setDomain:@"service.seersee.com"];
//    [[NSUserDefaults standardUserDefaults] setServiceType:_serviceType.text];
//    [[NSUserDefaults standardUserDefaults] setNumber:_number.text];
//    [[NSUserDefaults standardUserDefaults] setVodPassword:_vodPassword.text];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    [UserDefaults setNumber:@"69850019"];
    [UserDefaults setVodPassword:@"8888"];
    [UserDefaults save];
    [_voddownloader addItem:@"service.seersee.com" number:@"69850019" loginName:nil vodPassword:@"8888" loginPassword:nil downFlag:0 serType:@"webcast" oldVersion:NO kToken:@""];
    
    
    
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    _liveViewController = [board instantiateViewControllerWithIdentifier:@"player"];
    //[self presentViewController:_liveViewController animated: YES completion:nil];
    //[self.navigationController pushViewController:_liveViewController animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

-(NSString*)timetostr:(NSString*)sjctime
{
    NSString *str=sjctime;
    NSTimeInterval time=[str doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //NSLog(@"date:%@",[detaildate description]);
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *date =[formatter stringFromDate:detaildate];
    return date;
}

#pragma mark - VodDownLoadDelegate
//添加item的回调方法
- (void)onAddItemResult:(RESULT_TYPE)resultType voditem:(downItem *)item
{
    if (resultType == RESULT_SUCCESS) {
        //        vodId = item.strDownloadID;
        if (islivePlay) {
            [_liveViewController setItem:item];
            [_liveViewController setIsLivePlay:YES];
            [self.navigationController pushViewController:_liveViewController animated:YES];
        } else {
//            [_downloadViewController setDomain:_domain.text];
//            [_downloadViewController setNumber:_number.text];
//            [_downloadViewController setVodPassword:_vodPassword.text];
//            [_downloadViewController setSeviceType:_serviceType.text];
            
            [self.navigationController pushViewController:_downloadViewController animated:YES];
        }
        
        //        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }else if (resultType == RESULT_ROOM_NUMBER_UNEXIST){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"点播间不存在" ,@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"知道了",@"") otherButtonTitles:nil, nil];
        [alertView show];
    }else if (resultType == RESULT_FAILED_NET_REQUIRED){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"网络请求失败" ,@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"知道了",@"") otherButtonTitles:nil, nil];
        [alertView show];
    }else if (resultType == RESULT_FAIL_LOGIN){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"用户名或密码错误" ,@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"知道了",@"") otherButtonTitles:nil, nil];
        [alertView show];
    }else if (resultType == RESULT_NOT_EXSITE){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"该点播的编号的点播不存在" ,@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"知道了",@"") otherButtonTitles:nil, nil];
        [alertView show];
    }else if (resultType == RESULT_INVALID_ADDRESS){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"无效地址" ,@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"知道了",@"") otherButtonTitles:nil, nil];
        [alertView show];
    }else if (resultType == RESULT_UNSURPORT_MOBILE){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"不支持移动设备" ,@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"知道了",@"") otherButtonTitles:nil, nil];
        [alertView show];
    }else if (resultType == RESULT_FAIL_TOKEN){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"口令错误" ,@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"知道了",@"") otherButtonTitles:nil, nil];
        [alertView show];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    //    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

#pragma mark - UITextFieldDelgate
/**
 *处理键盘遮盖
 */
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 216.0);
    
    if(offset > 0) {
        NSTimeInterval animationDuration = 0.30f;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        
        //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    int offset = self.view.frame.origin.y;
    if (offset < 0) {
        NSTimeInterval animationDuration = 0.30f;
        [UIView beginAnimations:@"ResizeforKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        
        //将视图的Y坐标向下移动offset个单位，以使下面腾出地方用于软键盘的显示
        self.view.frame = CGRectMake(0.0f, 0.0, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
}

#pragma mark Actions
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
