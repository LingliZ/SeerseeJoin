//
//  AppConfig.m
//  SeerseeJoin
//
//  Created by 赵云锋 on 16/9/23.
//  Copyright © 2016年 hawaii. All rights reserved.
//

#import "AppConfig.h"
static NSString *kwebsiteurl = @"http://www.woojoin.com/";
static NSString *kwebsiteurl2 = @"http://wujie.woojoin.com/";
@implementation AppConfig
+(NSString*)websiteurl{
    return kwebsiteurl;
}
+(NSString*)websiteurl2{
    return kwebsiteurl2;
}
@end
