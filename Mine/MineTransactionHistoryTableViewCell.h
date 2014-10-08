//
//  MineTransactionHistoryTableViewCell.h
//  Mine
//
//  Created by Zhi Li on 10/4/14.
//  Copyright (c) 2014 com.zhi.li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineTransactionHistoryTableViewCell : UITableViewCell

//- (id)initWithPrice:(NSInteger)price date:(NSDate *)date;
+ (UITableViewCell *)generateCellWithPrice:(NSInteger)price date:(NSDate *)date;

@property (assign, nonatomic) NSInteger month;
@property (assign, nonatomic) NSInteger day;
@property (assign, nonatomic) NSInteger price;

- (void)updateSign;
- (void)updateDateLabel;
- (void)updatePriceLabel;

@end
