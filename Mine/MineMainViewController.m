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
    
    [self setUpViewController];
    [self setDownViewController];
}

- (void)setUpViewController
{
    
}

- (void)setDownViewController
{
    UISwipeGestureRecognizer *swipeUpGusturRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeUpFrom:)];
    swipeUpGusturRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeUpGusturRecognizer];
    
    UIViewController *child = [[MineCreateTransactionItemsViewController alloc] init];
    [self addSubController:child];
    
    _downViewController = child;
}

- (void)addSubController:(UIViewController *)child
{
    if (child && !child.parentViewController) {
        [self addChildViewController:child];
        [self.view addSubview:child.view];
        [self.view sendSubviewToBack:child.view];
        [child didMoveToParentViewController:self];
        
        CGRect newFrame = CGRectMake(0, 568, child.view.frame.size.width, child.view.frame.size.height);
        child.view.frame = newFrame;
    }
}

- (void)handleSwipeUpFrom:(UIGestureRecognizer *)recognizer
{
    [UIView animateWithDuration:2
                     animations:^{
                         self.downViewController.view.frame = [[UIApplication sharedApplication] keyWindow].frame;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
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
