//
//  MineConstant.h
//  Mine
//
//  Created by Zhi Li on 7/26/14.
//  Copyright (c) 2014 com.zhi.li. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - notification name -

extern NSString *const MineNotificationLoginDidSucceed;
extern NSString *const MineNotificationSignUpDidSucceed;
extern NSString *const MineNotificationAddTransactionDidSucceed;
extern NSString *const MineNotificationGetAllTransactionsDidSucceed;
extern NSString *const MineNotificationDownViewDidHide;

#pragma mark - request parameter -

extern NSString *const MineRequestParameterUsername;
extern NSString *const MineRequestParameterPasscode;
extern NSString *const MineRequestParameterFirstname;
extern NSString *const MineRequestParameterLastname;
extern NSString *const MineRequestParameterGender;
extern NSString *const MineRequestParameterToken;
extern NSString *const MineRequestParameterTimestamp;
extern NSString *const MineRequestParameterPrice;

#pragma mark - response key -

extern NSString *const MineResponseKeyErrorJson;
extern NSString *const MineResponseKeyErrorCode;
extern NSString *const MineResponseKeyErrorMsg;

extern NSString *const MineResponseKeyResponseJson;
extern NSString *const MineResponseKeyResponseToken;
extern NSString *const MineResponseKeyResponseTransactions;

#pragma mark - alert view title and body msg -

extern NSString *const MineAlertViewTitleGeneralError;
extern NSString *const MineAlertViewMsgGeneralError;

extern NSString *const MineAlertViewTitleUserNotExist;
extern NSString *const MineAlertViewMsgUserNotExist;

extern NSString *const MineAlertViewTitleWrongPasscode;
extern NSString *const MineAlertViewMsgWrongPasscode;

