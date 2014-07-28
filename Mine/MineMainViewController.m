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

@property (weak, nonatomic) IBOutlet UIButton *addNewTransactionBtn;
- (IBAction)addNewTransactionBtnTapped:(id)sender;

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

- (IBAction)addNewTransactionBtnTapped:(id)sender {
    UIViewController *createTransactionItemsViewController = [[MineCreateTransactionItemsViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:createTransactionItemsViewController];
    [navigationController setNavigationBarHidden:YES];
    
    [self presentViewController:navigationController animated:NO completion:nil];
}

@end
