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
#import "RecordingPlayViewController.h"
#import <NSString+Color.h>
@interface MemberCenterViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnLoginOut;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UIImageView *imageviewHeadimg;

@property (weak, nonatomic) IBOutlet UIView *v1;
@property (weak, nonatomic) IBOutlet UIView *v2;
@property (weak, nonatomic) IBOutlet UIView *v3;
@property (weak, nonatomic) IBOutlet UIView *v4;
@end

@implementation MemberCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *name =[UserDefaults nickname];
    self.labelName.text = name;
    
    NSURL *imageUrl = [NSURL URLWithString:[UserDefaults getHeadimg]];
    self.imageviewHeadimg.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
    
    self.v1.layer.borderWidth =1;
    self.v1.layer.borderColor = [UIColor colorWithRed:20/255.0 green:20/255.0 blue:20/255.0 alpha:0.5].CGColor;
    
    self.v2.layer.borderWidth =1;
    self.v2.layer.borderColor = [UIColor colorWithRed:20/255.0 green:20/255.0 blue:20/255.0 alpha:0.5].CGColor;
    
    self.v3.layer.borderWidth =1;
    self.v3.layer.borderColor = [UIColor colorWithRed:20/255.0 green:20/255.0 blue:20/255.0 alpha:0.5].CGColor;
    
    self.v4.layer.borderWidth =1;
    self.v4.layer.borderColor = [UIColor colorWithRed:20/255.0 green:20/255.0 blue:20/255.0 alpha:0.5].CGColor;
    [self initnav];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"我的";
}

-(void)initnav{
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,25,25)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"home.png"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(gotoPop) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem= leftItem;
    
    self.title = nil;
    [self.navigationController.navigationBar setBarTintColor:[@"#00CAFC" representedColor]];
    [self.btnLoginOut setBackgroundColor:[@"#00d4ff" representedColor]];
}

-(void)gotoPop{
    [self.navigationController popViewControllerAnimated:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)gotoClass:(UIButton *)sender {
    CourseTableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"CourseTablePXViewController"];
    
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
- (IBAction)gotoRecording:(UIButton *)sender {
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    RecordingPlayViewController *controller = [board instantiateViewControllerWithIdentifier:@"RecordingTableViewController"];
    [self.navigationController pushViewController:controller animated:YES];
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
