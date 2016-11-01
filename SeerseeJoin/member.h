//
//  member.h
//  SeerseeJoin
//
//  Created by 赵云锋 on 16/9/30.
//  Copyright © 2016年 hawaii. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface member : NSObject
{
    NSString *hasMicrophone;
    NSString *hasCamera;
    NSString *isMicrophoneOpen;
    NSString *isMicrophoneMute;
    NSString *isCameraOpen;
    NSString *isVideoActivated;
    NSString *isHandup;
    NSString *isChatForbidden;
    NSString *isOrganizer;
    NSString *isPresentor;
    NSString *isAttendee;
    NSString *userName;
    NSString *role;
    NSString *status;
    NSString *userType;
    NSString *userID;
}
@end
