//
//  MineTransactionItem.h
//  Mine
//
//  Created by Zhi Li on 7/27/14.
//  Copyright (c) 2014 com.zhi.li. All rights reserved.
//

#import <Foundation/Foundation.h>

static double const PRICE_UNKNOWN = DBL_MIN;

@interface MineTransactionItem : NSObject <NSCoding>

@property (assign, nonatomic) long transactionId;
@property (nonatomic, assign) double price;
@property (strong, nonatomic) NSDate *transactionDate;

- (id)initWithId:(long)transactionId date:(NSDate *)date price:(double)price;

@end
