//
//  QuestionTableViewCell.h
//  SeerseeJoin
//
//  Created by 赵云锋 on 16/10/19.
//  Copyright © 2016年 hawaii. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelContent;

@property (weak, nonatomic) IBOutlet UIButton *btnReply;
@end
