//
//  MineTransactionHistoryTableViewCell.h
//  Mine
//
//  Created by Zhi Li on 10/4/14.
//  Copyright (c) 2014 com.zhi.li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SWTableViewCell.h>

@interface MineTransactionHistoryTableViewCell : SWTableViewCell

//- (id)initWithPrice:(NSInteger)price date:(NSDate *)date;
+ (UITableViewCell *)generateCellWithId:(long)transactionId price:(NSInteger)price date:(NSDate *)date;

@property (assign, nonatomic) NSInteger month;
@property (assign, nonatomic) NSInteger day;
@property (assign, nonatomic) NSInteger price;
@property (assign, nonatomic) long transactionId;

- (void)updateSign;
- (void)updateDateLabel;
- (void)updatePriceLabel;

@end
