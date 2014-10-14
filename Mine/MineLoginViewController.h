//
//  MineLoginViewController.h
//  Mine
//
//  Created by Zhi Li on 7/25/14.
//  Copyright (c) 2014 com.zhi.li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineLoginViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passcodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;

@end
