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
@property (nonatomic, strong) NSMutableArray *transactionItems;

- (void)addTransactionItem:(MineTransactionItem *)newItem;
- (NSInteger)itemCount;
- (double)totalPrice;

@end
