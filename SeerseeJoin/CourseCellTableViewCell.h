//
//  CourseCellTableViewCell.h
//  SeerseeJoin
//
//  Created by 赵云锋 on 16/9/14.
//  Copyright © 2016年 hawaii. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseCellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imagePhoto;
@property (weak, nonatomic) IBOutlet UIButton *btnEdit;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (weak, nonatomic) IBOutlet UILabel *labelStatus;
@property (weak, nonatomic) IBOutlet UIButton *btnTeacher;
@property (weak, nonatomic) IBOutlet UIButton *btnAssistant;
@end
