//
//  CourseTablePXViewController.h
//  SeerseeJoin
//
//  Created by 赵云锋 on 16/9/22.
//  Copyright © 2016年 hawaii. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseTablePXViewController : UITableViewController
@property (strong,nonatomic) NSMutableDictionary* parameter;
@property (strong, nonatomic)NSString *domain;
@property (strong, nonatomic)NSString *serviceType;
@property (strong, nonatomic)NSString *loginName;
@property (strong, nonatomic)NSString *loginPassword;
@property (strong, nonatomic)NSString *webcastID;
@property (strong, nonatomic)NSString *roomNumber;
@property (strong, nonatomic)NSString *nickName;
@property (strong, nonatomic)NSString *watchPassword;
@property (strong, nonatomic) NSString *token;
@end
