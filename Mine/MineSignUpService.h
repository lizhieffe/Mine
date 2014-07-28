//
//  MineSignUpService.h
//  Mine
//
//  Created by Zhi Li on 7/27/14.
//  Copyright (c) 2014 com.zhi.li. All rights reserved.
//

#import "MineService.h"
#import "MineUserInfo.h"

@interface MineSignUpService : MineService

- (void)signUpWithUsername:(NSString *)username passcode:(NSString *)passcode firstname:(NSString *)firstname lastname:(NSString *)lastname gender:(MineGenderType)gender;

@end
