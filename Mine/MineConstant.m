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
NSString *const MineNotificationAddTransactionDidSucceed = @"MineNotificationAddTransactionDidSucceed";
NSString *const MineNotificationGetAllTransactionsDidSucceed = @"MineNotificationGetAllTransactionsDidSucceed";
NSString *const MineNotificationDownViewDidHide = @"MineNotificationDownViewDidHide";

#pragma mark - request parameter -

NSString *const MineRequestParameterUsername = @"username";
NSString *const MineRequestParameterPasscode = @"pwd";
NSString *const MineRequestParameterFirstname = @"first";
NSString *const MineRequestParameterLastname = @"last";
NSString *const MineRequestParameterGender = @"gender";
NSString *const MineRequestParameterToken = @"token";
NSString *const MineRequestParameterTimestamp = @"timestamp";
NSString *const MineRequestParameterPrice = @"price";

#pragma mark - response key -

NSString *const MineResponseKeyErrorJson = @"error";
NSString *const MineResponseKeyErrorCode = @"code";
NSString *const MineResponseKeyErrorMsg = @"message";

NSString *const MineResponseKeyResponseJson = @"response";
NSString *const MineResponseKeyResponseToken = @"token";
NSString *const MineResponseKeyResponseTransactions = @"transactions";

#pragma mark - alert view title and body msg -

// 1
NSString *const MineAlertViewTitleGeneralError = @"User doesn't exist";
NSString *const MineAlertViewMsgGeneralError = @"Please make sure your username is correct";

// 101
NSString *const MineAlertViewTitleUserNotExist = @"User doesn't exist";
NSString *const MineAlertViewMsgUserNotExist = @"Please make sure your username is correct";

// 102
NSString *const MineAlertViewTitleWrongPasscode = @"Passcode is wrong";
NSString *const MineAlertViewMsgWrongPasscode = @"Please make sure your passcode is correct";