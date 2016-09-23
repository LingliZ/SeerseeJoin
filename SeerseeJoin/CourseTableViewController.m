//
//  CourseTableViewController.m
//  SeerseeJoin
//
//  Created by 赵云锋 on 16/9/7.
//  Copyright © 2016年 hawaii. All rights reserved.
//

#import "CourseTableViewController.h"
#import "CourseCellTableViewCell.h"
#import "AFNetworking.h"
#import "BaseItemViewController.h"
#import "UserDefaults.h"
#import "MemberCenterViewController.h"
@interface CourseTableViewController ()

@property (strong, nonatomic)NSArray *nsmres;
@end

@implementation CourseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initnav];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self loadData];
}
- (void)viewWillAppear:(BOOL)animated {
    //[self initnav];
    NSLog(@"viewDidAppear():视图2,收到的参数:from=%@",[self.parameter objectForKey:@"from"]);
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    
    NSLog(@"viewDidAppear():视图2,收到的参数:from=%@",[self.parameter objectForKey:@"from"]);
    [super viewWillDisappear:animated];
}

-(void)initnav{
    //    UIBarButtonItem *baright=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"profile.png"] style:UIBarButtonItemStylePlain target:self action:@selector(gotoMemberCenter)];
    //
    //    self.navigationItem.rightBarButtonItem=baright;
    
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
    [rightButton setImage:[UIImage imageNamed:@"profile.png"]forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(gotoMemberCenter) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
    [leftButton setTitle:@"▲" forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(gotoPop) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    UIBarButtonItem*leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    self.navigationItem.leftBarButtonItem= leftItem;
    //[UIBarButtonItem appearance]
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor blueColor]];
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
    NSString *URL = @"http://www.woojoin.com/home/api/get_course_list/";
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
        NSString *rid =[info objectForKey:@"id"];
        cell.titleLabel.text = [info objectForKey:@"title"];
        NSString *url =[info objectForKey:@"cover"];
        NSURL *imageUrl = [NSURL URLWithString:url];
        cell.imagePhoto.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
        
        cell.btnEdit.tag=rid;
        [cell.btnEdit addTarget:self action:@selector(handEdit:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}

-(void)handEdit:(UIButton*)btn{
    NSLog(@"%@",btn.tag);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //上次的房间号
    //NSString *rid = @"10002";
    //NSString *rid =@"10074";
    NSDictionary *info = self.nsmres[indexPath.row];
    NSString *rid =[info objectForKey:@"id"];
    NSString *title =[info objectForKey:@"title"];
    if(rid.length>0)
    {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSString *URL = @"http://woojoin.com/home/api/get_livecast_config/";
        NSDictionary *param = @{@"id":rid};
        [manager GET:URL parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
            
        }
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 NSString *organizerToken = [responseObject objectForKey:@"organizer_token"];
                 NSString *roomNumber = [responseObject objectForKey:@"webcast_number"];
                 
                 //                 UIStoryboard *board = [UIStoryboard storyboardWithName:@"Seersee" bundle:[NSBundle mainBundle]];
                 //BaseItemViewController *controller = [board instantiateViewControllerWithIdentifier:@"BroadcastViewController"];
                 NSString *para = [self.parameter objectForKey:@"from"];
                 NSString *identifier;
                 if([para isEqualToString:@"gotoHY"])
                 {
                     identifier =@"BroadcastHYViewController";
                 }else if([para isEqualToString:@"gotoPX"]){
                     identifier =@"BroadcastPXViewController";
                 }
                 
                 BaseItemViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
                 
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
                 [UserDefaults save];
                 controller.connectInfo = connectInfo;
                 [self presentViewController:controller animated: YES completion:nil];
             }
         
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
                 NSLog(@"%@",error);  //这里打印错误信息
                 
             }];
    }
    
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
