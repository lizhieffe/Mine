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

+ (id)sharedManager;

+ (MineUserInfo *)currentUserInfo;
+ (void)setCurrentUserInfo:(MineUserInfo *)userInfo;
+ (NSString *)token;
+ (void)setToken:(NSString *)token;
+ (void)cleanCurrentUserInfo;

- (NSInteger)displayMonth;
- (void)setDisplayMonth:(NSInteger)displayMonth;
- (NSInteger)displayYear;
- (void)setDisplayYear:(NSInteger)displayYear;

@end
