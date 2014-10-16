//
//  MineViewUtil.h
//  Mine
//
//  Created by Zhi Li on 10/5/14.
//  Copyright (c) 2014 com.zhi.li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MineViewUtil : NSObject

+ (void)showActivityIndicatorView:(UIActivityIndicatorView *)activityIndicatorView inView:(UIView *)view;
+ (void)hideActivityIndicatorView:(UIActivityIndicatorView *)activityIndicatorView;

+ (void)presentMonthViewControllerFormViewController:(UIViewController *)from year:(NSInteger)year month:(NSInteger)month;

@end
