//
//  MineAlertViewUtil.m
//  Mine
//
//  Created by Zhi Li on 7/27/14.
//  Copyright (c) 2014 com.zhi.li. All rights reserved.
//

#import "MineAlertViewUtil.h"

@implementation MineAlertViewUtil

+ (void)showAlertViewWithErrorCode:(NSInteger)errorCode delegate:(id)delegate
{
    NSString *title = [MineAlertViewUtil titleForErrorCode:errorCode];
    NSString *msg = [MineAlertViewUtil msgForErrorCode:errorCode];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:delegate cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
}

+ (NSString *)titleForErrorCode:(NSInteger)errorCode
{
    if (errorCode == 0)
        return @"";
    else if (errorCode == 1)
        return MineAlertViewTitleGeneralError;
    else if (errorCode == 9)
        return MineAlertViewTitleInternetNotAvailable;
    else if (errorCode == 10)
        return MineAlertViewTitleLoginRequestTimeout;
    else if (errorCode == 11)
        return MineAlertViewTitleSignupRequestTimeout;
    else if (errorCode == 12)
        return MineAlertViewTitleAddTransactionRequestTimeout;
    else if (errorCode == 101)
        return MineAlertViewTitleUserNotExist;
    else if (errorCode == 102)
        return MineAlertViewTitleWrongPasscode;
    else
        return @"";
}

+ (NSString *)msgForErrorCode:(NSInteger)errorCode
{
    if (errorCode == 0)
        return @"";
    else if (errorCode == 1)
        return MineAlertViewMsgGeneralError;
    else if (errorCode == 9)
        return MineAlertViewMsgInternetNotAvailable;
    else if (errorCode == 10)
        return MineAlertViewMsgLoginRequestTimeout;
    else if (errorCode == 11)
        return MineAlertViewMsgSignupRequestTimeout;
    else if (errorCode == 12)
        return MineAlertViewMsgAddTransactionRequestTimeout;
    else if (errorCode == 101)
        return MineAlertViewMsgUserNotExist;
    else if (errorCode == 102)
        return MineAlertViewMsgWrongPasscode;
    else
        return @"";
}


@end
