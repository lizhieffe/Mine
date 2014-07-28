//
//  MinePreferenceService.h
//  Mine
//
//  Created by Zhi Li on 7/27/14.
//  Copyright (c) 2014 com.zhi.li. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MineUserInfo;

@interface MinePreferenceService : NSObject

+ (MineUserInfo *)currentUserInfo;
+ (void)setCurrentUserInfo:(MineUserInfo *)userInfo;

@end
