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

@interface MinePreferenceService () {
    NSInteger _displayMonth;
    NSInteger _displayYear;
}

//@property (assign, nonatomic) NSInteger displayMonth;
//@property (assign, nonatomic) NSInteger displayYear;

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
    return _token;
}

+ (void)setToken:(NSString *)token {
    _token = token;
}

+ (void)cleanCurrentUserInfo {
    _currentUserInfo = nil;
    _token = nil;
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
