//
//  UITextField+Mine.m
//  Mine
//
//  Created by Zhi Li on 10/13/14.
//  Copyright (c) 2014 com.zhi.li. All rights reserved.
//

#import "UITextField+Mine.h"

@implementation UITextField (Mine)

- (void)addPaddingOnTheLeftSideWithSize:(NSInteger)size
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size, self.frame.size.height)];
    self.leftView = paddingView;
    self.leftViewMode = UITextFieldViewModeAlways;
}

@end
