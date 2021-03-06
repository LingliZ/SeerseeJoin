//
//  LoginViewController.m
//  iOSDemo
//
//  Created by 赵云锋 on 16/8/3.
//  Copyright © 2016年 gensee. All rights reserved.
//

#import "LoginViewController.h"
#import "UserDefaults.h"
#import <CommonCrypto/CommonDigest.h>
#import "AFNetworking.h"
#import "MemberCenterViewController.h"
#import <NSString+Color.h>
#import "CourseTablePXViewController.h"
#import "CourseTableHYViewController.h"
@interface LoginViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *loginName;

@property (weak, nonatomic) IBOutlet UITextField *password;

@property (weak, nonatomic) IBOutlet UITextField *domain;

@property (strong, nonatomic)NSArray *textFields;

@property (strong, nonatomic)NSDictionary *keyboadUserInfo;

@property (strong, nonatomic)UITextField *activatedTextField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@property (weak, nonatomic) IBOutlet UIButton *btnLogin;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    
    [self.btnLogin.layer setMasksToBounds:YES];
    [self.btnLogin.layer setCornerRadius:5.0];
    [self.btnLogin addTarget:self action:@selector(loginIn) forControlEvents:UIControlEventTouchUpInside];
    
    double version = [[UIDevice currentDevice].systemVersion doubleValue];//判定系统版本。
    if (version < 7.0) {
        self.topConstraint.constant -= 64;
    }
    [self setup];
    [self addNotifications];
    [self initnav];
    
    
//    //判断是否已经登陆
//    if([UserDefaults loginName].length>0&&[UserDefaults domain].length>0&&[UserDefaults loginPassword].length>0){
//        NSString *courseid=[self.parameter objectForKey:@"from"];
//        
//        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//        CourseTableViewController *controller = [board instantiateViewControllerWithIdentifier:courseid];
//        
//        controller.parameter = self.parameter;
//        controller.domain = [UserDefaults domain];
//        controller.loginName = [UserDefaults loginName];
//        controller.loginPassword = [UserDefaults loginPassword];
//        controller.nickName = [UserDefaults nickname];
//        
//        [self.navigationController pushViewController:controller animated:YES];
//        return;
//    }
}

- (IBAction)gotoPop:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initnav{
//    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,21.51,40)];
//    [leftButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
//    [leftButton addTarget:self action:@selector(gotoPop) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem*leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
//    self.navigationItem.leftBarButtonItem= leftItem;
//    
//    self.title = nil;
//    self.navigationController.navigationBar.barStyle = bar
//    [self.navigationController.navigationBar setBarTintColor:[@"#00d4ff" representedColor]];
}
-(void)gotoMemberCenter{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MemberCenterViewController *controller = [board instantiateViewControllerWithIdentifier:@"MemberCenterViewController"];
    [self.navigationController pushViewController:controller animated:true];
}
-(void)gotoPop{
    [self.navigationController popViewControllerAnimated:true];
}

- (void)viewWillAppear:(BOOL)animated {
    //接收到的参数
    NSLog(@"viewDidAppear():视图2,收到的参数:from=%@",[self.parameter objectForKey:@"from"]);
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;//用来隐藏；

}
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;//用来显示；
}

-(void)setup
{
    self.title = NSLocalizedString(@"Title", nil);
    
    self.loginName.text = [UserDefaults loginName];
    self.loginName.delegate = self;
    
    self.password.text = [UserDefaults loginPassword];
    self.password.delegate = self;
    
    self.textFields = @[_loginName, _password];
}

#pragma mark -
#pragma mark Notifications

- (void)addNotifications
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)removeNotifications
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)keyNotification:(NSNotification*)notification
{
    self.keyboadUserInfo = notification.userInfo;
    
    CGRect rect = [notification.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    [UIView animateWithDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey]floatValue] animations: ^{
        
        [UIView setAnimationCurve:[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] doubleValue]];
        
        
        CGRect frame = self.view.frame;
        CGFloat offY = _activatedTextField.frame.origin.y + _activatedTextField.frame.size.height - rect.origin.y;
        
        frame.origin.y = offY > 0 ? -offY - 5 : 0;
        
        self.view.frame = frame;
    }];
    
}

#pragma mark -
#pragma mark Actions

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(void)loginIn{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *URL = @"http://woojoin.com/home/api/user_login/";
    NSDictionary *param = @{@"username":self.loginName.text, @"password":[self getpwd:self.password.text]};
    [manager GET:URL parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSString *code = [responseObject objectForKey:@"code"];
             NSLog(@"登陆code");
             if([code intValue] ==0){
                 //登录成功
                 [UserDefaults setDomain:@"wujie"];
                 [UserDefaults setLoginName:self.loginName.text];
                 [UserDefaults setLoginPassword:self.password.text];
                 [UserDefaults setNickname:[[responseObject objectForKey:@"user"] objectForKey:@"nickname"]];
                 [UserDefaults setUserId:[[responseObject objectForKey:@"user"] objectForKey:@"id"]];
                 [UserDefaults setHeadimg:[[responseObject objectForKey:@"user"] objectForKey:@"headimg"]];
                 [UserDefaults setUserType:[[responseObject objectForKey:@"user"] objectForKey:@"usertype"]];
                 [UserDefaults save];
                 
                 NSString *courseid=[self.parameter objectForKey:@"from"];
                 
                 UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                 
                 if([courseid isEqualToString:@"CourseTablePXViewController"]){
                     CourseTablePXViewController *controller = [board instantiateViewControllerWithIdentifier:courseid];
                     controller.parameter = self.parameter;
                     controller.domain = @"wujie";
                     controller.loginName = self.loginName.text;
                     controller.loginPassword = self.password.text;
                     controller.nickName = [[responseObject objectForKey:@"user"] objectForKey:@"nickname"];
                     
                     [self.navigationController pushViewController:controller animated:YES];
                 }else if([courseid isEqualToString:@"CourseTableHYViewController"]){
                     CourseTableHYViewController *controller = [board instantiateViewControllerWithIdentifier:courseid];
                     controller.parameter = self.parameter;
                     controller.domain = @"wujie";
                     controller.loginName = self.loginName.text;
                     controller.loginPassword = self.password.text;
                     controller.nickName = [[responseObject objectForKey:@"user"] objectForKey:@"nickname"];
                     
                     [self.navigationController pushViewController:controller animated:YES];
                 }
             }else{
                 //登录失败
                 UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"登陆失败", [@"用户名密码有误：" stringByAppendingString:errorcode]) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"知道了") otherButtonTitles:nil, nil];
                 [alertView show];
                 
             }
         }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             NSLog(@"%@",error);  //这里打印错误信息
             
         }];
}

#pragma mark -
#pragma mark - UITextFiledDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _activatedTextField = textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSUInteger currentIndex = [_textFields indexOfObject:textField];
    
    if (currentIndex != _textFields.count - 1) {
        [(UITextField*)_textFields[currentIndex]resignFirstResponder];
        [(UITextField*)_textFields[currentIndex + 1]becomeFirstResponder];
    }
    else
    {
        [self performSegueWithIdentifier:@"firstSegue" sender:self];
    }
    return YES;
}

#pragma mark -
#pragma mark System Default Code

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"sdfsd");
//        CourseTableViewController *destinationViewController = (CourseTableViewController*)segue.destinationViewController;
//        destinationViewController.domain = self.domain.text;
//        destinationViewController.loginName = self.loginName.text;
//        destinationViewController.loginPassword = self.password.text;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [self removeNotifications];
}

-(NSString*) getpwd:(NSString*)input
{
    NSString *a = [self sha1:input];
    NSString *b = [a stringByAppendingString:@"ThinkUCenter"];
    NSString *c = [self md5:b];
    return c;
}

-(NSString*) sha1:(NSString*)input
{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
    
}
- (NSString *) md5:(NSString *) input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
    
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
