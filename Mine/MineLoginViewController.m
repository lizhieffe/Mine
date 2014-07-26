//
//  MineLoginViewController.m
//  Mine
//
//  Created by Zhi Li on 7/25/14.
//  Copyright (c) 2014 com.zhi.li. All rights reserved.
//

#import "MineLoginViewController.h"
#import "MineMainViewController.h"

@interface MineLoginViewController ()

@property (nonatomic) BOOL keyboardOnScreen;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)loginBtnTapped:(id)sender;

@end

@implementation MineLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _keyboardOnScreen = NO;
    self.usernameTextField.delegate = self;
    self.passwordTextField.delegate = self;
    
    [self updateLoginBtn:NO];
    self.activityIndicatorView.hidden = YES;
    
    /**
     add guesture to dismiss keyboard
     */
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(responseToTapGesture:)];
    [self.view addGestureRecognizer:tapRecognizer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginDidSucceed:) name:MineNotificationLoginDidSucceed object:nil];
}

- (IBAction)loginBtnTapped:(id)sender
{
    [self hideKeyboard];
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];

    /**
     start activity indicator view
     */
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self.activityIndicatorView];
    [self.activityIndicatorView.layer setBackgroundColor:[[UIColor colorWithWhite: 0.0 alpha:0.30] CGColor]];
    [self.activityIndicatorView setFrame:self.view.frame];
    [self.activityIndicatorView startAnimating];
    self.activityIndicatorView.hidden = NO;
    
}

- (void)responseToTapGesture:(UITapGestureRecognizer *)recognizer
{
    [self hideKeyboard];
}

- (void)updateLoginBtn:(BOOL)status
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
    CGPoint offset = CGPointMake(0, [keyboardFrameBegin CGRectValue].size.height);
    
    [self.scrollView setContentOffset:offset animated:YES];
}

- (void)keyboardDidHide:(NSNotification *)notification
{
    _keyboardOnScreen = NO;
    
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
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
    /**
     display the main view controller
     */
    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIViewController *rootViewController = [[MineMainViewController alloc] init];
    window.rootViewController = rootViewController;
    [window makeKeyAndVisible];
}

#pragma mark - text field delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL loginBtnStatus;
    
    if (self.usernameTextField.text.length == 0 && self.passwordTextField.text.length == 0)
        loginBtnStatus = NO;
    else if (self.usernameTextField.text.length == 0 && ![textField isEqual:self.usernameTextField])
        loginBtnStatus = NO;
    else if (self.passwordTextField.text.length == 0 && ![textField isEqual:self.passwordTextField])
        loginBtnStatus = NO;
    else if (textField.text.length == 1 && [string isEqualToString:@""])
        loginBtnStatus = NO;
    else
        loginBtnStatus = YES;
    [self updateLoginBtn:loginBtnStatus];
    
    return YES;
}

@end
