//
//  MineTransactionInfo.h
//  Mine
//
//  Created by Zhi Li on 7/27/14.
//  Copyright (c) 2014 com.zhi.li. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MineTransactionItem;

@interface MineTransactionInfo : NSObject

+ (id)sharedManager;

- (void)addTransactionItem:(MineTransactionItem *)item;
- (void)saveTransactionsFromJson:(NSDictionary *)json;
- (void)deleteTransactionWithId:(long)transactionId;
- (NSMutableArray *)getAllTransactionsForYear:(NSInteger)year month:(NSInteger)month;
- (NSInteger)getTotalIncomeForYear:(NSInteger)year month:(NSInteger)month;
- (NSInteger)getTotalExpenseForYear:(NSInteger)year month:(NSInteger)month;
- (NSInteger)getTotalAmountForYear:(NSInteger)year month:(NSInteger)month;

@end
