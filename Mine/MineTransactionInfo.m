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

@interface MineTransactionInfo ()

@property (strong, nonatomic) NSMutableDictionary *transactionItems;

@end

@implementation MineTransactionInfo

+ (id)sharedManager
{
    static MineTransactionInfo *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
        sharedManager.transactionItems = [[NSMutableDictionary alloc] init];
    });
    return sharedManager;
}

- (id)init
{
    self = [super init];
    if (self) {
//        self.transactionItems = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)addTransactionItem:(MineTransactionItem *)item
{
    NSInteger year = [MineTimeUtil getYearForUnixtime:[item.transactionDate timeIntervalSince1970]];
    NSInteger month = [MineTimeUtil getMonthForUnixtime:[item.transactionDate timeIntervalSince1970]];

    NSDictionary *transactionsForYear = [self.transactionItems objectForKey:[@(year) stringValue]];
    if (!transactionsForYear) {
        [self.transactionItems setValue:[[NSMutableDictionary alloc] init] forKey:[@(year) stringValue]];
        transactionsForYear = [self.transactionItems objectForKey:[@(year) stringValue]];
    }
    
    NSMutableArray *transactionsForMonth = [transactionsForYear objectForKey:[@(month) stringValue]];
    if (!transactionsForMonth) {
        [transactionsForYear setValue:[[NSMutableArray alloc] init] forKey:[@(month) stringValue]];
        transactionsForMonth = [transactionsForYear objectForKey:[@(month) stringValue]];
    }
    
    [transactionsForMonth addObject:item];
}

- (void)saveTransactionsFromJson:(NSDictionary *)json
{
    NSDictionary *transactions = [[json objectForKey:MineResponseKeyResponseJson] objectForKey:MineResponseKeyResponseTransactions];
    for (NSDictionary *tmp in transactions) {
        double price = [[tmp objectForKey:@"price"] doubleValue];
        NSString *tddd = [tmp objectForKey:@"timestamp"];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[((NSString *)[tmp objectForKey:@"timestamp"]) longLongValue]];
        MineTransactionItem *tmp = [[MineTransactionItem alloc] initWithDate:date price:price];
        [self addTransactionItem:tmp];
    }
}

- (NSArray *)getAllTransactionsForYear:(NSInteger)year month:(NSInteger)month
{
    NSDictionary *transactionsForYear = [self.transactionItems objectForKey:[@(year) stringValue]];
    if (!transactionsForYear)
        return nil;
    
    NSArray *result = [transactionsForYear objectForKey:[@(month) stringValue]];
    return result;
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
