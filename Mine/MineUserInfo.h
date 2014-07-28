//
//  MineUserInfo.h
//  Mine
//
//  Created by Zhi Li on 7/27/14.
//  Copyright (c) 2014 com.zhi.li. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    GenderTypeUnknown = -1,
    GenderTypeMale = 0,
    GenderTypeFemale = 1
} MineGenderType;

@interface MineUserInfo : NSObject

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *passcode;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, assign) MineGenderType gender;
@property (nonatomic, strong) NSData *birthday;

@end
