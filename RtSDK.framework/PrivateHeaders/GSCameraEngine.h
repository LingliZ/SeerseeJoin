//
//  GSCameraEngine.h
//  RtSDK
//
//  Created by apple on 14-6-12.
//  Copyright (c) 2014年 gensee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "H264HwEncoderImpl.h"

@interface GSCameraEngine : NSObject
@property(nonatomic,strong)AVCaptureSession             *mySession;
@property(nonatomic,strong)AVCaptureVideoDataOutput     *myVideoOutput;;
@property(nonatomic,strong)AVCaptureConnection          *myVideoConnect;
@property(nonatomic, assign)BOOL landscape;
@property(nonatomic, strong) H264HwEncoderImpl *h264Encoder;
@property (nonatomic, strong)  NSFileHandle *fileHandle;

- (void)stopVideoCapture;
- (int)numberOfCaptureDevices;
- (int)StartCaptureVideo:(NSString *)szUniName width:(int)width height:(int)height fps:(int)fps vSink:(id)sink;
- (void)setCamera:(NSString *)szUniName width:(int)width height:(int)height fps:(int)fps vSink:(id)sink;
- (void)startCameraing;



+ (GSCameraEngine*)shareInstance;


@end
