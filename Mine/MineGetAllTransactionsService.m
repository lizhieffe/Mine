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

- (id)init {
    self = [super init];
    if (self) {
        self.expireTimeInterval = 3600;
        self.lastSucceedDate = [NSDate dateWithTimeIntervalSince1970:0];
    }
    return self;
}

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
        
        NSDictionary *errorJson = [json valueForKey:MineResponseKeyErrorJson];
        NSInteger errorCode = [[errorJson valueForKey:MineResponseKeyErrorCode] intValue];
        if (errorCode == 0) {
            self.lastSucceedDate = [NSDate date];
        }
    };
}

@end
