//
//  CourseEditViewController.m
//  SeerseeJoin
//
//  Created by 赵云锋 on 16/9/21.
//  Copyright © 2016年 hawaii. All rights reserved.
//

#import "CourseEditViewController.h"
#import "AFNetworking.h"
#import "AppConfig.h"
#import <NSString+Color.h>
#import "KeyboardToolBar.h"
#import "MemberCenterViewController.h"
@interface CourseEditViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageviewCover;
@property (weak, nonatomic) IBOutlet UITextField *txtTitle;
@property (weak, nonatomic) IBOutlet UITextField *txtDate;
@property (weak, nonatomic) IBOutlet UITextField *txtInfo;


@property (weak, nonatomic) NSString *imgcover;
@property (strong, nonatomic) IBOutlet UIDatePicker *date;
@property (weak, nonatomic) IBOutlet UIButton *btnEdit;
@end

@implementation CourseEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"编辑课程";
    [self.navigationController.navigationBar setTitleTextAttributes:  @{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.btnEdit setBackgroundColor:[@"#00d4ff" representedColor]];
    [self initData];
    [self initnav];
    [self initDate];
    [KeyboardToolBar registerKeyboardToolBarWithTextField:self.txtTitle];
    [KeyboardToolBar registerKeyboardToolBarWithTextField:self.txtInfo];
}
-(void)initDate
{
    int x = arc4random() % 100;
    //1
    //添加一个时间选择器
    _date=[[UIDatePicker alloc]init];
    /**
     *  设置只显示中文
     */
    [_date setLocale:[NSLocale localeWithLocaleIdentifier:@"zh-CN"]];
    /**
     *  设置只显示日期
     */
    _date.datePickerMode=UIDatePickerModeDateAndTime;
    //    [self.view addSubview:date];
    
    //当光标移动到文本框的时候，召唤时间选择器
    self.txtDate.inputView=_date;
    
    //2
    //创建工具条
    UIToolbar *toolbar=[[UIToolbar alloc]init];
    //设置工具条的颜色
    toolbar.barTintColor=[UIColor brownColor];
    //设置工具条的frame
    toolbar.frame=CGRectMake(0, 0, 320, 44);
    
    //给工具条添加按钮
    //    UIBarButtonItem *item0=[[UIBarButtonItem alloc]initWithTitle:@"上一个" style:UIBarButtonItemStylePlain target:self action:@selector(click) ];
    //
    //    UIBarButtonItem *item1=[[UIBarButtonItem alloc]initWithTitle:@"下一个" style:UIBarButtonItemStylePlain target:self action:@selector(click)];
    //
    UIBarButtonItem *item2=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *item3=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishDate)];
    
    toolbar.items = @[item2, item3];
    //设置文本输入框键盘的辅助视图
    self.txtDate.inputAccessoryView=toolbar;
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
    //[UIBarButtonItem appearance]
    
    //标题
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

-(void)finishDate{
    NSDate *pickerDate = [self.date date];
    NSDateFormatter *pickerFormatter = [[NSDateFormatter alloc] init];// 创建一个日期格式器
    [pickerFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [pickerFormatter stringFromDate:pickerDate];
    self.txtDate.text = dateString;
    [self.txtDate resignFirstResponder];
}

-(void)initData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    NSString* url = [NSString stringWithFormat:@"%@%@", [AppConfig websiteurl], @"home/api/get_livecast_config"];
    NSString *cid = self.cid;
    NSDictionary *param = @{@"id":cid};
    [manager GET:url parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSLog(@"sdf");
             NSString *id = [responseObject objectForKey:@"id"];
             NSString *title = [responseObject objectForKey:@"title"];
             _imgcover = [responseObject objectForKey:@"cover"];
             
             _txtTitle.text = title;
             _txtDate.text = [responseObject objectForKey:@"start_time"];
             UIImage * imageFromURL = [self getImageFromURL:_imgcover];
             _imageviewCover.image = imageFromURL;
         }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             NSLog(@"%@",error);  //这里打印错误信息
             
         }];
}

-(UIImage *) getImageFromURL:(NSString *)fileURL {
    NSLog(@"执行图片下载函数");
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    
    return result;
}
- (IBAction)btnEdit:(UIButton *)sender {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString* url = [NSString stringWithFormat:@"%@%@", [AppConfig websiteurl], @"home/api/update_course"];
    _imgcover=[_imgcover stringByReplacingOccurrencesOfString:[AppConfig websiteurl] withString:@"/"];
    
    NSDictionary *param = @{@"id":self.cid,@"title":self.txtTitle.text, @"start_time":_txtDate.text, @"cover":_imgcover};
    [manager GET:url parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSString *code = [responseObject objectForKey:@"code"];
             NSLog(@"登陆code");
             if([code intValue] ==0){
                 
             }else{
                 //登录失败
                 NSString *errorcode = [responseObject objectForKey:@"code"];
                 UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"WrongConnectInfo", [@"用户名密码有误：" stringByAppendingString:errorcode]) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"知道了") otherButtonTitles:nil, nil];
                 [alertView show];
                 
             }
         }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             NSLog(@"%@",error);  //这里打印错误信息
         }];
}

- (NSDate *)dateFromString:(NSString *)dateString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
 
    NSDate *destDate= [dateFormatter dateFromString:dateString];

    return destDate;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
