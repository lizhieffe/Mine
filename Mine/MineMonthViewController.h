//
//  MineTransactionHistoryViewController.h
//  Mine
//
//  Created by Zhi Li on 10/4/14.
//  Copyright (c) 2014 com.zhi.li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SWTableViewCell.h>

@interface MineMonthViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, SWTableViewCellDelegate>

- (id)initForYear:(NSInteger)year month:(NSInteger)month;

@end
