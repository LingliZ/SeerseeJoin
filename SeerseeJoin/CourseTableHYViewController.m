//
//  CourseTableViewController.m
//  SeerseeJoin
//
//  Created by 赵云锋 on 16/9/7.
//  Copyright © 2016年 hawaii. All rights reserved.
//

#import "CourseTableHYViewController.h"
#import "CourseCellTableViewCell.h"
#import "AFNetworking.h"
#import "BaseItemViewController.h"
#import "UserDefaults.h"
#import "MemberCenterViewController.h"
#import <NSString+Color.h>
#import "CourseEditViewController.h"
#import "ShareManager.h"
#import "AppConfig.h"
@interface CourseTableHYViewController ()

@property (strong, nonatomic)NSArray *nsmres;
@property (strong, nonatomic) IBOutlet UITableView *pxtable;

@end

@implementation CourseTableHYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initnav];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)viewWillAppear:(BOOL)animated {
    //[self initnav];
    NSLog(@"viewDidAppear():视图2,收到的参数:from=%@",[self.parameter objectForKey:@"from"]);
    [super viewWillAppear:animated];
    
    self.title = @"会议";
    //[self inittoolbar];
    [self loadData];
}
- (void)viewWillDisappear:(BOOL)animated {
    
    NSLog(@"viewDidAppear():视图2,收到的参数:from=%@",[self.parameter objectForKey:@"from"]);
    [super viewWillDisappear:animated];
    [self.navigationController  setToolbarHidden:YES animated:YES];
}

//-(void)inittoolbar{
//    [self.navigationController  setToolbarHidden:NO animated:YES];
//    UIBarButtonItem *flexiableItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
//    
//    UIBarButtonItem *title = [[UIBarButtonItem alloc]initWithTitle:@"添加课程" style:UIBarButtonItemStylePlain target:self action:@selector(addCourse)];
//    
//    NSArray *items = [NSArray arrayWithObjects:flexiableItem,title, flexiableItem, nil];
//    
//    self.toolbarItems = items;
//    //self.toolbarItems.
//    
//    
//}

-(void)addCourse{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"CourseAddViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)initnav{
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
    [rightButton setImage:[UIImage imageNamed:@"profile.png"]forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(gotoMemberCenter) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
    [leftButton setImage:[UIImage imageNamed:@"home.png"]forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(gotoPop) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    UIBarButtonItem*leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    self.navigationItem.leftBarButtonItem= leftItem;
    
    //标题
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    if([[self.parameter objectForKey:@"from"] isEqualToString:@"CourseTableHYViewController"])
    {
        self.title = @"会议";
    }
    if([[self.parameter objectForKey:@"from"] isEqualToString:@"CourseTablePXViewController"])
    {
        self.title = @"上课";
    }

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
#pragma mark - Table view data source

-(void)loadData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *URL = @"http://www.woojoin.com/home/api/get_meeting_list/";
    NSString *uid = [UserDefaults userId];
    NSDictionary *param = @{@"uid":uid};
    [manager GET:URL parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             _nsmres = responseObject;
             [self.pxtable reloadData];
         }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             NSLog(@"%@",error);  //这里打印错误信息
             
         }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete implementation, return the number of rows
    return self.nsmres.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CourseCell" forIndexPath:indexPath];
    //cell.imagePhoto.image =[_nsmres[indexPath.row] objectForKey:@"cover"];
    if(self.nsmres!=nil&&self.nsmres!=NULL)
    {
        NSDictionary *info = self.nsmres[indexPath.row];
        //NSString *rid =[info objectForKey:@"id"];
        cell.titleLabel.text = [info objectForKey:@"title"];
        NSString *url =[info objectForKey:@"cover"];
        NSURL *imageUrl = [NSURL URLWithString:url];
        cell.imagePhoto.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
        
        cell.btnEdit.tag=indexPath.row;
        [cell.btnEdit addTarget:self action:@selector(handEdit:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.btnShare.tag = indexPath.row;
        [cell.btnShare addTarget:self action:@selector(handShare:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.btnAssistant.tag = indexPath.row;
        [cell.btnAssistant addTarget:self action:@selector(handAssistant:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.btnTeacher.tag = indexPath.row;
        [cell.btnTeacher addTarget:self action:@selector(handTeacher:) forControlEvents:UIControlEventTouchUpInside];
        
        int status =[[info objectForKey:@"status"] intValue];
        switch (status) {
            case -1:
                cell.labelStatus.text = @"已删除";
                cell.labelStatus.backgroundColor = [UIColor redColor];
                break;
            case 0:
                cell.labelStatus.text = @"未开始";
                cell.labelStatus.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
                break;
            case 1:
                cell.labelStatus.text = @"直播中";
                cell.labelStatus.backgroundColor = [UIColor redColor];
                break;
            case 2:
                cell.labelStatus.text = @"暂停";
                cell.labelStatus.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
                break;
            case 3:
                cell.labelStatus.text = @"已结束";
                cell.labelStatus.backgroundColor = [UIColor whiteColor];
                break;
            default:
                break;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //上次的房间号
    NSDictionary *info = self.nsmres[indexPath.row];
    NSString *rid =[info objectForKey:@"id"];
    //NSString *title =[info objectForKey:@"title"];
    if(rid.length>0)
    {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSString *URL = @"http://woojoin.com/home/api/get_livecast_config/";
        NSDictionary *param = @{@"id":rid};
        [manager GET:URL parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
            
        }
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 NSString *organizerToken = [responseObject objectForKey:@"organizer_token"];
                 NSString *panelistToken = [responseObject objectForKey:@"panelist_token"];
                 NSString *roomNumber = [responseObject objectForKey:@"webcast_number"];
                 
                 UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                 BaseItemViewController *controller = [board instantiateViewControllerWithIdentifier:@"BroadcastPXViewController"];
                 
                 GSConnectInfo *connectInfo = [GSConnectInfo new];
                 
                 connectInfo.domain = @"service.seersee.com";
                 connectInfo.serviceType = GSBroadcastServiceTypeWebcast;
                 connectInfo.loginName = @"admin@seersee.com";
                 connectInfo.loginPassword = @"tgc0428seersee";
                 connectInfo.roomNumber = roomNumber;
                 connectInfo.nickName = self.loginName;
                 connectInfo.watchPassword = organizerToken;
                 connectInfo.thirdToken = self.token;
                 connectInfo.oldVersion = YES;
                 
                 [UserDefaults setRoomNumber:self.roomNumber];
                 [UserDefaults setSeerseeliveId:rid];
                 [UserDefaults setOrganizerToken:organizerToken];
                 [UserDefaults setPanelistToken:panelistToken];
                 [UserDefaults save];
                 controller.connectInfo = connectInfo;
                 
                 [self.parameter setObject:[responseObject objectForKey:@"title"] forKey:@"castname"];
                 controller.parameter = self.parameter;
                 
                 [self presentViewController:controller animated: YES completion:nil];
             }
         
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
                 NSLog(@"%@",error);  //这里打印错误信息
                 
             }];
    }

}

-(void)handEdit:(UIButton*)btn{
    //NSLog(@"%@",btn.tag);
    NSDictionary *info = self.nsmres[btn.tag];
    NSString *rid =[info objectForKey:@"id"];
    
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    CourseEditViewController *controller = [board instantiateViewControllerWithIdentifier:@"CourseEditViewController"];
    controller.cid = rid;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)handShare:(UIButton*)btn{
    NSString *sTitle = @"无界互联"; //Only support QQ and Weixin
    NSString *sDesc = @"无界互联正在直播中";
    //NSString *sUrl = @"http://wujie.woojoin.com/10007.html";
    NSString *sid = [UserDefaults seerseeliveId];
    NSString *url = [AppConfig websiteurl2];
    NSString *sUrl  = [NSString stringWithFormat:@"%@m/%@%@", url,sid,@".html"];
    
    UIImage *image=[UIImage imageNamed:@"ic_launcher.png"];
    SMImage *sImage = [[SMImage alloc] initWithImage:image];
    [[ShareManager sharedManager] setContentWithTitle:sTitle description:sDesc image:sImage url:sUrl];
    [[ShareManager sharedManager] showShareWindow];
}

-(void)handAssistant:(UIButton*)btn
{
    //上次的房间号
    //NSString *rid = @"10002";
    //NSString *rid =@"10074";
    NSDictionary *info = self.nsmres[btn.tag];
    NSString *rid =[info objectForKey:@"id"];
    //NSString *title =[info objectForKey:@"title"];
    if(rid.length>0)
    {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSString *URL = @"http://woojoin.com/home/api/get_livecast_config/";
        NSDictionary *param = @{@"id":rid};
        [manager GET:URL parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
            
        }
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 NSString *organizerToken = [responseObject objectForKey:@"organizer_token"];
                 NSString *panelistToken = [responseObject objectForKey:@"panelist_token"];
                 NSString *roomNumber = [responseObject objectForKey:@"webcast_number"];
                 
                 UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                 BaseItemViewController *controller = [board instantiateViewControllerWithIdentifier:@"BroadcastPXViewController"];
                 
                 GSConnectInfo *connectInfo = [GSConnectInfo new];
                 
                 connectInfo.domain = @"service.seersee.com";
                 connectInfo.serviceType = GSBroadcastServiceTypeWebcast;
                 connectInfo.loginName = @"admin@seersee.com";
                 connectInfo.loginPassword = @"tgc0428seersee";
                 connectInfo.roomNumber = roomNumber;
                 connectInfo.nickName = self.loginName;
                 connectInfo.watchPassword = panelistToken;
                 connectInfo.thirdToken = self.token;
                 connectInfo.oldVersion = YES;
                 
                 [UserDefaults setRoomNumber:self.roomNumber];
                 [UserDefaults setSeerseeliveId:rid];
                 [UserDefaults setOrganizerToken:organizerToken];
                 [UserDefaults setPanelistToken:panelistToken];
                 [UserDefaults save];
                 controller.connectInfo = connectInfo;
                 
                 [self.parameter setObject:[responseObject objectForKey:@"title"] forKey:@"castname"];
                 controller.parameter = self.parameter;
                 
                 [self presentViewController:controller animated: YES completion:nil];
             }
         
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
                 NSLog(@"%@",error);  //这里打印错误信息
                 
             }];
    }
}

-(void)handTeacher:(UIButton*)btn
{
    //上次的房间号
    NSDictionary *info = self.nsmres[btn.tag];
    NSString *rid =[info objectForKey:@"id"];
    //NSString *title =[info objectForKey:@"title"];
    if(rid.length>0)
    {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSString *URL = @"http://woojoin.com/home/api/get_livecast_config/";
        NSDictionary *param = @{@"id":rid};
        [manager GET:URL parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
            
        }
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 NSString *organizerToken = [responseObject objectForKey:@"organizer_token"];
                 NSString *panelistToken = [responseObject objectForKey:@"panelist_token"];
                 NSString *roomNumber = [responseObject objectForKey:@"webcast_number"];
                 
                 UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                 BaseItemViewController *controller = [board instantiateViewControllerWithIdentifier:@"BroadcastPXViewController"];
                 
                 GSConnectInfo *connectInfo = [GSConnectInfo new];
                 
                 connectInfo.domain = @"service.seersee.com";
                 connectInfo.serviceType = GSBroadcastServiceTypeWebcast;
                 connectInfo.loginName = @"admin@seersee.com";
                 connectInfo.loginPassword = @"tgc0428seersee";
                 connectInfo.roomNumber = roomNumber;
                 connectInfo.nickName = self.loginName;
                 connectInfo.watchPassword = organizerToken;
                 connectInfo.thirdToken = self.token;
                 connectInfo.oldVersion = YES;
                 
                 [UserDefaults setRoomNumber:self.roomNumber];
                 [UserDefaults setSeerseeliveId:rid];
                 [UserDefaults setOrganizerToken:organizerToken];
                 [UserDefaults setPanelistToken:panelistToken];
                 [UserDefaults save];
                 controller.connectInfo = connectInfo;
                 
                 [self.parameter setObject:[responseObject objectForKey:@"title"] forKey:@"castname"];
                 controller.parameter = self.parameter;
                 
                 [self presentViewController:controller animated: YES completion:nil];
             }
         
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
                 NSLog(@"%@",error);  //这里打印错误信息
                 
             }];
    }
}

-(BOOL)shouldAutorotate{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}



/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
