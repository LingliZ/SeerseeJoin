//
//  membersTableViewCell.h
//  SeerseeJoin
//
//  Created by 赵云锋 on 16/10/12.
//  Copyright © 2016年 hawaii. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface membersTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mName;
@property (weak, nonatomic) IBOutlet UIButton *btnShotof;
@property (weak, nonatomic) IBOutlet UIButton *btnMainVideo;
@property (weak, nonatomic) IBOutlet UIButton *btnMic;
@property (weak, nonatomic) IBOutlet UIButton *btnCamera;
@end
