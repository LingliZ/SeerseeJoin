//
//  RecordingTableViewCell.h
//  SeerseeJoin
//
//  Created by 赵云锋 on 16/10/21.
//  Copyright © 2016年 hawaii. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelDate;
@property (weak, nonatomic) IBOutlet UIButton *btnPlay;
@end
