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
- (void)clearTransactions;

- (NSMutableArray *)getAllTransactionsForYear:(NSInteger)year month:(NSInteger)month;

- (NSInteger)getIncomeSumForYear:(NSInteger)year month:(NSInteger)month;
- (NSInteger)getOutcomeSumForYear:(NSInteger)year month:(NSInteger)month;
- (NSInteger)getBalanceSumForYear:(NSInteger)year month:(NSInteger)month;

- (NSInteger)getIncomeSumForYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
- (NSInteger)getOutcomeSumForYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
- (NSInteger)getBalanceSumForYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;

- (NSArray *)getIncomeForYear:(NSInteger)year;
- (NSArray *)getAbsOutcomeForYear:(NSInteger)year;
- (NSArray *)getTotalAmountForYear:(NSInteger)year;

- (NSArray *)getIncomeForYear:(NSInteger)year month:(NSInteger)month sumEveryNDay:(NSInteger)n;
- (NSArray *)getAbsOutcomeForYear:(NSInteger)year month:(NSInteger)month sumEveryNDay:(NSInteger)n;
- (NSArray *)getTotalAmountForYear:(NSInteger)year month:(NSInteger)month sumEveryNDay:(NSInteger)n;

- (NSInteger)getIncomeSumForYear:(NSInteger)year;
- (NSInteger)getOutcomeSumForYear:(NSInteger)year;
- (NSInteger)getTotalAmoutSumForYear:(NSInteger)year;

@end
