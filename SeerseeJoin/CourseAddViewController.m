//
//  CourseAddViewController.m
//  SeerseeJoin
//
//  Created by 赵云锋 on 16/9/23.
//  Copyright © 2016年 hawaii. All rights reserved.
//

#import "CourseAddViewController.h"
#import "AFNetworking.h"
#import "AppConfig.h"
#import "UserDefaults.h"
#import "KeyboardToolBar.h"
#import <NSString+Color.h>
#import "MemberCenterViewController.h"
@interface CourseAddViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnChoiceImage;
@property (strong, nonatomic) IBOutlet UIImageView *choiceimage;
//@property (strong, nonatomic) IBOutlet UIView *openImage;
@property (strong, nonatomic) NSData *imgdata;
@property (strong, nonatomic) NSData *imgpath;

@property (weak, nonatomic) IBOutlet UITextField *txtTitle;
@property (weak, nonatomic) IBOutlet UITextField *txtDate;
@property (weak, nonatomic) IBOutlet UITextField *txtInfo;
@property (strong, nonatomic) IBOutlet UIDatePicker *date;
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;

@end

@implementation CourseAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"新增课程";
    [self.navigationController.navigationBar setTitleTextAttributes:  @{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self initnav];
    [self initDate];
    [self.btnAdd setBackgroundColor:[@"#00d4ff" representedColor]];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Add:(UIButton *)sender {
    [self uploadImg];
}


- (void)selectImageGR:UIGestureRecognizer{
    UIImagePickerController *myPicker = [[UIImagePickerController alloc]init];
    
    //创建源类型
    UIImagePickerControllerSourceType mySourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    myPicker.sourceType = mySourceType;
    
    //设置代理
    myPicker.delegate = self;
    //设置可编辑
    myPicker.allowsEditing = YES;
    //通过模态的方式推出系统相册
    [self presentViewController:myPicker animated:YES completion:^{
        NSLog(@"进入相册");
    }];
}
- (IBAction)selectImage:(UIButton *)sender {
    UIImagePickerController *myPicker = [[UIImagePickerController alloc]init];
    
    //创建源类型
    UIImagePickerControllerSourceType mySourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    myPicker.sourceType = mySourceType;
    
    //设置代理
    myPicker.delegate = self;
    //设置可编辑
    myPicker.allowsEditing = YES;
    //通过模态的方式推出系统相册
    [self presentViewController:myPicker animated:YES completion:^{
        NSLog(@"进入相册");
    }];
}
- (void)uploadImg{
    /*
     此段代码如果需要修改，可以调整的位置
     1. 把upload.php改成网站开发人员告知的地址
     2. 把file改成网站开发人员告知的字段名
     */
    
    //AFN3.0+基于封住HTPPSession的句柄
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *dict = @{@"username":@"Saup"};
    
    //formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
    //NSString*url =[AppConfig websiteurl];
    NSString* url = [NSString stringWithFormat:@"%@%@", [AppConfig websiteurl], @"home/api/upload_image"];
    [manager POST:url parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        //UIImage *image =[UIImage imageNamed:@"moon"];
        NSData *data = self.imgdata;
        
        
        // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
        // 要解决此问题，
        // 可以在上传时使用当前的系统事件作为文件名
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        
        //上传
        /*
         此方法参数
         1. 要上传的[二进制数据]
         2. 对应网站上[upload.php中]处理文件的[字段"file"]
         3. 要保存在服务器上的[文件名]
         4. 上传文件的[mimeType]
         */
        [formData appendPartWithFileData:data name:@"download" fileName:fileName mimeType:@"image/png"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        //上传进度
        // @property int64_t totalUnitCount;     需要下载文件的总大小
        // @property int64_t completedUnitCount; 当前已经下载的大小
        //
        // 给Progress添加监听 KVO
        NSLog(@"%f",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        // 回到主队列刷新UI,用户自定义的进度条
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.progressView.progress = 1.0 *
//            uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
//        });
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"上传成功 %@", responseObject);
        //NSLog(@"上传成功 %@", [responseObject objectForKey:@"path"]);
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData* jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
        
        //NSString *a = [dic objectForKey:@"path"];
        _imgpath =[dic objectForKey:@"path"];
        [self AddCourse];
        NSLog(@"上传成功 %@", str);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"上传失败 %@", error);
    }];
}

#pragma mark -- 实现imagePicker的代理方法

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
//    //取得所选取的图片,原大小,可编辑等，info是选取的图片的信息字典
//    UIImage *selectImage = [info objectForKey:UIImagePickerControllerEditedImage];
//    NSData *data = UIImagePNGRepresentation(selectImage);//获取图片数据
//    //设置图片进相框
//    self.choiceimage.image = selectImage;
//    [self.btnChoiceImage  setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
//    self.imgdata=UIImagePNGRepresentation(selectImage);//获取图片数据
//    
//    [picker dismissViewControllerAnimated:YES completion:^{
//        NSLog(@"模态返回") ;
//    }];
    
    
    //11-28
    //取得所选取的图片,原大小,可编辑等，info是选取的图片的信息字典
    UIImage *selectImage = [info objectForKey:UIImagePickerControllerEditedImage];
    selectImage = [self compressImage:selectImage toTargetWidth:640];
    
    //设置图片进相框
    self.imgdata=UIImageJPEGRepresentation(selectImage, 1.0);//获取图片数据
    
    self.choiceimage.image = [UIImage imageWithData:self.imgdata];
    [self.btnChoiceImage  setBackgroundImage:[UIImage imageWithData:self.imgdata] forState:UIControlStateNormal];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        NSLog(@"模态返回") ;
    }];
}

- (UIImage *)compressImage:(UIImage *)sourceImage toTargetWidth:(CGFloat)targetWidth {
    CGSize imageSize = sourceImage.size;
    
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetHeight = (targetWidth / width) * height;
    
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, targetWidth, targetHeight)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
        NSLog(@"取消") ;
    }];
}

- (void)AddCourse {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString* url = [NSString stringWithFormat:@"%@%@", [AppConfig websiteurl], @"home/api/add_course"];
    NSDictionary *param = @{@"uid":[UserDefaults userId],@"title":self.txtTitle.text, @"start_time":self.txtDate.text, @"cover":self.imgpath,@"organizer_token":@"666666",@"panelist_token":@"888888"};
    [manager GET:url parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSString *code = [responseObject objectForKey:@"code"];
             NSLog(@"登陆code");
             if([code intValue] ==0){
                 //NSString *courseid=[self.parameter objectForKey:@"from"];
                 
//                 UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//                 CourseTableViewController *controller = [board instantiateViewControllerWithIdentifier:courseid];
//                 controller.parameter = self.parameter;
//                 controller.domain = self.domain.text;
//                 controller.loginName = self.loginName.text;
//                 controller.loginPassword = self.password.text;
//                 controller.nickName = [[responseObject objectForKey:@"user"] objectForKey:@"nickname"];
//                 
//                 [self.navigationController pushViewController:controller animated:YES];
                 
                 //ListViewController *valueView = [self.storyboard instantiateViewControllerWithIdentifier:@"CourseTableView"];
                 //[self presentViewController:controller animated:YES completion:nil];
             }else{
                 //登录失败
                 //NSString *errorcode = [responseObject objectForKey:@"code"];
                 UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"WrongConnectInfo", [@"用户名密码有误：" stringByAppendingString:errorcode]) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"知道了") otherButtonTitles:nil, nil];
                 [alertView show];
                 
             }
         }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             NSLog(@"%@",error);  //这里打印错误信息
         }];
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
