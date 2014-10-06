//
//  MineLoginViewController.m
//  Mine
//
//  Created by Zhi Li on 7/25/14.
//  Copyright (c) 2014 com.zhi.li. All rights reserved.
//

#import "MineLoginViewController.h"
#import "MineMainViewController.h"
#import "MineAlertViewUtil.h"
#import "MineLoginService.h"
#import "MineUserInfo.h"
#import "MinePreferenceService.h"
#import "MineSignUpViewController.h"
#import "UIView+FindFirstResponder.h"

@interface MineLoginViewController ()

@property (nonatomic) BOOL keyboardOnScreen;
@property (nonatomic, assign) NSInteger keyboardHeight;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)loginBtnTapped:(id)sender;
- (IBAction)signUpBtnTapped:(id)sender;

@end

@implementation MineLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _keyboardOnScreen = NO;
    self.usernameTextField.delegate = self;
    self.passcodeTextField.delegate = self;
    
    [self updateLoginBtnWithStatus:NO];
    self.activityIndicatorView.hidden = YES;
    
    if([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    /**
     add guesture to dismiss keyboard
     */
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(responseToTapGesture:)];
    [self.view addGestureRecognizer:tapRecognizer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginDidSucceed:) name:MineNotificationLoginDidSucceed object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
}

- (IBAction)loginBtnTapped:(id)sender
{
    [self hideKeyboard];
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];

    /**
     start activity indicator view
     */
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self.activityIndicatorView];
    [self.activityIndicatorView.layer setBackgroundColor:[[UIColor colorWithWhite:0.0 alpha:0.30] CGColor]];
    [self.activityIndicatorView setFrame:self.view.frame];
    [self.activityIndicatorView startAnimating];
    self.activityIndicatorView.hidden = NO;
    
    /**
     start service
     */
    MineLoginService *service = [[MineLoginService alloc] init];
    [service loginWithUsername:self.usernameTextField.text passcode:self.passcodeTextField.text];
}

- (IBAction)signUpBtnTapped:(id)sender
{
    [self hideKeyboard];
    
    MineSignUpViewController *signUpViewController = [[MineSignUpViewController alloc] init];
    [self.navigationController pushViewController:signUpViewController animated:YES];
}

- (void)responseToTapGesture:(UITapGestureRecognizer *)recognizer
{
    [self hideKeyboard];
}

- (void)updateLoginBtnWithStatus:(BOOL)status
{
    if (!status) {
        self.loginButton.enabled = NO;
        [self.loginButton setBackgroundColor:[UIColor darkGrayColor]];
    }
    else {
        self.loginButton.enabled = YES;
        [self.loginButton setBackgroundColor:[UIColor blueColor]];
    }
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    _keyboardOnScreen = YES;
    
    NSDictionary *keyboardInfo = [notification userInfo];
    NSValue *keyboardFrameBegin = [keyboardInfo valueForKeyPath:UIKeyboardFrameBeginUserInfoKey];
    self.keyboardHeight = [keyboardFrameBegin CGRectValue].size.height;
    
    [self adjustScrollView];
}

- (void)keyboardDidHide:(NSNotification *)notification
{
    _keyboardOnScreen = NO;
    [self adjustScrollView];
}

- (void)adjustScrollView
{
    if (self.keyboardOnScreen == YES) {
        NSInteger maxOffsetInVerticalDirection = NSIntegerMax;
        UIView *activeTextField = [self.view findFirstResponder];
        
        maxOffsetInVerticalDirection = [activeTextField convertRect:activeTextField.bounds toView:activeTextField.superview].origin.y;
        if (self.navigationController && self.navigationController.navigationBar.hidden == NO) {
            UINavigationBar *bar = self.navigationController.navigationBar;
            
            maxOffsetInVerticalDirection = maxOffsetInVerticalDirection - [bar convertRect:bar.bounds toView:bar.superview].size.height - [bar convertRect:bar.bounds toView:bar.superview].origin.y - 60;
        }
        
        CGPoint offset = CGPointMake(0, maxOffsetInVerticalDirection < self.keyboardHeight ? maxOffsetInVerticalDirection : self.keyboardHeight);
        
        [self.scrollView setContentOffset:offset animated:YES];
    }
    else {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

- (void)hideKeyboard
{
    if (self.keyboardOnScreen) {
        [self.view endEditing:YES];
        self.keyboardOnScreen = NO;
    }
}

- (void)loginDidSucceed:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
        [self.activityIndicatorView stopAnimating];
        self.activityIndicatorView.hidden = YES;
        
        NSDictionary *errorJson = [notification.userInfo valueForKey:MineResponseKeyErrorJson];
        NSInteger errorCode = [[errorJson valueForKey:MineResponseKeyErrorCode] intValue];
        
        NSDictionary *responseJson = [notification.userInfo valueForKey:MineResponseKeyResponseJson];
        NSString *token = [responseJson valueForKey:MineResponseKeyResponseToken];
        
        if (errorCode == 0) {
            MineUserInfo *userInfo = [[MineUserInfo alloc] init];
            userInfo.username = self.usernameTextField.text;
            userInfo.passcode = self.passcodeTextField.text;
            [MinePreferenceService setCurrentUserInfo:userInfo];
            [MinePreferenceService setToken:token];
            
//            self.presentingViewController.view.hidden = NO;
//            [self dismissViewControllerAnimated:YES completion:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else
            [MineAlertViewUtil showAlertViewWithErrorCode:errorCode];
    });
}

#pragma mark - text field delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL loginBtnStatus;
    
    if (self.usernameTextField.text.length == 0 && self.passcodeTextField.text.length == 0)
        loginBtnStatus = NO;
    else if (self.usernameTextField.text.length == 0 && ![textField isEqual:self.usernameTextField])
        loginBtnStatus = NO;
    else if (self.passcodeTextField.text.length == 0 && ![textField isEqual:self.passcodeTextField])
        loginBtnStatus = NO;
    else if (textField.text.length == 1 && [string isEqualToString:@""])
        loginBtnStatus = NO;
    else
        loginBtnStatus = YES;
    [self updateLoginBtnWithStatus:loginBtnStatus];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self adjustScrollView];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    [self updateLoginBtnWithStatus:NO];
    
    return YES;
}

@end
