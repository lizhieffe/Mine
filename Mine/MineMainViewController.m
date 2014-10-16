//
//  MineMainViewController.m
//  Mine
//
//  Created by Zhi Li on 7/26/14.
//  Copyright (c) 2014 com.zhi.li. All rights reserved.
//

#import "MineMainViewController.h"
#import "MineLoginViewController.h"
#import "MinePreferenceService.h"
#import "MineCreateTransactionItemsViewController.h"
#import "MineNewTransactionViewController.h"
#import "MineMonthViewController.h"
#import "MineTransactionInfo.h"
#import "MinePersistDataUtil.h"
#import "MineGetAllTransactionsService.h"
#import "MineHistogramViewController.h"

@interface MineMainViewController ()

//@property (strong, nonatomic) UIViewController *upViewController;
//@property (strong, nonatomic) UIViewController *downViewController;
//
//@property (assign, nonatomic) BOOL downViewInScreen;
//@property (assign, nonatomic) BOOL upViewInScreen;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *addNewTransactionBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *historyBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *peekBtn;
@property (weak, nonatomic) IBOutlet UILabel *income;
@property (weak, nonatomic) IBOutlet UILabel *expense;

@property (weak, nonatomic) IBOutlet UILabel *incomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *expenseLabel;

@end

@implementation MineMainViewController

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
    
//    self.navigationController.navigationBar.hidden = YES;
    
    /**
     display the login view controller first if there is no user logged in
     */
    if (![MinePreferenceService isUserLoggedIn]) {
        [MinePreferenceService cleanCurrentUserInfo];
        [self presentLoginViewController];
    }
    else {
        /**
         restart app after log in
         */
        if (![MinePreferenceService token]) {
            [MinePreferenceService setToken:[MinePersistDataUtil objectForKey:@"token"]];
            
        }
    }
    
    self.addNewTransactionBtn.target = self;
    self.addNewTransactionBtn.action = @selector(addNewTransactionBtnTapped);
    
//    self.historyBtn.target = self;
//    self.historyBtn.action = @selector(historyBtnTapped);
    
    /* notification */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAllTransactionsDidSucceed:) name:MineNotificationGetAllTransactionsDidSucceed object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    MineGetAllTransactionsService *service = [[MineGetAllTransactionsService alloc] init];
    [service getAllTransactions];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateIncomeLabel];
        [self updateExpenseLabel];
    });
}

- (void)updateIncomeLabel
{
    NSInteger month = [[MinePreferenceService sharedManager] displayMonth];
    NSInteger year = [[MinePreferenceService sharedManager] displayYear];
    NSInteger amount = [[MineTransactionInfo sharedManager] getIncomeForYear:year month:month];
    self.incomeLabel.text = [NSString stringWithFormat:@"%ld$", amount];
}

- (void)updateExpenseLabel
{
    NSInteger month = [[MinePreferenceService sharedManager] displayMonth];
    NSInteger year = [[MinePreferenceService sharedManager] displayYear];
    NSInteger amount = [[MineTransactionInfo sharedManager] getOutcomeForYear:year month:month];
    self.expenseLabel.text = [NSString stringWithFormat:@"%ld$", amount];
}

- (void)presentLoginViewController
{
    UIViewController *loginViewController = [[MineLoginViewController alloc] init];
    [self.navigationController pushViewController:loginViewController animated:NO];
}

- (void)addNewTransactionBtnTapped {
    MineNewTransactionViewController *newTransactionViewController = [[MineNewTransactionViewController alloc] init];
    [self.navigationController pushViewController:newTransactionViewController animated:YES];
}


- (void)histogramBtnTapped {
    MineMonthViewController *historyViewController = [[MineMonthViewController alloc] init];
    [self.navigationController pushViewController:historyViewController animated:YES];
}

- (void)getAllTransactionsDidSucceed:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateIncomeLabel];
        [self updateExpenseLabel];
    });
}

//
//- (void)addUpViewController
//{
//    _upViewInScreen = NO;
//}
//
//- (void)addDownViewController
//{
//    UISwipeGestureRecognizer *swipeUpGusturRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeUpFrom:)];
//    swipeUpGusturRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
//    [self.view addGestureRecognizer:swipeUpGusturRecognizer];
//    
//    UIViewController <MineSideViewProtocal> *rootViewController = [[MineCreateTransactionItemsViewController alloc] init];
//    [rootViewController setCenterViewController:self];
//    UIViewController *child = [[UINavigationController alloc] initWithRootViewController:rootViewController];
//    
//    CGRect newFrame = CGRectMake(0, child.view.frame.size.height, child.view.frame.size.width, child.view.frame.size.height);
//    child.view.frame = newFrame;
//    
//    _downViewController = child;
//    
//    [self addSubController:child];
//    _downViewInScreen = NO;
//}
//
//- (void)addSubController:(UIViewController *)child
//{
//    if (child && !child.parentViewController) {
//        [self addChildViewController:child];
//        child.view.opaque = YES;
//        [self.view addSubview:child.view];
//        [self.view sendSubviewToBack:child.view];
//        [child didMoveToParentViewController:self];
//    }
//}
//
//- (void)showDownView
//{
//    [self.view bringSubviewToFront:self.downViewController.view];
//    [UIView animateWithDuration:0.5
//                     animations:^{
//                         self.downViewController.view.frame = [[UIScreen mainScreen] bounds];
//                     }
//                     completion:^(BOOL finished) {
//                         self.downViewInScreen = YES;
//                     }];
//}
//
//- (void)hideDownView
//{
//    [UIView animateWithDuration:0.5
//                     animations:^{
//                         self.downViewController.view.frame = [self downViewFrame];
//                     }
//                     completion:^(BOOL finished) {
//                         [self.view sendSubviewToBack:self.downViewController.view];
//                         self.downViewInScreen = NO;
//                         [[NSNotificationCenter defaultCenter] postNotificationName:MineNotificationDownViewDidHide object:self];
//                     }];
//}
//
//- (void)showUpView
//{
//    
//}
//
//- (void)hideUpView
//{
//    
//}
//
//- (CGRect)downViewFrame
//{
//    return CGRectMake(0, [[UIScreen mainScreen] bounds].size.height, self.downViewController.view.frame.size.width, self.downViewController.view.frame.size.height);
//}
//
//- (void)handleSwipeUpFrom:(UIGestureRecognizer *)recognizer
//{
//    if (!self.upViewInScreen && !self.downViewInScreen)
//        [self showDownView];
//    else if (self.upViewInScreen && !self.downViewInScreen)
//        [self hideUpView];
//}
//



@end
