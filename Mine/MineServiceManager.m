//
//  MineServiceManager.m
//  Mine
//
//  Created by Zhi Li on 10/9/14.
//  Copyright (c) 2014 com.zhi.li. All rights reserved.
//

#import "MineServiceManager.h"
#import "MineGetAllTransactionsService.h"
#import "MinePreferenceService.h"

@interface MineServiceManager ()

@property (strong, nonatomic) NSMutableDictionary *lastSucceedDates;
@property (strong, atomic) MineService *currentService;

@end

@implementation MineServiceManager

+ (id)sharedManager
{
    static MineServiceManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
        sharedManager.lastSucceedDates = [[NSMutableDictionary alloc] init];
    });
    return sharedManager;
}

- (void)getAllTransactions
{
    MineGetAllTransactionsService *service = [[MineGetAllTransactionsService alloc] init];
    service.lastSucceedDate = [self.lastSucceedDates objectForKey:@"getAllTransactions"];
    [service getAllTransactionsForToken:[MinePreferenceService token]];
}

@end
