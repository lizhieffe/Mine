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

@property (strong, nonatomic) NSString *token;

@end

@implementation MineGetAllTransactionsService

- (void)getAllTransactionsForToken:(NSString *)token
{
    _token = token;
    
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
    [self.requestParameters setObject:_token forKey:MineRequestParameterToken];
}

- (void (^)(NSMutableDictionary *json, NSURLResponse *response))completionBlockForSuccess
{
    return ^(NSMutableDictionary *json, NSURLResponse *response) {
        [[MineTransactionInfo sharedManager] saveTransactionsFromJson:json];
        [[NSNotificationCenter defaultCenter] postNotificationName:MineNotificationGetAllTransactionsDidSucceed object:self userInfo:json];
    };
}

@end
