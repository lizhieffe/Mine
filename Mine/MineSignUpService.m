//
//  MineSignUpService.m
//  Mine
//
//  Created by Zhi Li on 7/27/14.
//  Copyright (c) 2014 com.zhi.li. All rights reserved.
//

#import "MineSignUpService.h"

@interface MineSignUpService ()

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *passcode;
@property (nonatomic, strong) NSString *firstname;
@property (nonatomic, strong) NSString *lastname;
@property (nonatomic, assign) MineGenderType gender;

@end

@implementation MineSignUpService

- (void)signUpWithUsername:(NSString *)username passcode:(NSString *)passcode firstname:(NSString *)firstname lastname:(NSString *)lastname gender:(MineGenderType)gender
{
    _username = username;
    _passcode = passcode;
    _firstname = firstname;
    _lastname = lastname;
    _gender = gender;
    
    [self updateParameters];
    [super start];
}

- (NSString *)apiPath
{
    return @"/signup";
}

- (void)updateParameters
{
    [super updateParameters];
    
    [self.requestParameters setObject:_username forKey:MineRequestParameterUsername];
    [self.requestParameters setObject:_passcode forKey:MineRequestParameterPasscode];
    [self.requestParameters setObject:_firstname forKey:MineRequestParameterFirstname];
    [self.requestParameters setObject:_lastname forKey:MineRequestParameterLastname];
    
    NSString *genderParameter;
    if (_gender == GenderTypeMale)
        genderParameter = @"m";
    else if (_gender == GenderTypeFemale)
        genderParameter = @"f";
    else
        genderParameter = @"u";
    [self.requestParameters setObject:genderParameter forKey:MineRequestParameterGender];
}

- (void (^)(NSMutableDictionary *json, NSURLResponse *response))completionBlockForSuccess
{
    return ^(NSMutableDictionary *json, NSURLResponse *response) {
        [[NSNotificationCenter defaultCenter] postNotificationName:MineNotificationSignUpDidSucceed object:self userInfo:json];
    };
}

@end
