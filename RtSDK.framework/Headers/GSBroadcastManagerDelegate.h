//
//  GSBroadcastManagerDelegate.h
//  RtSDK
//
//  Created by Gaojin Hsu on 3/11/15.
//  Copyright (c) 2015 Geensee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSUserInfo.h"
#import "GSVideoFrame.h"
#import "GSChatMessage.h"
#import "GSQuestion.h"
#import "GSInvestigation.h"
#import "GSDocPage.h"
#import "GSLodItem.h"
#import "GSGrabInfo.h"
#import <VideoToolbox/VideoToolbox.h>

/**
 *  加入直播结果
 */
typedef NS_ENUM(NSInteger, GSBroadcastJoinResult) {
    /**
     *  直播加入成功
     */
    GSBroadcastJoinResultSuccess,
    
    /**
     *  未知错误
     */
    GSBroadcastJoinResultUnknownError,
    
    /**
     *  直播已上锁
     */
    GSBroadcastJoinResultLocked,
    
    /**
     *  直播组织者已经存在
     */
    GSBroadcastJoinResultHostExist,
    
    /**
     *  直播成员人数已满
     */
    GSBroadcastJoinResultMembersFull,
    
    /**
     *  音频编码不匹配
     */
    GSBroadcastJoinResultAudioCodecUnmatch,
    
    /**
     *  加入直播超时
     */
    GSBroadcastJoinResultTimeout,
    
    /**
     *  ip被ban
     */
    GSBroadcastJoinResultIPBanned,
    
    /**
     *  组织者还没有入会，你加入时机太早
     */
    GSBroadcastJoinResultTooEarly,
    
};

/**
 *  离开直播的原因
 */
typedef NS_ENUM(NSInteger, GSBroadcastLeaveReason) {
    
    /**
     *  自行退出房间
     */
    GSBroadcastLeaveReasonNormal,
    
    /**
     *  被踢出房间
     */
    GSBroadcastLeaveReasonEjected,
    
    /**
     *  超时
     */
    GSBroadcastLeaveReasonTimeout,
    
    /**
     *  房间关闭，直播结束
     */
    GSBroadcastLeaveReasonClosed,
    
    /**
     *  ip 被ban
     */
    GSBroadcastLeaveReasonIPBanned,
};


/**
 *  直播（录制）状态
 */
typedef NS_ENUM(NSInteger, GSBroadcastStatus) {
    
    /**
     *  直播正在运行中
     */
    GSBroadcastStatusRunning = 1,
    
    /**
     *  直播已停止
     */
    GSBroadcastStatusStop,
    
    /**
     *  直播暂停
     */
    GSBroadcastStatusPause,
};


/**
 *  用户信息更新的字段
 */
typedef NS_ENUM(NSInteger, GSUserInfoUpdate) {
    
    /**
     *  除了下列情况的其他状态发生改变
     */
    GSUserInfoUpdateOthers,
    
    /**
     *  用户角色发生改变
     */
    GSUserInfoUpdateRole,
    
    /**
     *  用户权限发生改变，多数情况下用角色来替代，不同角色对应不同权限
     */
    GSUserInfoUpdatePermission,
    
    /**
     *  用户的状态发生改变，比如用户音频设备打开或关闭，视频设备打开或关闭
     */
    GSUserInfoUpdateStatus,
    
    /**
     *  用户在用户列表里的排名次序发生改变
     */
    GSUserInfoUpdateRank,
};


/**
 *  直播连接结果
 */
typedef NS_ENUM(NSUInteger, GSBroadcastConnectResult) {
    
    /**
     *  直播初始化成功
     */
    GSBroadcastConnectResultSuccess,
    
    /**
     *  网络错误
     */
    GSBroadcastConnectResultNetworkError,
    
    /**
     *  找不到对应的webcastID，可能情况：roomNumber, domain填写有误，找不到对应的直播,调用AccessInfo接口产生的错误
     */
    GSBroadcastConnectResultWebcastIDNotFound,
    
    /**
     *  webcastID 错误， 找不到对应的直播初始化参数, 调用LoginInfo接口产生的错误
     */
    GSBroadcastConnectResultWebcastIDInvalid,
    
    /**
     *  登录信息错误， 调用LoginInfo接口产生的错误
     */
    GSBroadcastConnectResultLoginFailed,
    
    /**
     *  加会口令错误, 调用LoginInfo接口产生的错误
     */
    GSBroadcastConnectResultJoinCastPasswordError,
    
    /**
     *  其他错误，域名，角色拼接错误, 调用LoginInfo接口产生的错误
     */
    GSBroadcastConnectResultRoleOrDomainError,
    
    /**
     *  加会参数都正确，但是初始化失败
     */
    GSBroadcastConnectResultInitFailed,
    
    /**
     *  未知错误
     */
    GSBroadcastConnectResultUnknownError,
    
    
    GSBroadcastConnectResultNeedWatchPassword,
    
    GSBroadcastConnectResultNoNeedWatchPassword,
    
    GSBroadcastConnectResultFetchRoomNumberError,
    
    GSBroadcastConnectResultNeedLogin,
    
    GSBroadcastConnectResultNeedThirdPartValidate,
    
    GSBroadcastConnectResultDomainError,
    
    GSBroadcastConnectResultThirdTokenError,
};


/**
 *  发生改变的问答状态
 */
typedef NS_ENUM(NSInteger, GSQaStatus) {
    /**
     *  收到一个新问题
     */
    GSQaStatusNewQuestion,
    
    /**
     *  问题收到回答
     */
    GSQaStatusNewAnswer,
    
    /**
     *  问题发布
     */
    GSQaStatusQuestionPublish,
    
    /**
     *  问题取消发布
     */
    GSQaStatusQuestionCancelPublish,
    
    /**
     *  推送给嘉宾
     */
    GSQaStatusQuestionPush,
    
    /**
     *  指定组织者，主讲人或嘉宾回答问题
     */
    GSQaStatusQuestionAssgin,
    
    /**
     *  这个问题被建议用语音回复
     */
    GSQaStatusQuestionVoiceReply,
    
    /**
     *  正在使用语音回复
     */
    GSQaStatusQuestionVoiceReplying,
    
    /**
     *  正在使用文字回复
     */
    GSQaStatusQuestionTextReplying,
    
};

/**
 *  抽奖的类型
 */
typedef NS_ENUM(NSInteger, GSLotteryActionType) {
    
    /**
     *  开始抽奖
     */
    GSLotteryActionTypeBegin = 0x01,
    
    /**
     *  抽奖结束
     */
    GSLotteryActionTypeEnd = 0x02,
    
    /**
     *  抽奖取消
     */
    GSLotteryActionTypeCancel = 0x03,
};



/**
 *  红包创建结果
 */
typedef NS_ENUM(NSInteger, GSHongbaoCreateResult){
    /**
     *  成功
     */
    GSHongbaoCreateResultSuccess = 0x00,
    /**
     *  系统错误
     */
    GSHongbaoCreateResultSystemError = 10001,
    /**
     *  会议不存在或者未开启红包功能
     */
    GSHongbaoCreateResultHongbaoFunctionError = 10102,
    /**
     *  会议红包余额不足
     */
    GSHongbaoCreateResultMoneyNotEnough = 10103,
    /**
     *  红包ID已存在
     */
    GSHongbaoCreateResultHongbaoIDExist = 10108,
    /**
     *  超过会议红包上限
     */
    GSHongbaoCreateResultMeetingHongbaoLimitError = 10109,
    /**
     *  红包份数超过上限
     */
    GSHongbaoCreateResultHongbaoCountLimitError = 10110,
};



/**
 *  抢红包结果
 */
typedef NS_ENUM(NSInteger, GSHongbaoGrabResult){
    /**
     *  成功
     */
    GSHongbaoGrabResultSuccess = 0x00,
    /**
     *  重复争抢
     */
    GSHongbaoCreateResultGrabDuplicate = 10104,
    /**
     *  红包已空
     */
    GSHongbaoCreateResultHongbaoEmpty = 10105,
    /**
     *  红包超时
     */
    GSHongbaoCreateResultHongbaoTimedout = 10106,
    /**
     *  定向红包，不允许争抢
     */
    GSHongbaoCreateResultHongbaoNotAllowed = 10107,
};



@class GSBroadcastManager;


/**
 *  直播代理，回调直播信息数据
 */
@protocol GSBroadcastDelegate <NSObject>

@required

/**
 * 直播连接代理
 *
 * @param manager 触发此代理的GSBroadcastManager对象
 *
 * @param connectResult 枚举值，表示直播连接结果
 *
 * @see GSBroadcastManager
 *
 * @see GSBroadcastConnectResult
 *
 */
- (void)broadcastManager:(GSBroadcastManager*)manager didReceiveBroadcastConnectResult:(GSBroadcastConnectResult)connectResult;


@optional

/**
 * 加入直播代理
 *
 * @param manager 触发此代理的GSBroadcastManager对象
 *
 * @param joinResult 枚举值，表示加入直播结果
 *
 * @param selfUserID 自己的用户ID
 *
 * @param rebooted rebooted为YES，表示这次连接行为的产生是由于根服务器重启而导致的重连
 *
 * @see GSBroadcastManager
 *
 * @see GSBroadcastConnectResult
 *
 */
- (void)broadcastManager:(GSBroadcastManager*)manager didReceiveBroadcastJoinResult:(GSBroadcastJoinResult)joinResult selfUserID:(long long)userID rootSeverRebooted:(BOOL)rebooted;


/**
 * 自己离开直播代理
 *
 * @param manager 触发此代理的GSBroadcastManager对象
 *
 * @param leaveReason 枚举值，表示离开直播的原因
 *
 * @see GSBroadcastManager
 *
 * @see GSBroadcastLeaveReason
 *
 */
- (void)broadcastManager:(GSBroadcastManager*)manager didSelfLeaveBroadcastFor:(GSBroadcastLeaveReason)leaveReason;


/**
 * 直播重连代理
 *
 * @param manager 触发此代理的GSBroadcastManager对象
 *
 * @see GSBroadcastManager
 *
 */
- (void)broadcastManagerWillStartReconnect:(GSBroadcastManager*)manager;


/**
 * 锁住/解锁 房间代理
 *
 * @param manager 触发此代理的GSBroadcastManager对象
 *
 * @param locked 若值为YES，则房间被锁住，若值为NO，房间被解锁
 *
 * @see GSBroadcastManager
 *
 */
- (void)broadcastManager:(GSBroadcastManager*)manager didSetLocked:(BOOL)locked;


/**
 * 直播状态改变代理
 *
 * @param manager 触发此代理的GSBroadcastManager对象
 *
 * @param status 枚举值表示状态
 *
 * @see GSBroadcastManager
 *
 */
- (void)broadcastManager:(GSBroadcastManager*)manager didSetStatus:(GSBroadcastStatus)status;


/**
 *  房间开启录音代理
 *
 *  @param manager 触发此代理的GSBroadcastManager对象
 *  @param status  枚举值表示状态
 *  @see GSBroadcastManager
 *  @see GSBroadcastStatus
 */
- (void)broadcastManager:(GSBroadcastManager*)manager didSetRecordingStatus:(GSBroadcastStatus)status;


/**
 *  获取房间信息代理
 *
 *  @param manager 触发此代理的GSBroadcastManager对象
 *  @param key     键
 *  @param value   值
 *  @see GSBroadcastManager
 */
- (void)broadcastManager:(GSBroadcastManager*)manager didReceiveBroadcastInfoKey:(NSString*)key value:(long long)value;


/**
 *  其他用户加入房间代理
 *
 *  @param manager  触发此代理的GSBroadcastManager对象
 *  @param userInfo 用户信息
 *  @see GSBroadcastManager
 *  @see GSUserInfo
 */
- (void)broadcastManager:(GSBroadcastManager*)manager didReceiveOtherUser:(GSUserInfo*)userInfo;


/**
 *  其他用户离开房间
 *
 *  @param manager 触发此代理的GSBroadcastManager对象
 *  @param userID  离开直播的用户ID
 *  @see GSBroadcastManager
 */
- (void)broadcastManager:(GSBroadcastManager*)manager didLoseOtherUser:(long long)userID;


/**
 *  用户信息更新代理
 *
 *  @param manager  触发此代理的GSBroadcastManager对象
 *  @param userInfo 更新后的用户信息
 *  @param flag     枚举值表示用户更新的字段
 *  @see GSBroadcastManager
 *  @see GSUserInfo
 *  @see GSUserInfoUpdate
 */
- (void)broadcastManager:(GSBroadcastManager*)manager didUpdateUserInfo:(GSUserInfo*)userInfo updateFlag:(GSUserInfoUpdate)flag;


/**
 *  广播消息代理
 *
 *  @param manager 触发此代理的GSBroadcastManager对象
 *  @param message 广播的内容
 *  @see GSBroadcastManager
 */
- (void)broadcastManager:(GSBroadcastManager*)manager broadcastMessage:(NSString *)message;


/**
 *  点名倒计时代理
 *
 *  @param manager 触发此代理的GSBroadcastManager对象
 *  @param number  倒计时开始的数字
 *  @see GSBroadcastManager
 */
- (void)broadcastManager:(GSBroadcastManager*)manager checkinRequestCountingDownFrom:(NSInteger)number;


/**
 *  收到用户回应点名代理
 *
 *  @param manager 触发此代理的GSBroadcastManager对象
 *  @param userID  回应点名的用户的UserID
 *  @see GSBroadcastManager
 */
- (void)broadcastManager:(GSBroadcastManager*)manager checkinRequestResponsedUser:(long long)userID;


/**
 *  举手代理(场景类似于课堂中的举手）
 *
 *  @param manager 触发此代理的GSBroadcastManager对象
 *  @param userID  举手的用户的UserID
 *  @param data    额外字段
 *  @see GSBroadcastManager
 */
- (void)broadcastManager:(GSBroadcastManager*)manager handUpUser:(long long)userID extraData:(NSString*)data;


/**
 *  手放下代理（对应于举手）
 *
 *  @param manager 触发此代理的GSBroadcastManager对象
 *  @param userID  手放下的用户的UserID
 *  @see  GSBroadcastManager
 */
- (void)broadcastManager:(GSBroadcastManager*)manager handDownUser:(long long)userID;


/**
 *  索取直播设置信息代理
 *
 *  @param manager 触发此代理的GSBroadcastManager对象
 *  @param key     键
 *  @param value   值
 *  @see  GSBroadcastManager
 */
- (void)broadcastManager:(GSBroadcastManager*)manager querySettingsInfoKey:(NSString*)key strValue:(NSString**)value;

/**
 *  索取直播设置信息代理
 *
 *  @param manager 触发此代理的GSBroadcastManager对象
 *  @param key     键
 *  @param value   值
 *  @see  GSBroadcastManager
 */
- (void)broadcastManager:(GSBroadcastManager*)manager querySettingsInfoKey:(NSString*)key numberValue:(int*)value;


/**
 *  保存直播设置信息代理
 *
 *  @param manager 触发此代理的GSBroadcastManager对象
 *  @param key     键
 *  @param value   值
 *  @see  GSBroadcastManager
 */
- (void)broadcastManager:(GSBroadcastManager*)manager saveSettingsInfoKey:(NSString*)key strValue:(NSString*)value;

/**
 *  保存直播设置信息代理
 *
 *  @param manager 触发此代理的GSBroadcastManager对象
 *  @param key     键
 *  @param value   值
 *  @see  GSBroadcastManager
 */
- (void)broadcastManager:(GSBroadcastManager*)manager saveSettingsInfoKey:(NSString*)key numberValue:(int)value;


/**
 *  程序升级提示代理
 *
 *  @param manager 触发此代理的GSBroadcastManager对象
 *  @param urlStr  下载的url
 *  @see  GSBroadcastManager
 */
- (void)broadcastManager:(GSBroadcastManager*)manager upgradedAppDownLoadUrl:(NSString*)urlStr;


/**
 *  网络状态报告代理, 最好的状态为100, 最差的状态为0（接近断网）, 小于50都为较差;
 *
 *  @param manager 触发此代理的GSBroadcastManager对象
 *  @param level   网络状态值
 *  @see  GSBroadcastManager
 */
- (void)broadcastManager:(GSBroadcastManager*)manager networkStatus:(Byte)level;

/**
 *  中奖代理
 *
 *  @param manager   触发此代理的GSBroadcastManager对象
 *  @param type      抽奖动作类型
 *  @param usernames 中奖名单，多人之间有"\n"间隔
 *  @see GSBroadcastManager
 *  @see GSLotteryType
 */
- (void)broadcastManager:(GSBroadcastManager*)manager lotteryActionType:(GSLotteryActionType)type userNames:(NSString*)usernames;


/**
 *  设置采集比特率
 *
 *  @param manager 触发此代理的GSBroadcastManager对象
 *  @param session session
 */
- (void)broadcastManager:(GSBroadcastManager *)manager didSetupCustomBitRate:(VTCompressionSessionRef)session;

@end

#pragma mark -
#pragma mark Audio

/**
 *  直播音频代理，接受音频相关的信息回调
 */
@protocol GSBroadcastAudioDelegate <NSObject>

@required

/**
 *  音频模块初始化反馈代理
 *
 *  @param manager 触发此代理的GSBroadcastManager对象
 *  @param result  布尔值表示音频模块是否加载成功，YES表示成功
 *  @see GSBroadcastManager
 */
- (void)broadcastManager:(GSBroadcastManager*)manager didReceiveAudioModuleInitResult:(BOOL)result;


@optional

/**
 *  麦克风是否可用代理
 *
 *  @param manager     触发此代理的GSBroadcastManager对象
 *  @param isAvailabel 布尔值表示麦克风是否可用，YES表示可用
 *  @see GSBroadcastManager
 */
- (void)broadcastManager:(GSBroadcastManager*)manager isMicrophoneAvailable:(BOOL)isAvailabel;


/**
 *  麦克风打开代理
 *
 *  @param manager 触发此代理的GSBroadcastManager对象
 *  @see  GSBroadcastManager
 */
- (void)broadcastManagerDidActivateMicrophone:(GSBroadcastManager*)manager;


/**
 *  麦克风关闭代理
 *
 *  @param manager 触发此代理的GSBroadcastManager对象
 *  @see  GSBroadcastManager
 */
- (void)broadcastManagerDidInactivateMicrophone:(GSBroadcastManager*)manager;


/**
 *  麦克风设置音量代理
 *
 *  @param manager 触发此代理的GSBroadcastManager对象
 *  @param volume  音量值
 *  @see  GSBroadcastManager
 */
- (void)broadcastManager:(GSBroadcastManager*)manager didSetMicrophoneVolume:(long long)volume;


/**
 *  麦克风音量波值代理（在音量固定的情况下，声音的强弱是不固定的）
 *
 *  @param manager 触发此代理的GSBroadcastManager对象
 *  @param value   音量波值
 *  @see  GSBroadcastManager
 */
- (void)broadcastManager:(GSBroadcastManager*)manager microphoneAudioWaveValue:(long long)value;


/**
 *  喇叭是否可用代理
 *
 *  @param manager     触发此代理的GSBroadcastManager对象
 *  @param isAvailable 布尔值表示喇叭是否可用，YES表示可用
 *  @see  GSBroadcastManager
 */
- (void)broadcastManager:(GSBroadcastManager*)manager isSpeakerAvailable:(BOOL)isAvailable;


/**
 *  喇叭打开代理
 *
 *  @param manager 触发此代理的GSBroadcastManager对象
 *  @see  GSBroadcastManager
 */
- (void)broadcastManagerDidActivateSpeaker:(GSBroadcastManager*)manager;


/**
 *  喇叭关闭代理
 *
 *  @param manager 触发此代理的GSBroadcastManager对象
 *  @see  GSBroadcastManager
 */
- (void)broadcastManagerDidInactivateSpeaker:(GSBroadcastManager*)manager;


/**
 *  喇叭设置音量代理
 *
 *  @param manager 触发此代理的GSBroadcastManager对象
 *  @param volume  喇叭音量值
 *  @see  GSBroadcastManager
 */
- (void)broadcastManager:(GSBroadcastManager*)manager didSetSpeakerVolume:(long long)volume;


/**
 *  喇叭音量波值代理（在音量固定的情况下，声音的强弱是不固定的）
 *
 *  @param manager 触发此代理的GSBroadcastManager对象
 *  @param value   音量波值
 *  @see  GSBroadcastManager
 */
- (void)broadcastManager:(GSBroadcastManager*)manager speakerAudioWaveValue:(long long)value;


/**
 *  指定用户喇叭音量波值代理（在音量固定的情况下，声音的强弱是不固定的）
 *
 *  @param manager 触发此代理的GSBroadcastManager对象
 *  @param value   音量波值
 *  @param userID  用户ID
 *  @see GSBroadcastManager
 */
- (void)broadcastManager:(GSBroadcastManager*)manager speakerAudioWaveValue:(long long)value userID:(long long)userID;

@end


#pragma mark -
#pragma mark Lod
@protocol GSBroadcastLodDelegate <NSObject>
- (void) OnLodJoinConfirm:(BOOL) bRet;
- (void) OnLodFailed:(NSString*)strid;
- (void) OnLodStart:(GSLodItem*) pLiveodItem;
- (void) OnLodSkip:(GSLodItem*) pLiveodItem;
- (void) OnLodPause:(GSLodItem*) pLiveodItem;
- (void) OnLodStop:(GSLodItem*) pLiveodItem;
- (void) OnLodPlaying:(GSLodItem*) pLiveodItem;
- (void) OnLodResourceAdd:(GSLodItem*) lodData;
- (void) OnLodResourceRemove:( NSString* ) strid;
@end
#pragma mark -
#pragma mark Video

/**
 *  直播视频代理，接受直播视频信息回调
 */
@protocol GSBroadcastVideoDelegate <NSObject>

@required


/**
 *  视频模块初始化反馈代理
 *
 *  @param manager 触发此代理的GSBroadcastManager对象
 *  @param result  布尔值表示初始化结果，YES表示成功
 *  @see  GSBroadcastManager
 */
- (void)broadcastManager:(GSBroadcastManager*)manager didReceiveVideoModuleInitResult:(BOOL)result;


/**
 *  摄像头或插播视频每一帧的数据代理
 *
 *  @param manager  触发此代理的GSBroadcastManager对象
 *  @param userID   表示这一帧视频数据是从该用户哪里发送过来的
 *  @param videoFrame 一帧视频数据
 *  @see  GSBroadcastManager
 *  @see  GSVideoFrame
 */
- (void)broadcastManager:(GSBroadcastManager*)manager userID:(long long)userID renderVideoFrame:(GSVideoFrame*)videoFrame;


- (void)OnVideoData4Render:(long long) userId width: (int) nWidth nHeight:(int) nHeight frameFormat:( unsigned int) dwFrameFormat  displayRatio: (float) fDisplayRatio data:( void*) pData len:(int) iLen;

@optional


/**
 *  某个用户加入视频
 *
 *  @param manager 触发此代理的GSBroadcastManager对象
 *  @param userInfo 用户信息
 *  @see GSBroadcastManager
 *  @see GSUserInfo
 */
- (void)broadcastManager:(GSBroadcastManager*)manager didUserJoinVideo:(GSUserInfo*)userInfo;


/**
 *  某个用户退出视频
 *
 *  @param manager 触发此代理的GSBroadcastManager对象
 *  @param userID  退出用户的ID
 *  @see GSBroadcastManager
 */
- (void)broadcastManager:(GSBroadcastManager*)manager didUserQuitVideo:(long long)userID;



/**
 *  摄像头是否可用代理
 *
 *  @param manager     触发此代理的GSBroadcastManager对象
 *  @param isAvailable 布尔值表示摄像头是否可用，YES表示可用
 *  @see  GSBroadcastManager
 */
- (void)broadcastManager:(GSBroadcastManager*)manager isCameraAvailable:(BOOL)isAvailable;


/**
 *  摄像头打开代理
 *
 *  @param manager 触发此代理的GSBroadcastManager对象
 *  @see GSBroadcastManager
 */
- (void)broadcastManagerDidActivateCamera:(GSBroadcastManager*)manager;


/**
 *  摄像头关闭代理
 *
 *  @param manager 触发此代理的GSBroadcastManager对象
 *  @see  GSBroadcastManager
 */
- (void)broadcastManagerDidInactivateCamera:(GSBroadcastManager*)manager;


/**
 *  摄像头或插播视频播放代理
 *
 *  @param manager  触发此代理的GSBroadcastManager对象
 *  @param userInfo 视频所属用户的用户信息
 *  @see  GSBroadcastManager
 *  @see  GSUserInfo
 */
- (void)broadcastManager:(GSBroadcastManager*)manager didDisplayVideo:(GSUserInfo*)userInfo;


/**
 *  摄像头或插播视频关闭播放代理
 *
 *  @param manager 触发此代理的GSBroadcastManager对象
 *  @param userID  视频所属用户的ID
 *  @see  GSBroadcastManager
 */
- (void)broadcastManager:(GSBroadcastManager*)manager didUndisplayVideo:(long long)userID;


/**
 *  设置某一路摄像头或插播视频的激活状态代理
 *
 *  @param manager  触发此代理的GSBroadcastManager对象
 *  @param userInfo 激活视频所属用户的用户信息
 *  @param active   布尔值表示是否激活，YES表示激活
 *  @see  GSBroadcastManager
 *  @see  GSUserInfo
 */
- (void)broadcastManager:(GSBroadcastManager*)manager didSetVideo:(GSUserInfo*)userInfo active:(BOOL)active;


/**
 *  手机摄像头开始采集数据
 *
 *  @param manager 触发此代理的GSBroadcastManager对象
 */
- (BOOL)broadcastManagerDidStartCaptureVideo:(GSBroadcastManager*)manager;

@end

#pragma mark -
#pragma mark As


/**
 *  直播桌面共享代理，接收桌面共享信息回调
 */
@protocol GSBroadcastDesktopShareDelegate <NSObject>

@required


/**
 *  桌面共享模块初始化反馈代理
 *
 *  @param manager 触发此代理的GSBroadcastManager对象
 *  @param result  布尔值表示初始化是否成功，YES表示成功
 *  @see  GSBroadcastManager
 */
- (void)broadcastManager:(GSBroadcastManager*)manager didReceiveDesktopShareModuleInitResult:(BOOL)result;


/**
 *  桌面共享每一帧的数据
 *
 *  @param manager    触发此代理的GSBroadcastManager对象
 *  @param videoFrame 视频数据的一帧
 *  @see  GSVideoFrame
 */
//- (void)broadcastManager:(GSBroadcastManager*)manager renderDesktopShareFrame:(GSVideoFrame*)videoFrame;

- (void)broadcastManager:(GSBroadcastManager*)manager renderDesktopShareFrame:(UIImage*)videoFrame;

@optional


- (void)OnAsData:(unsigned char*) data dataLen:(unsigned int) dataLen width: (int) width height:(int) height;

/**
 *  开启桌面共享代理
 *
 *  @param manager 触发此代理的GSBroadcastManager对象
 *  @param userID  桌面共享的ID
 *  @see GSBroadcastManager
 */
- (void)broadcastManager:(GSBroadcastManager*)manager didActivateDesktopShare:(long long)userID;


/**
 *  桌面共享关闭代理
 *
 *  @param manager 触发此代理的GSBroadcastManager对象
 *  @see GSBroadcastManager
 */
- (void)broadcastManagerDidInactivateDesktopShare:(GSBroadcastManager*)manager;

@end

#pragma mark -
#pragma mark Doc

/**
 *  直播文档代理，接收直播文档信息回调
 */
@protocol GSBroadcastDocumentDelegate <NSObject>

@required


/**
 *  文档模块初始化反馈代理
 *
 *  @param manager 触发此代理的GSBroadcastManager对象
 *  @param result  布尔值表示初始化是否成功，YES表示成功
 *  @see  GSBroadcastManager
 */
- (void)broadcastManager:(GSBroadcastManager*)manager didReceiveDocModuleInitResult:(BOOL)result;


@optional


/**
 *  文档打开代理
 *
 *  @param manager 触发此代理的GSBroadcastManager对象
 *  @see  GSBroadcastManager
 */
- (void)broadcastManager:(GSBroadcastManager *)manager didOpenDocument:(GSDocument*)doc;


/**
 *  文档关闭代理
 *
 *  @param manager 触发此代理的GSBroadcastManager对象
 *  @see  GSBroadcastManager
 */
- (void)broadcastManager:(GSBroadcastManager *)manager didCloseDocument:(unsigned)docID;


/**
 *  文档切换代理
 *
 *  @param manager 触发此代理的GSBroadcastManager对象
 *  @see  GSBroadcastManager
 */
- (void)broadcastManager:(GSBroadcastManager*)manager didSlideToPage:(unsigned)pageID ofDoc:(unsigned)docID step:(int)step;

/**
 *  文档收到标注代理
 *
 *  @param manager 触发此代理的GSBroadcastManager对象
 *  @param anno    标注对象
 *  @param pageID  标注所属Page的pageID
 *  @param docID   标注所属的Doc的docID
 */
- (void)broadcastManager:(GSBroadcastManager*)manager didReceiveAnno:(GSAnnoBase*)anno onPage:(unsigned int)pageID ofDoc:(unsigned int)docID ;


/**
 *  文档删除标注代理
 *
 *  @param manager 触发此代理的GSBroadcastManager对象
 *  @param annoID  删除标注的ID
 *  @param pageID  删除标注所属的Page的pageID
 *  @param docID   删除标注所属的Doc的docID
 */
- (void)broadcastManager:(GSBroadcastManager*)manager didRemoveAnno:(long long)annoID onPage:(unsigned int)pageID ofDoc:(unsigned int)docID;

/**
 *  文档页加载完成代理
 *
 *  @param manager 触发此代理的GSBroadcastManager对象
 *  @param page    加载完的文档页对象
 *  @param docID   文档页所属的Doc的docID
 */
- (void)broadcastManager:(GSBroadcastManager*)manager didFinishLoadingPage:(GSDocPage*)page ofDoc:(unsigned int)docID;

/**
 *  文档是否保存到服务器代理
 *
 *  @param manager 触发此代理的GSBroadcastManager对象
 *  @param docID   文档的docID
 *  @param bSaved  是否保存到服务器
 *  @param isBySelf 是否是自己保存的，YES表示是
 */
- (void)broadcastManager:(GSBroadcastManager*)manager doc:(unsigned int)docID savedOnServer:(BOOL)bSaved bySelf:(BOOL)isBySelf;


@end

#pragma mark -
#pragma mark Chat

/**
 *  直播文本聊天代理，接收直播聊天信息回调
 */
@protocol GSBroadcastChatDelegate <NSObject>

@required


/**
 *  聊天模块连接代理
 *
 *  @param broadcastManager 触发此代理的GSBroadcastManager对象
 *  @param result           布尔值表示初始化是否成功，YES表示成功
 *  @see  GSBroadcastManager
 */
- (void)broadcastManager:(GSBroadcastManager*)broadcastManager didReceiveChatModuleInitResult:(BOOL)result;


@optional


/**
 *  收到私人聊天代理
 *
 *  @param broadcastManager 触发此代理的GSBroadcastManager对象
 *  @param msg              聊天消息数据
 *  @param user             发送者用户信息
 *  @see  GSBroadcastManager
 *  @see  GSChatMessage
 *  @see  GSUserInfo
 */
- (void)broadcastManager:(GSBroadcastManager*)broadcastManager didReceivePrivateMessage:(GSChatMessage*)msg fromUser:(GSUserInfo*)user;


/**
 *  收到公共聊天代理
 *
 *  @param broadcastManager 触发此代理的GSBroadcastManager对象
 *  @param msg              聊天消息数据
 *  @param user             发送者用户信息
 *  @see  GSBroadcastManager
 *  @see  GSChatMessage
 *  @see  GSUserInfo
 */
- (void)broadcastManager:(GSBroadcastManager*)broadcastManager didReceivePublicMessage:(GSChatMessage*)msg fromUser:(GSUserInfo*)user;


/**
 *  收到嘉宾聊天代理
 *
 *  @param broadcastManager 触发此代理的GSBroadcastManager对象
 *  @param msg              聊天消息数据
 *  @param user             发送者用户信息
 *  @see   GSBroadcastManager
 *  @see   GSChatMessage
 *  @see   GSUserInfo
 */
- (void)broadcastManager:(GSBroadcastManager*)broadcastManager didReceivePanelistMessage:(GSChatMessage*)msg fromUser:(GSUserInfo*)user;


/**
 *  禁止或允许聊天/问答 状态改变代理
 *
 *  @param broadcastManager 触发此代理的GSBroadcastManager对象
 *  @param enabled          布尔值表示是否允许聊天和问答，YES表示允许
 *  @see  GSBroadcastManager
 */
- (void)broadcastManager:(GSBroadcastManager*)broadcastManager didSetChattingEnabled:(BOOL)enabled;

@end

#pragma mark -
#pragma mark Qa

/**
 *  直播问答代理，接收问答信息回调
 */
@protocol GSBroadcastQaDelegate <NSObject>

@required


/**
 *  问答模块初始化结果反馈代理
 *
 *  @param broadcastManager 触发此代理的GSBroadcastManager对象
 *  @param result           布尔值表示初始化结果，YES表示成功
 *  @see  GSBroadcastManager
 */
- (void)broadcastManager:(GSBroadcastManager*)broadcastManager didReceiveQaModuleInitResult:(BOOL)result;


@optional


/**
 *  问答设置状态改变代理
 *
 *  @param broadcastManager 触发此代理的GSBroadcastManager对象
 *  @param enabled          布尔值表示是否可以提问， YES表示可以
 *  @param autoDispatch     布尔值表示问题是否自动派发给嘉宾
 *  @param autoPublish      布尔值表示问题是否自动发布，YES表示自动发布
 *  @see  GSBroadcastManager
 */
- (void)broadcastManager:(GSBroadcastManager*)broadcastManager didSetQaEnabled:(BOOL)enabled QuestionAutoDispatch:(BOOL)autoDispatch QuestionAutoPublish:(BOOL)autoPublish;


/**
 *  问题的状态改变代理
 *
 *  @param broadcastManager 触发此代理的GSBroadcastManager对象
 *  @param question         问题对象
 *  @param status           枚举值表示发生了何种类型的状态改变
 *  @see  GSBroadcastManager
 *  @see  GSQuestion
 *  @see  GSQaStatus
 */
- (void)broadcastManager:(GSBroadcastManager*)broadcastManager question:(GSQuestion*)question updatesOnStatus:(GSQaStatus)status;

@end


#pragma mark -
#pragma mark Investigation

/**
 *  直播问卷调查代理，接受直播中问卷调查信息的回调
 */
@protocol GSBroadcastInvestigationDelegate <NSObject>

@required


/**
 *  问卷调查模块初始化结果反馈代理
 *
 *  @param broadcastManager 触发此代理的GSBroadcastManager对象
 *  @param result           布尔值表示初始化是否成功， YES表示成功
 *  @see GSBroadcastManager
 */
- (void)broadcastManager:(GSBroadcastManager*)broadcastManager didReceiveInvestigationModuleInitResult:(BOOL)result;

@optional


/**
 *  添加问卷调查代理
 *
 *  @param broadcastManager 触发此代理的GSBroadcastManager对象
 *  @param investigation    添加的问卷调查对象
 *  @see  GSBroadcastManager
 *  @see  GSInvestigation
 */
- (void)broadcastManager:(GSBroadcastManager*)broadcastManager didAddNewInvestigation:(GSInvestigation*)investigation;


/**
 *  删除一项问卷调查
 *
 *  @param broadcastManager 触发此代理的GSBroadcastManager对象
 *  @param investigation    删除的问卷调查对象
 *  @see   GSBroadcastManager
 *  @see   GSInvestigation
 */
- (void)broadcastManager:(GSBroadcastManager*)broadcastManager didRemoveInvestigation:(GSInvestigation*)investigation;


/**
 *  发布一项问卷调查
 *
 *  @param broadcastManager 触发此代理的GSBroadcastManager对象
 *  @param investigation    发布的问卷调查对象
 *  @see   GSBroadcastManager
 *  @see   GSInvestigation
 */
- (void)broadcastManager:(GSBroadcastManager*)broadcastManager didPublishInvestigation:(GSInvestigation*)investigation;


/**
 *  公布一项问卷调查的结果
 *
 *  @param broadcastManager 触发此代理的GSBroadcastManager对象
 *  @param investigation    公布了结果的问卷调查对象
 *  @see   GSBroadcastManager
 *  @see   GSInvestigation
 */
- (void)broadcastManager:(GSBroadcastManager*)broadcastManager didPublishInvestigationResult:(GSInvestigation*)investigation;


/**
 *  提交一项问卷调查
 *
 *  @param broadcastManager 触发此代理的GSBroadcastManager对象
 *  @param investigation    提交的问卷调查对象
 *  @see   GSBroadcastManager
 *  @see   GSInvestigation
 */
- (void)broadcastManager:(GSBroadcastManager*)broadcastManager didSubmitInvestigation:(GSInvestigation*)investigation;


/**
 *  问卷调查截止
 *
 *  @param broadcastManager 触发此代理的GSBroadcastManager对象
 *  @param investigation    截止了的问卷调查对象
 *  @see   GSBroadcastManager
 *  @see   GSInvestigation
 */
- (void)broadcastManager:(GSBroadcastManager *)broadcastManager didTerminateInvestigation:(GSInvestigation *)investigation;


/**
 *  发送问卷调查链接
 *
 *  @param broadcastManager 触发此代理的GSBroadcastManager对象
 *  @param investigationURL 问卷调查链接地址
 *  @see  GSBroadcastManager
 */
- (void)broadcastManager:(GSBroadcastManager *)broadcastManager didPostInvestigationURL:(NSString *)investigationURL;



/**
 *  发布答题卡
 *
 *  @param broadcastManager 触发此代理的GSBroadcastManager对象
 *  @param options 答题卡选项
 *  @param type 答题卡类型，单选，多选
 *  @see  GSBroadcastManager
 */
- (void)broadcastManager:(GSBroadcastManager *)broadcastManager didOnCardPublish:(NSDictionary *)options type:(GSCardQuestionType)questionType;



/**
 *  答题卡结果发布
 *
 *  @param broadcastManager 触发此代理的GSBroadcastManager对象
 *  @param options 所有选项,包括选择此选项的人数,此选项是否为正确答案
 *  @param type 答题卡类型，单选，多选
 *  @param totalSubmitted 总的提交人数
 *  @see  GSBroadcastManager
 */
- (void)broadcastManager:(GSBroadcastManager *)broadcastManager didOnCardResultPublish:(NSMutableArray *)options type:(GSCardQuestionType)questionType totalSubmitted:(int)totalSubmitted;



/**
 *  答题卡提交
 *
 *  @param broadcastManager 触发此代理的GSBroadcastManager对象
 *  @param itemIds 数组
 *  @param userId 用户id
 *  @see  GSBroadcastManager
 */
- (void)broadcastManager:(GSBroadcastManager *)broadcastManager didOnCardSubmit:(NSArray *)itemIds userId:(long long)userId;



/**
 *  答题卡结束
 *
 *  @param broadcastManager 触发此代理的GSBroadcastManager对象

 *  @see  GSBroadcastManager
 */
- (void)broadcastManager_didOnCardEnd:(GSBroadcastManager *)broadcastManager ;



@end


/**
 *  直播问卷调查代理，接受直播中红包的回调
 */
@protocol GSBroadcastHongbaoDelegate <NSObject>

@optional

/**
 *  创建红包结果回调
 *
 *  @param broadcastManager 触发此代理的GSBroadcastManager对象
 *  @param result           创建结果
 *  @param strid            红包ID
 */
- (void)broadcastManager:(GSBroadcastManager*) broadcastManager onHongbaoCreate:(GSHongbaoCreateResult)result strId:(NSString*)strid;

/**
 *  抢红包结果回调
 *
 *  @param broadcastManager 触发此代理的GSBroadcastManager对象
 *  @param result           抢红包结果
 *  @param strid            红包ID
 *  @param money            抢到的金额
 */
- (void)broadcastManager:(GSBroadcastManager*) broadcastManager onHongbaoGrabHongbao:(GSHongbaoGrabResult)result strId:(NSString*)strid money:(unsigned)money;

/**
 *  查询会议里所有的红包列表
 *
 *  @param broadcastManager  触发此代理的GSBroadcastManager对象
 *  @param hongbaoArray     红包列表
 */
- (void)broadcastManager:(GSBroadcastManager*)broadcastManager onHongbaoQueryHongbaoList:(NSArray*)hongbaoArray;

/**
 *  查询抢了这个红包的所有人
 *
 *  @param broadcastManager 触发此代理的GSBroadcastManager对象
 *  @param grabs            抢了这个红包的所有人的信息
 *  @param strid            红包ID
 */
- (void)broadcastManager:(GSBroadcastManager*) broadcastManager onHongbaoQueryHongbaoGrabList:(NSArray*)grabs strId:(NSString*)strid;

/**
 *  查询自己抢的所有红包
 *
 *  @param broadcastManager 触发此代理的GSBroadcastManager对象
 *  @param grabs            自己抢的红包列表
 */
- (void)broadcastManager:(GSBroadcastManager*) broadcastManager onHongbaoQuerySelfGrabList:(NSArray*)grabs;

/**
 *  查询余额
 *
 *  @param broadcastManager 触发此代理的GSBroadcastManager对象
 *  @param balance          余额
 *  @param ok
 */
- (void)broadcastManager:(GSBroadcastManager*) broadcastManager onHongbaoQueryBalance:(unsigned)balance ok:(BOOL)ok;

/**
 *  出现红包回调
 *
 *  @param broadcastManager 触发此代理的GSBroadcastManager对象
 *  @param hongbaoInfo      红包信息
 */
- (void)broadcastManager:(GSBroadcastManager*) broadcastManager onHongbaoComingNotify:(GSHongbaoInfo*)hongbaoInfo;

/**
 *  红包被抢回调
 *
 *  @param broadcastManager 触发此代理的GSBroadcastManager对象
 *  @param strid            红包ID
 *  @param grabInfo         抢红包信息
 *  @param hongbaoType      红包类型：//0:随机红包，1：固定红包，2：定向红包
 */
- (void)broadcastManager:(GSBroadcastManager*) broadcastManager onHongbaoGrabbedNotify:(NSString*)strid grabInfo:(GSGrabInfo*)grabInfo type:(int)hongbaoType;

@end

