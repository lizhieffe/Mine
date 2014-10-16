//
//  MineViewUtil.m
//  Mine
//
//  Created by Zhi Li on 10/5/14.
//  Copyright (c) 2014 com.zhi.li. All rights reserved.
//

#import "MineViewUtil.h"

@implementation MineViewUtil

+ (void)showActivityIndicatorView:(UIActivityIndicatorView *)activityIndicatorView inView:(UIView *)view
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![[UIApplication sharedApplication] isIgnoringInteractionEvents])
            [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:activityIndicatorView];
        [activityIndicatorView.layer setBackgroundColor:[[UIColor colorWithWhite:0.0 alpha:0.30] CGColor]];
        [activityIndicatorView setFrame:view.frame];
        [activityIndicatorView startAnimating];
        activityIndicatorView.hidden = NO;
    });
}

+ (void)hideActivityIndicatorView:(UIActivityIndicatorView *)activityIndicatorView
{
    if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    [activityIndicatorView stopAnimating];
    activityIndicatorView.hidden = YES;
}

@end
