//
//  AppDelegate.m
//  SeerseeJoin
//
//  Created by 赵云锋 on 16/9/5.
//  Copyright © 2016年 hawaii. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import "ShareManager.h"
#import "MemberCenterViewController.h"
@interface AppDelegate ()
@property (strong, nonatomic) UINavigationController *navController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self initSharePlatform];
    return YES;
}

- (void)initSharePlatform
{
#warning Replace the share platforms app key, secret and redirect uri to yours
    
    [[ShareManager sharedManager] initTencentQQWithAppKey:@"kQzoneKey" appSecret:@"kQzoneSecret"];
    [[ShareManager sharedManager] initWexinWithAppKey:@"wxd6f563fcf1c9dbd0" appSecret:@"0baac20781fa4207780d606bfb9caa8a"];
    [[ShareManager sharedManager] initWeiboWithAppKey:@"kWeiboAppKey" appSecret:@"kWeiboSecret" redirectUri:@"kWeiboRedirectUri"];
    [[ShareManager sharedManager] initTwitterWithAppKey:@"kTwitterAppKey" appSecret:@"kTwitterAppSecret" redirectUri:@"kTwitterRedirectUri"];
    [[ShareManager sharedManager] initFacebookWithAppKey:@"kFacebookAppKey" appSecret:@"kFacebookAppSecret" redirectUri:@"kFacebookRedirectUri"];
    [[ShareManager sharedManager] initInstagram];
    
    //The Platforms To Share
    //    NSArray *platforms = @[@(SMPlatformFacebookOAuth),@(SMPlatformTwitterOAuth),@(SMPlatformInstagram),@(SMPlatformWeiboOAuth),@(SMPlatformTencentQQ),@(SMPlatformWeixin)];
    //    [[ShareManager sharedManager] usePlatforms:platforms];
    
    //The Platforms To Share
    NSArray *platforms = @[@(SMPlatformWeixin)];
    [[ShareManager sharedManager] usePlatforms:platforms];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
