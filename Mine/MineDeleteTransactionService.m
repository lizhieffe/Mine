//
//  MineDeleteTransactionService.m
//  Mine
//
//  Created by Zhi Li on 10/12/14.
//  Copyright (c) 2014 com.zhi.li. All rights reserved.
//

#import "MineDeleteTransactionService.h"
#import "MinePreferenceService.h"
#import "MineTransactionInfo.h"

@interface MineDeleteTransactionService()

@property (strong, nonatomic) NSString *transactionId;

@end

@implementation MineDeleteTransactionService

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)deleteTransactionWithId:(long)transactionId
{
    _transactionId = [@(transactionId) stringValue];
    
    [self updateParameters];
    [super start];
}

- (NSString *)apiPath
{
    return @"/deleteTransaction";
}

- (void)updateParameters
{
    [super updateParameters];
    [self.requestParameters setObject:_transactionId forKey:MineRequestParameterTransactionId];
}

- (void (^)(NSMutableDictionary *json, NSURLResponse *response))completionBlockForSuccess
{
    return ^(NSMutableDictionary *json, NSURLResponse *response) {
        
        NSDictionary *errorJson = [json valueForKey:MineResponseKeyErrorJson];
        NSInteger errorCode = [[errorJson valueForKey:MineResponseKeyErrorCode] intValue];
        
        if (errorCode == 0) {
            NSDictionary *responseJson = [json valueForKey:MineResponseKeyResponseJson];
            NSString *deletedTransactionId = [responseJson valueForKey:MineResponseKeyResponseDeletedTransactionId];
            [[MineTransactionInfo sharedManager] deleteTransactionWithId:[deletedTransactionId longLongValue]];
        }

        [[NSNotificationCenter defaultCenter] postNotificationName:MineNotificationDeleteTransactionDidSucceed object:self userInfo:json];
    };
}

@end