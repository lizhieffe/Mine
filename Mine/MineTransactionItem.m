//
//  MineTransactionItem.m
//  Mine
//
//  Created by Zhi Li on 7/27/14.
//  Copyright (c) 2014 com.zhi.li. All rights reserved.
//

#import "MineTransactionItem.h"

@implementation MineTransactionItem

- (id)initWithDate:(NSDate *)date price:(double)price
{
    self = [super init];
    if (self) {
        self.transactionDate = date;
        self.price = price;
    }
    return self;
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    return self;
}

@end
