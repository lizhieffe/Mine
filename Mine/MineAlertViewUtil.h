//
//  MineAlertViewUtil.h
//  Mine
//
//  Created by Zhi Li on 7/27/14.
//  Copyright (c) 2014 com.zhi.li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MineAlertViewUtil : NSObject

+ (void)showAlertViewWithErrorCode:(NSInteger)errorCode delegate:(id)delegate;
+ (NSString *)titleForErrorCode:(NSInteger)errorCode;
+ (NSString *)msgForErrorCode:(NSInteger)errorCode;

@end
