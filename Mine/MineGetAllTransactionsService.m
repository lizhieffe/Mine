//
//  MineGetAllTransactionsService.m
//  Mine
//
//  Created by Zhi Li on 10/5/14.
//  Copyright (c) 2014 com.zhi.li. All rights reserved.
//

#import "MineGetAllTransactionsService.h"
#import "MineTransactionInfo.h"

@interface MineGetAllTransactionsService()

@end

@implementation MineGetAllTransactionsService

- (id)init {
    self = [super init];
    if (self) {
        self.expireTimeInterval = 3600;
    }
    return self;
}

- (void)getAllTransactions
{
    [self updateParameters];
    [super start];
}

- (NSString *)apiPath
{
    return @"/getAllTransactions";
}

- (void)updateParameters
{
    [super updateParameters];
    if(self.token)
        [self.requestParameters setObject:self.token forKey:MineRequestParameterToken];
}

- (void (^)(NSMutableDictionary *json, NSURLResponse *response))completionBlockForSuccess
{
    return ^(NSMutableDictionary *json, NSURLResponse *response) {
        
        [[MineTransactionInfo sharedManager] saveTransactionsFromJson:json];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MineNotificationGetAllTransactionsDidSucceed object:self userInfo:json];
    };
}

@end
