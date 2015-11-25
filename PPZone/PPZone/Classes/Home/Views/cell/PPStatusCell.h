//
//  PPStatusCell.h
//  PPZone
//
//  Created by jiaguanglei on 15/11/25.
//  Copyright © 2015年 roseonly. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PPStatusFrame;

@interface PPStatusCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@property (nonatomic, strong) PPStatusFrame *statusFrame;
@end
