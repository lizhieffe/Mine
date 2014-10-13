//
//  MineAddTransactionService.m
//  Mine
//
//  Created by Zhi Li on 10/5/14.
//  Copyright (c) 2014 com.zhi.li. All rights reserved.
//

#import "MineAddTransactionService.h"

@interface MineAddTransactionService ()

@property (assign, nonatomic) NSInteger timestamp;
@property (assign, nonatomic) NSInteger price;

@end

@implementation MineAddTransactionService

- (void)addTransactionWithTimestamp:(NSInteger)timestamp price:(NSInteger)price
{
    _timestamp = timestamp;
    _price = price;
    
    [self updateParameters];
    [super start];
}

- (NSString *)apiPath
{
    return @"/addTransaction";
}

- (void)updateParameters
{
    [super updateParameters];
    [self.requestParameters setObject:[@(_timestamp) stringValue] forKey:MineRequestParameterTimestamp];
    [self.requestParameters setObject:[@(_price) stringValue] forKey:MineRequestParameterPrice];
}

- (void (^)(NSMutableDictionary *json, NSURLResponse *response))completionBlockForSuccess
{
    return ^(NSMutableDictionary *json, NSURLResponse *response) {
        [[NSNotificationCenter defaultCenter] postNotificationName:MineNotificationAddTransactionDidSucceed object:self userInfo:json];
    };
}

@end
