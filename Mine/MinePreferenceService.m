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

@end
