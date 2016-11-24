//
//  VisitorLoginViewController.m
//  SeerseeJoin
//
//  Created by 赵云锋 on 2016/11/18.
//  Copyright © 2016年 hawaii. All rights reserved.
//

#import "VisitorLoginViewController.h"
#import <AFNetworking.h>
#import "UserDefaults.h"
@interface VisitorLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtNickname;

@end

@implementation VisitorLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnlogin:(UIButton *)sender {
    //上次的房间号
    //NSString *rid = @"10002";
    //NSString *rid =@"10074";
    //NSDictionary *info = self.nsmres[btn.tag];
    
    if(![self.txtNickname.text isEqualToString:@""])
    {
        NSString *rid =self.rid;
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
                     BaseItemViewController *controller = [board instantiateViewControllerWithIdentifier:@"BroadcastHYVisitorViewController"];
                     
                     GSConnectInfo *connectInfo = [GSConnectInfo new];
                     
                     connectInfo.domain = @"service.seersee.com";
                     connectInfo.serviceType = GSBroadcastServiceTypeWebcast;
                     connectInfo.loginName = @"admin@seersee.com";
                     connectInfo.loginPassword = @"tgc0428seersee";
                     connectInfo.roomNumber = roomNumber;
                     connectInfo.nickName = self.txtNickname.text;
                     connectInfo.watchPassword = panelistToken;
                     connectInfo.thirdToken = @"";
                     connectInfo.oldVersion = YES;
                     
                     [UserDefaults setRoomNumber:roomNumber];
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
    else{
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                       message:@"请输入昵称！"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
