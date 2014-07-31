//
//  MineTransactionInfo.m
//  Mine
//
//  Created by Zhi Li on 7/27/14.
//  Copyright (c) 2014 com.zhi.li. All rights reserved.
//

#import "MineTransactionInfo.h"
#import "MineTransactionItem.h"

@implementation MineTransactionInfo

- (id)init
{
    self = [super init];
    if (self) {
        self.transactionItems = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addTransactionItem:(MineTransactionItem *)newItem
{
    [self.transactionItems addObject:newItem];
}

- (NSInteger)itemCount
{
    return self.transactionItems.count;
}

- (double)totalPrice
{
    double totalPrice = 0;
    for (MineTransactionItem *item in self.transactionItems) {
        totalPrice = totalPrice + item.price;
    }
    return totalPrice;
}

@end
