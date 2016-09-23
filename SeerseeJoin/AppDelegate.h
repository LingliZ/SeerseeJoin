//
//  AppDelegate.h
//  SeerseeJoin
//
//  Created by 赵云锋 on 16/9/5.
//  Copyright © 2016年 hawaii. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RtSDK/RtSDK.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property BOOL allowRotation;

@property (nonatomic, strong)GSBroadcastManager *manager;
@end

