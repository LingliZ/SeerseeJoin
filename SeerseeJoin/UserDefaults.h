//
//  UserDefaults.h
//  iOSDemo
//
//  Created by Gaojin Hsu on 3/16/15.
//  Copyright (c) 2015 gensee. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserDefaults : NSObject

+ (BOOL)save;

+ (void)setDomain:(NSString*)domain;
+ (NSString*)domain;

+ (void)setServiceType:(NSString*)serviceType;
+ (NSString*)serviceType;

+ (void)setWebcastID:(NSString*)webcastID;
+ (NSString*)webcastID;

+ (void)setRoomNumber:(NSString*)roomNumber;
+ (NSString*)roomNumber;

+ (void)setLoginName:(NSString*)loginName;
+ (NSString*)loginName;

+ (void)setLoginPassword:(NSString*)loginPassword;
+ (NSString*)loginPassword;

+ (void)setNickname:(NSString*)nickname;
+ (NSString*)nickname;

+ (void)setWatchPassword:(NSString*)watchPassword;
+ (NSString*)watchPassword;

+ (void)setSeerseeliveId:(NSString*)seerseeliveId;
+ (NSString*)seerseeliveId;

+ (void)setUserId:(NSString*)userId;
+ (NSString*)userId;

//10-20
+ (void)setOrganizerToken:(NSString*)organizerToken;
+ (NSString*)organizerToken;

+ (void)setPanelistToken:(NSString*)panelistToken;
+ (NSString*)panelistToken;

//10-24
+ (NSString *)getNumber;

+ (void)setNumber:(NSString*)roomNumber;

+ (NSString *)getVodPassword;

+ (void)setVodPassword:(NSString *)vodPassword;

+ (NSString *)getHeadimg;

+ (void)setHeadimg:(NSString *)headimg;
    
//usertype 11-24
+ (NSString *)getUserType;
    
+ (void)setUserType:(NSString *)usertype;
@end
