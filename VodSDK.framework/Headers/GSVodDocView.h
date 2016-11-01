//
//  GSVodDocView.h
//  VodSDK
//
//  Created by jiangcj on 16/7/6.
//  Copyright © 2016年 gensee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSVodDocSwfView.h"



@interface GSVodDocView : UIScrollView


/**
 *  设置文档是否支持pinch手势，YES表示支持
 */
@property (assign, nonatomic) BOOL zoomEnabled;


/**
 *  初始化GSVodPDocView
 *
 *  @param frame 设置GSPDocView的宽高，坐标等信息
 *
 *  @return GSVodPDocView实例
 */
- (id)initWithFrame:(CGRect)frame;



@property (strong, nonatomic)GSVodDocSwfView *vodDocSwfView;




- (void)drawPage:(unsigned int)dwTimeStamp
            data:(const unsigned char*)data
           dwLen:(unsigned int )dwLen
         dwPageW:(unsigned int )dwPageW
         dwPageH:(unsigned int )dwPageH
   strAnimations:(NSString*)strAnimations;

-(void)vodGoToAnimationStep:(int)step;

- (void)vodDrawAnnos:(NSArray*)annos;

-(void)setGlkBackColor:(int)red green:(int)green blue:(int)blue;

@property (nonatomic, assign)BOOL fullMode;





@end
