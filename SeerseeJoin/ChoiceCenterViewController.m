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
@interface ChoiceCenterViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnHY;
@property (weak, nonatomic) IBOutlet UIButton *btnPX;
@end

@implementation ChoiceCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initParameter];
    //[self initnav];
    // Do any additional setup after loading the view.
//    NSLog(self.domain);
//    NSLog(self.nickName);
}

- (void)initParameter{
    self.parameter = [[NSMutableDictionary alloc]init];
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
    [self.parameter setObject:@"CourseTableHYViewController" forKey:@"from"];
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    LoginViewController *controller = [board instantiateViewControllerWithIdentifier:@"LoginViewController"];
    controller.parameter = self.parameter;
    //[self presentViewController:controller animated:YES completion:nil];
    [self.navigationController pushViewController:controller animated:true];
}

-(void)gotoPX{
    [self.parameter setObject:@"CourseTablePXViewController" forKey:@"from"];
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    LoginViewController *controller = [board instantiateViewControllerWithIdentifier:@"LoginViewController"];
    controller.parameter = self.parameter;
    //[self presentViewController:controller animated:YES completion:nil];
    [self.navigationController pushViewController:controller animated:true];
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
