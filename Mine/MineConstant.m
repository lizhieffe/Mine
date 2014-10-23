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
NSString *const MineNotificationDeleteTransactionDidSucceed = @"MineNotificationDeleteTransactionDidSucceed";
NSString *const MineNotificationDownViewDidHide = @"MineNotificationDownViewDidHide";
NSString *const MineNotificationShowLoginView = @"MineNotificationShowLoginView";

#pragma mark - request parameter -

NSString *const MineRequestParameterUsername = @"username";
NSString *const MineRequestParameterPasscode = @"pwd";
NSString *const MineRequestParameterFirstname = @"first";
NSString *const MineRequestParameterLastname = @"last";
NSString *const MineRequestParameterGender = @"gender";
NSString *const MineRequestParameterToken = @"token";
NSString *const MineRequestParameterTimestamp = @"timestamp";
NSString *const MineRequestParameterPrice = @"price";
NSString *const MineRequestParameterTransactionId = @"transaction_id";

#pragma mark - response key -

NSString *const MineResponseKeyErrorJson = @"error";
NSString *const MineResponseKeyErrorCode = @"code";
NSString *const MineResponseKeyErrorMsg = @"message";

NSString *const MineResponseKeyResponseJson = @"response";
NSString *const MineResponseKeyResponseToken = @"token";
NSString *const MineResponseKeyResponseTransactions = @"transactions";
NSString *const MineResponseKeyResponseDeletedTransactionId = @"deleted_transaction_id";

#pragma mark - alert view title and body msg -

// 1
NSString *const MineAlertViewTitleGeneralError = @"User doesn't exist";
NSString *const MineAlertViewMsgGeneralError = @"Please make sure your username is correct";

// 9
NSString *const MineAlertViewTitleInternetNotAvailable = @"Internet access is not available";
NSString *const MineAlertViewMsgInternetNotAvailable = @"Please connect to internet and try again";

// 10
NSString *const MineAlertViewTitleLoginRequestTimeout = @"Cannot log in user due to network issue";
NSString *const MineAlertViewMsgLoginRequestTimeout = @"Please try again later";

// 11
NSString *const MineAlertViewTitleSignupRequestTimeout = @"Cannot sign up new user due to network issue";
NSString *const MineAlertViewMsgSignupRequestTimeout = @"Please try again later";

// 12
NSString *const MineAlertViewTitleAddTransactionRequestTimeout = @"Cannot add new transaction due to network issue";
NSString *const MineAlertViewMsgAddTransactionRequestTimeout = @"Please try again later";

// 101
NSString *const MineAlertViewTitleUserNotExist = @"User doesn't exist";
NSString *const MineAlertViewMsgUserNotExist = @"Please make sure your username is correct";

// 102
NSString *const MineAlertViewTitleWrongPasscode = @"Passcode is wrong";
NSString *const MineAlertViewMsgWrongPasscode = @"Please make sure your passcode is correct";