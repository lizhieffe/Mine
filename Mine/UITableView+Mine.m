//
//  UITableView+Mine.m
//  Mine
//
//  Created by Zhi Li on 7/29/14.
//  Copyright (c) 2014 com.zhi.li. All rights reserved.
//

#import "UITableView+Mine.h"

@implementation UITableView (Mine)

- (void)scrollToTopAnimated:(BOOL)animated
{
    [self setContentOffset:CGPointZero animated:animated];
}

- (void)scrollToBottomAnimated:(BOOL)animated
{
    CGFloat height = self.contentSize.height - self.bounds.size.height;
    [self setContentOffset:CGPointMake(0, height) animated:animated];
}

@end
