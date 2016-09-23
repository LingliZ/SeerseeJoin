//
//  MemberCenterViewController.m
//  SeerseeJoin
//
//  Created by 赵云锋 on 16/9/20.
//  Copyright © 2016年 hawaii. All rights reserved.
//

#import "MemberCenterViewController.h"
#import "UserDefaults.h"
#import "CourseTableViewController.h"
#import "ChoiceCenterViewController.h"
@interface MemberCenterViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnLoginOut;

@property (weak, nonatomic) IBOutlet UILabel *labelName;

@end

@implementation MemberCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *name =[UserDefaults nickname];
    self.labelName.text = name;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)gotoClass:(UIButton *)sender {
    CourseTableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"CourseTableViewController"];
    
    [self presentViewController:controller animated: YES completion:nil];
    
}


- (IBAction)loginOut:(UIButton *)sender {
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"警告"
                                                    message:@"确定要注销您的身份吗？"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSInteger a = buttonIndex;
    if(a==1){
        [UserDefaults setDomain:nil];
        [UserDefaults setLoginName:nil];
        [UserDefaults setLoginPassword:nil];
        [UserDefaults setNickname:nil];
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        ChoiceCenterViewController *controller = [board instantiateViewControllerWithIdentifier:@"ChoiceCenterViewController"];
        
        [self.navigationController pushViewController:controller animated:YES];

    }
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
