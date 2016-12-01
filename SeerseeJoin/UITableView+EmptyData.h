//
//  UITableView+EmptyData.h
//  SeerseeJoin
//
//  Created by 赵云锋 on 2016/11/28.
//  Copyright © 2016年 hawaii. All rights reserved.
//

@import UIKit;
@interface UITableView (EmptyData)
- (void) tableViewDisplayWitMsg:(NSString *) message ifNecessaryForRowCount:(NSUInteger) rowCount;
@end
