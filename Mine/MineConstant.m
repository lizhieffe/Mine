//
//  MineConstant.m
//  Mine
//
//  Created by Zhi Li on 7/26/14.
//  Copyright (c) 2014 com.zhi.li. All rights reserved.
//

#import "MineConstant.h"

#pragma mark - notification name -

NSString *const MineNotificationLoginDidSucceed = @"MineNotificationLoginDidSucceed";
NSString *const MineNotificationSignUpDidSucceed = @"MineNotificationSignUpDidSucceed";
NSString *const MineNotificationDownViewDidHide = @"MineNotificationDownViewDidHide";

#pragma mark - request parameter -

NSString *const MineRequestParameterUsername = @"username";
NSString *const MineRequestParameterPasscode = @"pwd";
NSString *const MineRequestParameterFirstname = @"first";
NSString *const MineRequestParameterLastname = @"last";
NSString *const MineRequestParameterGender = @"gender";

#pragma mark - response key -

NSString *const MineResponseKeyErrorJson = @"error";
NSString *const MineResponseKeyErrorCode = @"code";
NSString *const MineResponseKeyErrorMsg = @"message";

NSString *const MineResponseKeyResponseJson = @"response";
NSString *const MineResponseKeyResponseToken = @"token";


#pragma mark - alert view title and body msg -

// 101
NSString *const MineAlertViewTitleUserNotExist = @"User doesn't exist";
NSString *const MineAlertViewMsgUserNotExist = @"Please make sure your username is correct";

// 102
NSString *const MineAlertViewTitleWrongPasscode = @"Passcode is wrong";
NSString *const MineAlertViewMsgWrongPasscode = @"Please make sure your passcode is correct";