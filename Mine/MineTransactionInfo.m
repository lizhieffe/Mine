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
#import "MinePersistDataUtil.h"

NSString *const MinePersistDataKeyTransactions = @"transactions";

@interface MineTransactionInfo ()

@property (strong, nonatomic) NSMutableDictionary *transactionItems;
@property (strong, nonatomic) NSMutableDictionary *transactionItemsHelper;

@end

@implementation MineTransactionInfo

+ (id)sharedManager
{
    static MineTransactionInfo *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
        sharedManager.transactionItems = [[NSMutableDictionary alloc] init];
        sharedManager.transactionItemsHelper = [[NSMutableDictionary alloc] init];
    });
    return sharedManager;
}

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)addTransactionItem:(MineTransactionItem *)item
{
    [self addTransactionItem:item saveToPersistData:NO];
}

- (void)addTransactionItem:(MineTransactionItem *)item saveToPersistData:(BOOL)save
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
    
    if (save)
        [MinePersistDataUtil setObject:self.transactionItems forKey:MinePersistDataKeyTransactions];
    
    [self.transactionItemsHelper setObject:item.transactionDate forKey:[@(item.transactionId) stringValue]];
}

- (void)saveTransactionsFromJson:(NSDictionary *)json
{
    if (self.transactionItems)
        [self.transactionItems removeAllObjects];
    
    NSDictionary *transactions = [[json objectForKey:MineResponseKeyResponseJson] objectForKey:MineResponseKeyResponseTransactions];
    for (NSDictionary *tmp in transactions) {
        long transactionId = [[tmp objectForKey:@"transaction_id"] longValue];
        double price = [[tmp objectForKey:@"price"] doubleValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[((NSString *)[tmp objectForKey:@"timestamp"]) longLongValue]];
        MineTransactionItem *tmp = [[MineTransactionItem alloc] initWithId:transactionId date:date price:price];
        [self addTransactionItem:tmp saveToPersistData:NO];
    }
}

- (void)loadTransactionsFromPersistData
{
    self.transactionItems = [MinePersistDataUtil objectForKey:MinePersistDataKeyTransactions];
}

- (void)deleteTransactionWithId:(long)transactionId
{
    NSDate *date = [self.transactionItemsHelper objectForKey:[@(transactionId) stringValue]];
    NSInteger year = [MineTimeUtil getYearForUnixtime:[date timeIntervalSince1970]];
    NSInteger month = [MineTimeUtil getMonthForUnixtime:[date timeIntervalSince1970]];
    NSMutableArray *transactions = [self getAllTransactionsForYear:year month:month];
    
    MineTransactionItem *itemToDelete = nil;
    for (MineTransactionItem *item in transactions) {
        if (item.transactionId == transactionId) {
            itemToDelete = item;
            break;
        }
    }
    
    if (itemToDelete) {
        [transactions removeObject:itemToDelete];
        [self.transactionItemsHelper removeObjectForKey:[@(transactionId) stringValue]];
    }
}

- (NSMutableArray *)getAllTransactionsForYear:(NSInteger)year month:(NSInteger)month
{
    NSDictionary *transactionsForYear = [self.transactionItems objectForKey:[@(year) stringValue]];
    if (!transactionsForYear)
        return nil;
    
    NSMutableArray *result = [transactionsForYear objectForKey:[@(month) stringValue]];
    return result;
}

- (NSInteger)getIncomeForYear:(NSInteger)year month:(NSInteger)month
{
    NSInteger total = 0;
    NSArray *transactions = [self getAllTransactionsForYear:year month:month];
    for (MineTransactionItem *item in transactions) {
        if (item.price > 0)
            total += item.price;
    }
    return total;
}

- (NSInteger)getOutcomeForYear:(NSInteger)year month:(NSInteger)month
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
    return [self getIncomeForYear:year month:month] + [self getOutcomeForYear:year month:month];
}

- (NSArray *)getIncomeForYear:(NSInteger)year
{
    NSMutableArray *amount = [[NSMutableArray alloc] init];
    for (int i = 0; i < 12; i ++) {
        [amount addObject:[NSNumber numberWithLong:[self getIncomeForYear:year month:(i + 1)]]];
    }
    return amount;
}

- (NSArray *)getAbsOutcomeForYear:(NSInteger)year
{
    NSMutableArray *amount = [[NSMutableArray alloc] init];
    for (int i = 0; i < 12; i ++) {
        [amount addObject:[NSNumber numberWithLong:ABS([self getOutcomeForYear:year month:(i + 1)])]];
    }
    return amount;
}

- (NSArray *)getTotalAmountForYear:(NSInteger)year
{
    NSMutableArray *amount = [[NSMutableArray alloc] init];
    for (int i = 0; i < 12; i ++) {
        [amount addObject:[NSNumber numberWithLong:[self getTotalAmountForYear:year month:(i + 1)]]];
    }
    return amount;
}

- (NSInteger)getIncomeSumForYear:(NSInteger)year
{
    NSInteger sum = 0;
    for (int i = 0; i < 12; i ++)
        sum += [self getIncomeForYear:year month:(i + 1)];
    return sum;
}

- (NSInteger)getOutcomeSumForYear:(NSInteger)year
{
    NSInteger sum = 0;
    for (int i = 0; i < 12; i ++)
        sum += [self getOutcomeForYear:year month:(i + 1)];
    return sum;
}

- (NSInteger)getTotalAmoutSumForYear:(NSInteger)year
{
    NSInteger sum = 0;
    for (int i = 0; i < 12; i ++)
        sum += [self getTotalAmountForYear:year month:(i + 1)];
    return sum;
}

@end
