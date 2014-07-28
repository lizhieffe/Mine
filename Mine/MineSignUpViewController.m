//
//  MineSignUpViewController.m
//  Mine
//
//  Created by Zhi Li on 7/27/14.
//  Copyright (c) 2014 com.zhi.li. All rights reserved.
//

#import "MineSignUpViewController.h"
#import "MineSignUpService.h"
#import "MineUserInfo.h"
#import "MinePreferenceService.h"
#import "MineAlertViewUtil.h"
#import "UIView+FindFirstResponder.h"

@interface MineSignUpViewController ()

@property (nonatomic, assign) BOOL keyboardOnScreen;
@property (nonatomic, assign) NSInteger keyboardHeight;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passcodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *firstnameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastnameTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSegmentedPicker;
@property (weak, nonatomic) IBOutlet UIButton *signUpBtn;

- (IBAction)signUpBtnTapped:(id)sender;

@end

@implementation MineSignUpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.navigationController setNavigationBarHidden:NO];
    [self updateLoginBtnWithStatus:NO];
    self.activityIndicatorView.hidden = YES;
    
    self.keyboardOnScreen = NO;
    
    self.usernameTextField.delegate = self;
    self.passcodeTextField.delegate = self;
    self.firstnameTextField.delegate = self;
    self.lastnameTextField.delegate = self;
    
    /**
     add guesture to dismiss keyboard
     */
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(responseToTapGesture:)];
    [self.view addGestureRecognizer:tapRecognizer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginDidSucceed:) name:MineNotificationSignUpDidSucceed object:nil];
}

- (void)responseToTapGesture:(UITapGestureRecognizer *)recognizer
{
    [self hideKeyboard];
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    _keyboardOnScreen = YES;
    
    NSDictionary *keyboardInfo = [notification userInfo];
    NSValue *keyboardFrameBegin = [keyboardInfo valueForKeyPath:UIKeyboardFrameBeginUserInfoKey];
    self.keyboardHeight = [keyboardFrameBegin CGRectValue].size.height;
    
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

- (void)keyboardDidHide:(NSNotification *)notification
{
    _keyboardOnScreen = NO;
    [self adjustScrollView];
}

- (void)hideKeyboard
{
    if (self.keyboardOnScreen) {
        [self.view endEditing:YES];
        self.keyboardOnScreen = NO;
    }
}

- (void)updateLoginBtnWithStatus:(BOOL)status
{
    if (!status) {
        self.signUpBtn.enabled = NO;
        [self.signUpBtn setBackgroundColor:[UIColor darkGrayColor]];
    }
    else {
        self.signUpBtn.enabled = YES;
        [self.signUpBtn setBackgroundColor:[UIColor blueColor]];
    }
}

- (IBAction)signUpBtnTapped:(id)sender
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
    MineGenderType gender = [self getGenderFromUI];
    MineSignUpService *service = [[MineSignUpService alloc] init];
    [service signUpWithUsername:self.usernameTextField.text passcode:self.passcodeTextField.text firstname:self.firstnameTextField.text lastname:self.lastnameTextField.text gender:gender];
}

- (void)loginDidSucceed:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
        [self.activityIndicatorView stopAnimating];
        self.activityIndicatorView.hidden = YES;
        
        NSDictionary *errorJson = [notification.userInfo valueForKey:MineResponseKeyErrorJson];
        NSInteger errorCode = [[errorJson valueForKey:MineResponseKeyErrorCode] intValue];
        
        if (errorCode == 0) {
            MineUserInfo *userInfo = [[MineUserInfo alloc] init];
            userInfo.username = self.usernameTextField.text;
            userInfo.passcode = self.passcodeTextField.text;
            userInfo.firstName = self.firstnameTextField.text;
            userInfo.lastName = self.lastnameTextField.text;
            userInfo.gender = [self getGenderFromUI];
            [MinePreferenceService setCurrentUserInfo:userInfo];
            
            self.presentingViewController.view.hidden = NO;
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else
            [MineAlertViewUtil showAlertViewWithErrorCode:errorCode];
    });
}

- (MineGenderType)getGenderFromUI
{
    return self.genderSegmentedPicker.selectedSegmentIndex == 0 ? GenderTypeMale : GenderTypeFemale;
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
    else if (self.firstnameTextField.text.length == 0 && ![textField isEqual:self.firstnameTextField])
        loginBtnStatus = NO;
    else if (self.lastnameTextField.text.length == 0 && ![textField isEqual:self.lastnameTextField])
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

@end
