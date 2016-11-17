//
//  testViewController.m
//  SeerseeJoin
//
//  Created by 赵云锋 on 16/10/8.
//  Copyright © 2016年 hawaii. All rights reserved.
//

#import "testViewController.h"
#import "KeyboardToolBar.h"

@interface testViewController ()

@property (weak, nonatomic) IBOutlet UITextField *txtcontent;
@property (weak, nonatomic) IBOutlet UITextView *uitextContent;

@property (weak, nonatomic) IBOutlet UIButton *b1;
@property (weak, nonatomic) IBOutlet UIButton *b2;
@property (weak, nonatomic) IBOutlet UIButton *b3;
@property (weak, nonatomic) IBOutlet UIButton *b4;

@end

@implementation testViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.b1 setBackgroundImage:[UIImage imageNamed:@"chat.png"] forState:UIControlStateNormal];
    [self.b2 setBackgroundImage:[UIImage imageNamed:@"chat_new.png"] forState:UIControlStateNormal];
    
    [self.b3 setImage:[UIImage imageNamed:@"chat.png"] forState:UIControlStateNormal];
    [self.b4 setImage:[UIImage imageNamed:@"chat_new.png"] forState:UIControlStateNormal];
}




- (IBAction)btnc:(UIButton *)sender {
        char* ptr = (char*)-1;
        *ptr = 10;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
