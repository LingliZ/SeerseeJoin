//
//  UserDefaults.m
//  iOSDemo
//
//  Created by Gaojin Hsu on 3/16/15.
//  Copyright (c) 2015 gensee. All rights reserved.
//

#import "UserDefaults.h"


static NSString *kDomain = @"domain";
static NSString *kServiceType = @"webcast";
static NSString *kWebcastID = @"webcastID";
static NSString *kRoomNumber = @"roomNumber";
static NSString *kLoginName = @"loginName";
static NSString *kLoginPassword = @"loginPassword";
static NSString *kNickname = @"nickname";
static NSString *kWatchPassword = @"watchPassword";
static NSString *kOrganizerToken = @"organizerToken";
static NSString *kseerseeliveId = @"seerseeliveId";
static NSString *kuserId = @"0";
@implementation UserDefaults

+ (BOOL)save
{
    return [[NSUserDefaults standardUserDefaults]synchronize];
}

+ (void)setDomain:(NSString*)domain
{
    [[NSUserDefaults standardUserDefaults]setObject:domain forKey:kDomain];
}

+ (NSString*)domain
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:kDomain];
}

+ (void)setServiceType:(NSString*)serviceType
{
    [[NSUserDefaults standardUserDefaults]setObject:serviceType forKey:kServiceType];
}

+ (NSString*)serviceType
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:kServiceType];
}

+ (void)setWebcastID:(NSString*)webcastID
{
    [[NSUserDefaults standardUserDefaults]setObject:webcastID forKey:kWebcastID];
}

+ (NSString*)webcastID
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:kWebcastID];
}

+ (void)setRoomNumber:(NSString*)roomNumber
{
    [[NSUserDefaults standardUserDefaults]setObject:roomNumber forKey:kRoomNumber];
}

+ (NSString*)roomNumber
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:kRoomNumber];
}

+ (void)setLoginName:(NSString*)loginName
{
    [[NSUserDefaults standardUserDefaults]setObject:loginName forKey:kLoginName];
}

+ (NSString*)loginName
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:kLoginName];
}

+ (void)setLoginPassword:(NSString*)loginPassword
{
    [[NSUserDefaults standardUserDefaults]setObject:loginPassword forKey:kLoginPassword];
}

+ (NSString*)loginPassword
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:kLoginPassword];
}

+ (void)setNickname:(NSString*)nickname
{
    [[NSUserDefaults standardUserDefaults]setObject:nickname forKey:kNickname];
}

+ (NSString*)nickname
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:kNickname];
}

+ (void)setWatchPassword:(NSString*)watchPassword
{
    [[NSUserDefaults standardUserDefaults]setObject:watchPassword forKey:kWatchPassword];
}

+ (NSString*)watchPassword
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:kWatchPassword];
}

+ (NSString*)organizerToken
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:kWatchPassword];
}

+ (NSString*)seerseeliveId
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:kseerseeliveId];
}
+ (void)setSeerseeliveId:(NSString*)seerseeliveId
{
    [[NSUserDefaults standardUserDefaults]setObject:seerseeliveId forKey:kseerseeliveId];
}

+ (void)setUserId:(NSString *)userId
{
    [[NSUserDefaults standardUserDefaults]setObject:userId forKey:kuserId];
}

+ (NSString*)userId
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:kuserId];
}
@end