//
//  ChoiceCenterViewController.m
//  SeerseeJoin
//
//  Created by 赵云锋 on 16/9/19.
//  Copyright © 2016年 hawaii. All rights reserved.
//

#import "ChoiceCenterViewController.h"
#import "LoginViewController.h"
#import "MemberCenterViewController.h"
#import <AFNetworking.h>
#import "AppConfig.h"
#import "UserDefaults.h"
#import "CourseTableHYViewController.h"
#import "CourseTablePXViewController.h"

@interface ChoiceCenterViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnHY;
@property (weak, nonatomic) IBOutlet UIButton *btnPX;
@end

@implementation ChoiceCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initParameter];
    [self checkUpdate];
      UIDeviceOrientation orientaiton = [[UIDevice currentDevice] orientation];

    NSLog(@"%ld",(long)orientaiton);
}

- (void)initParameter{
    self.parameter = [[NSMutableDictionary alloc]init];
}

-(void)checkUpdate{
    //http://[host]/home/api/app_download_info
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //NSString *URL = @"http://[host]/home/api/app_download_info";
    NSString* url = [NSString stringWithFormat:@"%@%@", [AppConfig websiteurl], @"home/api/app_download_info"];
    NSDictionary *param = @{@"type":@"ios"};
    [manager GET:url parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

             NSObject *ios = [responseObject objectForKey:@"ios"];
             
             NSString *version = [ios valueForKey:@"version"];
             NSString *url = [ios valueForKey:@"url"];
             NSLog(@"%@", url);
             NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
             NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
             float vmy =[app_Version floatValue];
             float vonline =[version floatValue];
             if(vonline>vmy)
             {
                 NSLog(@"版本已过期");
             }
         }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             NSLog(@"%@",error);  //这里打印错误信息
             
         }];
}



- (void)viewWillAppear:(BOOL)animated {
    [self.btnHY addTarget:self action:@selector(gotoHY) forControlEvents:UIControlEventTouchUpInside];
    [self.btnPX addTarget:self action:@selector(gotoPX) forControlEvents:UIControlEventTouchUpInside];
    self.navigationController.navigationBarHidden = YES;//用来隐藏；
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;//用来显示；
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
-(void)gotoHY{
    //判断是否已经登陆
    if([UserDefaults loginName].length>0&&[UserDefaults domain].length>0&&[UserDefaults loginPassword].length>0){
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        CourseTableHYViewController *controller = [board instantiateViewControllerWithIdentifier:@"CourseTableHYViewController"];
        [self.parameter setObject:@"CourseTableHYViewController" forKey:@"from"];
        controller.parameter = self.parameter;
        controller.domain = [UserDefaults domain];
        controller.loginName = [UserDefaults loginName];
        controller.loginPassword = [UserDefaults loginPassword];
        controller.nickName = [UserDefaults nickname];
        
        [self.navigationController pushViewController:controller animated:YES];
        return;
    }
    
    [self.parameter setObject:@"CourseTableHYViewController" forKey:@"from"];
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    LoginViewController *controller = [board instantiateViewControllerWithIdentifier:@"LoginViewController"];
    controller.parameter = self.parameter;
    [self.navigationController pushViewController:controller animated:true];
}

-(void)gotoPX{
    //判断是否已经登陆
    if([UserDefaults loginName].length>0&&[UserDefaults domain].length>0&&[UserDefaults loginPassword].length>0){
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        CourseTablePXViewController *controller = [board instantiateViewControllerWithIdentifier:@"CourseTablePXViewController"];
        [self.parameter setObject:@"CourseTablePXViewController" forKey:@"from"];
        controller.parameter = self.parameter;
        controller.domain = [UserDefaults domain];
        controller.loginName = [UserDefaults loginName];
        controller.loginPassword = [UserDefaults loginPassword];
        controller.nickName = [UserDefaults nickname];
        
        [self.navigationController pushViewController:controller animated:YES];
        return;
    }
    
    
    [self.parameter setObject:@"CourseTablePXViewController" forKey:@"from"];
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    LoginViewController *controller = [board instantiateViewControllerWithIdentifier:@"LoginViewController"];
    controller.parameter = self.parameter;
    [self.navigationController pushViewController:controller animated:true];
}

-(BOOL)shouldAutorotate{
    return YES;
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
