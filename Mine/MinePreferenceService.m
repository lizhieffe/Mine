//
//  MinePreferenceService.m
//  Mine
//
//  Created by Zhi Li on 7/27/14.
//  Copyright (c) 2014 com.zhi.li. All rights reserved.
//

#import "MinePreferenceService.h"
#import "MineUserInfo.h"
#import "MineTimeUtil.h"
#import "MinePersistDataUtil.h"

@interface MinePreferenceService () {
    // the month and year in MineTransactionHistoryViewController
    NSInteger _displayMonth;
    NSInteger _displayYear;
}

@end

@implementation MinePreferenceService

static MineUserInfo *_currentUserInfo;
static NSString *_token;

+ (id)sharedManager
{
    static MinePreferenceService *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        _displayMonth = [MineTimeUtil getCurrentMonth];
        _displayYear = [MineTimeUtil getCurrentYear];
    }
    return self;
}

+ (BOOL)isUserLoggedIn
{
    if ([MinePreferenceService token])
        return YES;
    
    if ([MinePersistDataUtil objectForKey:@"token"]) {
        return YES;
    }
    else
        return NO;
}

+ (MineUserInfo *)currentUserInfo
{
    if (!_currentUserInfo) {
        
    }
    return _currentUserInfo;
}

+ (void)setCurrentUserInfo:(MineUserInfo *)userInfo
{
    _currentUserInfo = userInfo;
}

+ (NSString *)token {
    if (_token)
        return _token;

    NSString *tmp = (NSString *)[MinePersistDataUtil objectForKey:@"token"];
    if (tmp)
        return tmp;
    
    return nil;
}

+ (void)setToken:(NSString *)token {
    _token = token;
    [MinePersistDataUtil setObject:token forKey:@"token"];
}

+ (void)cleanCurrentUserInfo {
    _token = nil;
    [MinePersistDataUtil deleteKey:@"token"];
}

- (NSInteger)displayMonth
{
    return _displayMonth;
}

- (void)setDisplayMonth:(NSInteger)displayMonth
{
    _displayMonth = displayMonth;
}

- (NSInteger)displayYear
{
    return _displayYear;
}

- (void)setDisplayYear:(NSInteger)displayYear
{
    _displayYear = displayYear;
}

@end
