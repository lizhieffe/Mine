//
//  MineNewTransactionViewController.m
//  Mine
//
//  Created by Zhi Li on 10/3/14.
//  Copyright (c) 2014 com.zhi.li. All rights reserved.
//

#import "MineNewTransactionViewController.h"
#import "MineTimeUtil.h"
#import "MineColorUtil.h"
#import "MineViewUtil.h"
#import "MineAddTransactionService.h"
#import "MinePreferenceService.h"
#import "MineTransactionItem.h"
#import "MineTransactionInfo.h"
#import "MineAlertViewUtil.h"
#import "MineGetAllTransactionsService.h"
#import "UIView+FindFirstResponder.h"

@interface MineNewTransactionViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIButton *monthBtn;
@property (weak, nonatomic) IBOutlet UIButton *dateBtn;
@property (weak, nonatomic) IBOutlet UIButton *yearBtn;
@property (weak, nonatomic) IBOutlet UITextField *dateBtnTextField;

@property (weak, nonatomic) IBOutlet UIButton *fiveDollarBtn;
@property (weak, nonatomic) IBOutlet UIButton *tenDollarBtn;
@property (weak, nonatomic) IBOutlet UIButton *twentyDollarBtn;
@property (weak, nonatomic) IBOutlet UIButton *fiftyDollarBtn;
@property (weak, nonatomic) IBOutlet UIButton *otherBtn;
@property (weak, nonatomic) IBOutlet UITextField *otherBtnTextField;

@property (weak, nonatomic) IBOutlet UIButton *positiveBtn;
@property (weak, nonatomic) IBOutlet UIButton *negativeBtn;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneBtn;
//@property (strong, nonatomic) UIBarButtonItem *doneBtn;

@property (weak, nonatomic) IBOutlet UILabel *amount;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@property (assign, nonatomic) NSInteger amountAbsValue;
@property (assign, nonatomic) BOOL isAmountPositive;
@property (strong, nonatomic) NSDate *date;

@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) UIPopoverController *popOverForDatePicker;

@property (nonatomic) BOOL keyboardOnScreen;
@property (nonatomic, assign) NSInteger keyboardHeight;

@end

@implementation MineNewTransactionViewController

- (id)init
{
    return [self initWithDate:[NSDate date]];
}

- (id)initWithDate:(NSDate *)date
{
    self = [super init];
    if (self) {
        _date = date;
        _keyboardOnScreen = NO;
    }
    return self;
}

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
    
    [self hideActivityIndicatorView];
    
    self.amountAbsValue = 0;
    self.isAmountPositive = NO;
    
    [self updateAmountLabel];
    [self updateOkBtn];
    
    [self updateDate];
    
    self.otherBtnTextField.tintColor = [UIColor clearColor];
    self.otherBtnTextField.delegate = self;
    
    self.datePicker = [[UIDatePicker alloc] init];
    [self.datePicker setDate:self.date];
    [self.datePicker addTarget:self action:@selector(datePickerValueChanged) forControlEvents:UIControlEventValueChanged];
    self.dateBtnTextField.tintColor = [UIColor clearColor];
    [self.dateBtnTextField setInputView:self.datePicker];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    
    self.doneBtn.target = self;
    self.doneBtn.action = @selector(okBtnTapped);
    self.navigationItem.rightBarButtonItem = self.doneBtn;

    
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    [self adjustScrollView];
    
    /**
     add guesture to dismiss keyboard
     */
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(responseToTapGesture:)];
    [self.view addGestureRecognizer:tapRecognizer];
    
    [self.monthBtn addTarget:self action:@selector(monthBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.dateBtn addTarget:self action:@selector(dateBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    
    [self.fiveDollarBtn addTarget:self action:@selector(fiveDollarBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.tenDollarBtn addTarget:self action:@selector(tenDollarBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.twentyDollarBtn addTarget:self action:@selector(twentyDollarBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.fiftyDollarBtn addTarget:self action:@selector(fiftyDollarBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.otherBtn addTarget:self action:@selector(otherBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.otherBtnTextField addTarget:self action:@selector(otherBtnTextFieldTapped) forControlEvents:UIControlEventTouchUpInside];
    
    [self.positiveBtn addTarget:self action:@selector(positiveBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.negativeBtn addTarget:self action:@selector(negativeBtnTapped) forControlEvents:UIControlEventTouchUpInside];

    /* notification */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addTransactionDidSucceed:) name:MineNotificationAddTransactionDidSucceed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
//    [self.scrollView setContentOffset:CGPointMake(0,0)];
}

- (void)datePickerValueChanged
{
    self.date = self.datePicker.date;
    [self updateDate];
}

- (void)updateAmountLabel
{
    if (self.amountAbsValue == 0)
        self.amount.text = [NSString stringWithFormat:@"%ld$", self.amountAbsValue];
    else {
        NSString *tmp = [NSString stringWithFormat:@"%ld$", self.amountAbsValue];
        if (self.isAmountPositive)
            self.amount.text = tmp;
        else
            self.amount.text = [NSString stringWithFormat:@"-%@", tmp];
    }
}

- (void)updateDate
{
    NSInteger month = [MineTimeUtil getMonth:self.date];
    NSInteger day = [MineTimeUtil getDay:self.date];
    NSInteger year = [MineTimeUtil getYear:self.date];
    
    [self.yearBtn setTitle:[@(year) stringValue] forState:UIControlStateNormal];
    
    NSString *monthStr = [MineTimeUtil getShortMonthStr:month];
    [self.monthBtn setTitle:monthStr forState:UIControlStateNormal];
    
    [self.dateBtn setTitle:[@(day) stringValue] forState:UIControlStateNormal];
}

- (void)updateOkBtn
{
    if (self.amountAbsValue == 0) {
//        [self.addBtn setBackgroundColor:[UIColor grayColor]];
        self.doneBtn.enabled = NO;
    }
    else {
//        [self.addBtn setBackgroundColor:UIColorFromRGB(0x00CC33)];
        self.doneBtn.enabled = YES;
    }
}

- (void)showActivityIndicatorView
{
    [MineViewUtil showActivityIndicatorView:self.activityIndicatorView inView:self.view];
}

- (void)hideActivityIndicatorView
{
    [MineViewUtil hideActivityIndicatorView:self.activityIndicatorView];
}

- (void)monthBtnTapped
{

}

- (void)dateBtnTapped
{
    [self monthBtnTapped];
}

- (void)fiveDollarBtnTapped
{
    self.amountAbsValue = 5;
    [self updateAmountLabel];
    [self updateOkBtn];
}

- (void)tenDollarBtnTapped
{
    self.amountAbsValue = 10;
    [self updateAmountLabel];
    [self updateOkBtn];
}

- (void)twentyDollarBtnTapped
{
    self.amountAbsValue = 20;
    [self updateAmountLabel];
    [self updateOkBtn];
}

- (void)fiftyDollarBtnTapped
{
    self.amountAbsValue = 50;
    [self updateAmountLabel];
    [self updateOkBtn];
}

- (void)otherBtnTapped
{
}

- (void)otherBtnTextFieldTapped
{
}

- (void)positiveBtnTapped
{
    self.isAmountPositive = YES;
    [self updateAmountLabel];
}

- (void)negativeBtnTapped
{
    self.isAmountPositive = NO;
    [self updateAmountLabel];
}

- (void)okBtnTapped
{
    [self hideKeyboard];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
//    [self showActivityIndicatorView];
    
    /**
     start service
     */
    NSInteger timestamp = [self.date timeIntervalSince1970];
    NSInteger price = self.isAmountPositive ? self.amountAbsValue : (-1) * self.amountAbsValue;
    
    MineAddTransactionService *service = [[MineAddTransactionService alloc] init];
    __weak MineNewTransactionViewController *weakself = self;
    service.connectionDelegate = weakself;
    [service addTransactionWithTimestamp:timestamp price:price];
}

- (void)cancelBtnTapped
{
//    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
//    [self removeFromParentViewController];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//    });
}

- (void)responseToTapGesture:(UITapGestureRecognizer *)recognizer
{
    [self hideKeyboard];
}

- (void)hideKeyboard
{
    [self.view endEditing:YES];
}

- (NSInteger)price
{
    return self.isAmountPositive ? self.amountAbsValue : (-1) * self.amountAbsValue;
}

# pragma mark - UI

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
            
            maxOffsetInVerticalDirection = maxOffsetInVerticalDirection - [bar convertRect:bar.bounds toView:bar.superview].size.height - [bar convertRect:bar.bounds toView:bar.superview].origin.y;
        }
        
        CGPoint offset = CGPointMake(0, (maxOffsetInVerticalDirection < (self.keyboardHeight) ? maxOffsetInVerticalDirection : (self.keyboardHeight)) - 100);
        
        [self.scrollView setContentOffset:offset animated:YES];
    }
    else {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

# pragma mark - NSNotification

- (void)addTransactionDidSucceed:(NSNotification *)notification
{
    NSDictionary *errorJson = [notification.userInfo valueForKey:MineResponseKeyErrorJson];
    NSInteger errorCode = [[errorJson valueForKey:MineResponseKeyErrorCode] intValue];
    
    if (errorCode == 0) {
        MineGetAllTransactionsService *service = [[MineGetAllTransactionsService alloc] init];
        service.ignoreCache = YES;
        [service getAllTransactions];

    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (errorCode == 0) {
            [self hideActivityIndicatorView];
            [self cancelBtnTapped];
        }
        else {
            [self hideActivityIndicatorView];
            [MineAlertViewUtil showAlertViewWithErrorCode:errorCode delegate:self];
        }
    });
}

# pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.otherBtnTextField) {
        int tmp = [self.otherBtnTextField.text intValue];
        if ([string isEqualToString:@""])
            self.amountAbsValue = tmp / 10;
        else {
            if (tmp > 99999)
                return NO;
            self.amountAbsValue = tmp * 10 + [string intValue];
        }
        
        [self updateAmountLabel];
        [self updateOkBtn];
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.otherBtnTextField) {
        self.otherBtnTextField.text = @"";
        self.amountAbsValue = 0;
    }
    [self updateOkBtn];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.amountAbsValue = 0;
    [self updateAmountLabel];
    [self updateOkBtn];
}

# pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [MineAlertViewUtil showAlertViewWithErrorCode:12 delegate:self];
}

@end
