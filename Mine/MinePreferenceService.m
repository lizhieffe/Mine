//
//  MinePreferenceService.m
//  Mine
//
//  Created by Zhi Li on 7/27/14.
//  Copyright (c) 2014 com.zhi.li. All rights reserved.
//

#import "MinePreferenceService.h"
#import "MineUserInfo.h"

@implementation MinePreferenceService

static MineUserInfo *_currentUserInfo;
static NSString *_token;

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

@end
