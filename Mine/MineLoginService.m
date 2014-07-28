//
//  MineLoginService.m
//  Mine
//
//  Created by Zhi Li on 7/26/14.
//  Copyright (c) 2014 com.zhi.li. All rights reserved.
//

#import "MineLoginService.h"

@interface MineLoginService ()

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *passcode;

@end

@implementation MineLoginService

- (void)loginWithUsername:(NSString *)username passcode:(NSString *)passcode
{
    _username = username;
    _passcode = passcode;
    
    [self updateParameters];
    [super start];
}

- (NSString *)apiPath
{
    return @"/login";
}

- (void)updateParameters
{
    [super updateParameters];
    
    [self.requestParameters setObject:_username forKey:MineRequestParameterUsername];
    [self.requestParameters setObject:_passcode forKey:MineRequestParameterPasscode];
}

- (void (^)(NSMutableDictionary *json, NSURLResponse *response))completionBlockForSuccess
{
    return ^(NSMutableDictionary *json, NSURLResponse *response) {
        [[NSNotificationCenter defaultCenter] postNotificationName:MineNotificationLoginDidSucceed object:self userInfo:json];
    };
}

@end
