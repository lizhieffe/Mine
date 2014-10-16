//
//  MineSettingsViewController.m
//  Mine
//
//  Created by Zhi Li on 10/16/14.
//  Copyright (c) 2014 com.zhi.li. All rights reserved.
//

#import "MineSettingsViewController.h"
#import "MinePreferenceService.h"
#import "MineLoginViewController.h"
#import "MineTransactionInfo.h"

@interface MineSettingsViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *logoutBtn;

@end

@implementation MineSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.logoutBtn.target = self;
    self.logoutBtn.action = @selector(logoutBtnTapped);
}

- (void)logoutBtnTapped
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    [MinePreferenceService cleanCurrentUserInfo];
    [[MineTransactionInfo sharedManager] clearTransactions];
    
    [self presentLoginViewController];
}

- (void)presentLoginViewController
{
//    UIViewController *loginViewController = [[MineLoginViewController alloc] init];
//    [self.navigationController pushViewController:loginViewController animated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:MineNotificationShowLoginView object:nil];
}

@end
