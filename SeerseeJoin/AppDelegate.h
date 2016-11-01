//
//  AppDelegate.h
//  SeerseeJoin
//
//  Created by 赵云锋 on 16/9/5.
//  Copyright © 2016年 hawaii. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RtSDK/RtSDK.h>
#import <VodSDK/VodSDK.h>

static NSString *appKey = @"4bb032402d7a7741822e25f8";
static NSString *channel = @"Publish channel";
static BOOL isProduction = FALSE;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property BOOL allowRotation;

@property (nonatomic, strong)GSBroadcastManager *manager;

@property (strong, nonatomic) VodPlayer *vodplayer;
@end

