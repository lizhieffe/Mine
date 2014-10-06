//
//  MineTransactionInfo.m
//  Mine
//
//  Created by Zhi Li on 7/27/14.
//  Copyright (c) 2014 com.zhi.li. All rights reserved.
//

#import "MineTransactionInfo.h"
#import "MineTransactionItem.h"
#import "MineConstant.h"
#import "MineTimeUtil.h"

@implementation MineTransactionInfo

+ (id)sharedManager
{
    static MineTransactionInfo *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.transactionItems = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)addTransactionItem:(MineTransactionItem *)item
{
    NSInteger year = [MineTimeUtil getYearForUnixtime:[item.date timeIntervalSince1970]];
    NSInteger month = [MineTimeUtil getMonthForUnixtime:[item.date timeIntervalSince1970]];
    [self addTransactionItem:item year:year month:month];
}

- (void)addTransactionItem:(MineTransactionItem *)transactionItem year:(NSInteger)year month:(NSInteger)month
{
    NSDictionary *transactionsForYear = [self.transactionItems objectForKey:[@(year) stringValue]];
    if (!transactionsForYear)
        [self.transactionItems setValue:[[NSMutableDictionary alloc] init] forKey:[@(year) stringValue]];
    
    NSArray *transactionsForMonth = [((NSDictionary *)[self.transactionItems objectForKey:[@(year) stringValue]]) objectForKey:[@(month) stringValue]];
    if (!transactionsForMonth)
        [((NSDictionary *)[self.transactionItems objectForKey:[@(year) stringValue]]) setValue:[[NSMutableArray alloc] init] forKey:[@(month) stringValue]];
    
    [((NSMutableArray *)[((NSDictionary *)[self.transactionItems objectForKey:[@(year) stringValue]]) objectForKey:[@(month) stringValue]])addObject:transactionItem];
}

- (void)saveTransactionsFromJson:(NSDictionary *)json
{
    NSDictionary *transactions = [[json objectForKey:MineResponseKeyResponseJson] objectForKey:MineResponseKeyResponseTransactions];
    for (NSDictionary *tmp in transactions) {
        double price = [[tmp objectForKey:@"price"] doubleValue];
        NSDate *date = [MineTimeUtil unixtimeToNSDate:[[tmp objectForKey:@"unixtime"] integerValue]];
        
        MineTransactionItem *tmp = [[MineTransactionItem alloc] initWithDate:date price:price];
        [self addTransactionItem:tmp];
    }
}

- (NSArray *)getAllTransactionsForYear:(NSInteger)year month:(NSInteger)month
{
    NSDictionary *transactionsForYear = [self.transactionItems objectForKey:[@(year) stringValue]];
    if (!transactionsForYear)
        return nil;
    
    return (NSArray *)[transactionsForYear objectForKey:[@(month) stringValue]];
}

- (NSInteger)getTotalIncomeForYear:(NSInteger)year month:(NSInteger)month
{
    NSInteger total = 0;
    NSArray *transactions = [self getAllTransactionsForYear:year month:month];
    for (MineTransactionItem *item in transactions) {
        if (item.price > 0)
            total += item.price;
    }
    return total;
}

- (NSInteger)getTotalExpenseForYear:(NSInteger)year month:(NSInteger)month
{
    NSInteger total = 0;
    NSArray *transactions = [self getAllTransactionsForYear:year month:month];
    for (MineTransactionItem *item in transactions) {
        if (item.price < 0)
            total += item.price;
    }
    return total;
}

- (NSInteger)getTotalAmountForYear:(NSInteger)year month:(NSInteger)month
{
    return [self getTotalIncomeForYear:year month:month] + [self getTotalExpenseForYear:year month:month];
}

@end
