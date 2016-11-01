//
//  GSDocSwfView.h
//  PlayerSDK
//
//  Created by jiangcj on 15/9/28.
//  Copyright © 2015年 Geensee. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GSVodDocPageLabelView.h"


@interface GSVodDocSwfView : UIView


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


@property (strong, nonatomic)GSVodDocPageLabelView* annoLabelView;  //标注层



@end
