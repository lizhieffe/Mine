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

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSDictionary *transactionItems;

+ (id)sharedManager;

- (void)addTransactionItem:(MineTransactionItem *)item;
- (void)saveTransactionsFromJson:(NSDictionary *)json;
- (NSDictionary *)getAllTransactionsForYear:(NSInteger)year month:(NSInteger)month;

@end
