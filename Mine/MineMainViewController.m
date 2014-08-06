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

@interface MineMainViewController ()

@property (strong, nonatomic) UIViewController *upViewController;
@property (strong, nonatomic) UIViewController *downViewController;

@property (assign, nonatomic) BOOL downViewInScreen;
@property (assign, nonatomic) BOOL upViewInScreen;

@property (weak, nonatomic) IBOutlet UIButton *addNewTransactionBtn;

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
    
    /**
     display the login view controller first if there is no user logged in
     */
    if (![MinePreferenceService currentUserInfo]) {
        [self presentLoginViewController];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self addUpViewController];
    [self addDownViewController];
}

- (void)addUpViewController
{
    _upViewInScreen = NO;
}

- (void)addDownViewController
{
    UISwipeGestureRecognizer *swipeUpGusturRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeUpFrom:)];
    swipeUpGusturRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeUpGusturRecognizer];
    
    UIViewController <MineSideViewProtocal> *rootViewController = [[MineCreateTransactionItemsViewController alloc] init];
    [rootViewController setCenterViewController:self];
    UIViewController *child = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    
    CGRect newFrame = CGRectMake(0, child.view.frame.size.height, child.view.frame.size.width, child.view.frame.size.height);
    child.view.frame = newFrame;
    
    _downViewController = child;
    
    [self addSubController:child];
    _downViewInScreen = NO;
}

- (void)addSubController:(UIViewController *)child
{
    if (child && !child.parentViewController) {
        [self addChildViewController:child];
        child.view.opaque = YES;
        [self.view addSubview:child.view];
        [self.view sendSubviewToBack:child.view];
        [child didMoveToParentViewController:self];
    }
}

- (void)showDownView
{
    [self.view bringSubviewToFront:self.downViewController.view];
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.downViewController.view.frame = [[UIScreen mainScreen] bounds];
                     }
                     completion:^(BOOL finished) {
                         self.downViewInScreen = YES;
                     }];
}

- (void)hideDownView
{
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.downViewController.view.frame = [self downViewFrame];
                     }
                     completion:^(BOOL finished) {
                         [self.view sendSubviewToBack:self.downViewController.view];
                         self.downViewInScreen = NO;
                         [[NSNotificationCenter defaultCenter] postNotificationName:MineNotificationDownViewDidHide object:self];
                     }];
}

- (void)showUpView
{
    
}

- (void)hideUpView
{
    
}

- (CGRect)downViewFrame
{
    return CGRectMake(0, [[UIScreen mainScreen] bounds].size.height, self.downViewController.view.frame.size.width, self.downViewController.view.frame.size.height);
}

- (void)handleSwipeUpFrom:(UIGestureRecognizer *)recognizer
{
    if (!self.upViewInScreen && !self.downViewInScreen)
        [self showDownView];
    else if (self.upViewInScreen && !self.downViewInScreen)
        [self hideUpView];
}

- (void)presentLoginViewController
{
    self.view.hidden = YES;
    UIViewController *loginViewController = [[MineLoginViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    [navigationController setNavigationBarHidden:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:navigationController animated:NO completion:nil];
    });
}


@end
