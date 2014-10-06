//
//  MineTransactionItem.h
//  Mine
//
//  Created by Zhi Li on 7/27/14.
//  Copyright (c) 2014 com.zhi.li. All rights reserved.
//

#import <Foundation/Foundation.h>

static double const PRICE_UNKNOWN = DBL_MIN;

@interface MineTransactionItem : NSObject

@property (nonatomic, strong) NSString *description;
@property (nonatomic, assign) double price;
@property (nonatomic, assign) NSDate *date;

- (id)initWithDate:(NSDate *)date price:(double)price;
- (id)initWithDescription:(NSString *)description price:(double)price;

@end
