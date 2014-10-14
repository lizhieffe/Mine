//
//  MineYearViewController.m
//  Mine
//
//  Created by Zhi Li on 10/13/14.
//  Copyright (c) 2014 com.zhi.li. All rights reserved.
//

#import "MineYearViewController.h"
#import "MineTimeUtil.h"
#import "MineColorUtil.h"
#import "MineYearHistoryTableViewCell.h"
#import "MineYearHistoryCollectionViewCell.h"
#import "MinePreferenceService.h"
#import "MinePersistDataUtil.h"
#import "MineGetAllTransactionsService.h"
#import "MineLoginViewController.h"
#import "MineNewTransactionViewController.h"
#import "MineTransactionHistoryViewController.h"
#import "UITableView+Mine.h"

@interface MineYearViewController ()

@property (weak, nonatomic) IBOutlet UITableView *yearlyHistoryTable;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addNewTransactionBtn;

@property (assign, nonatomic) BOOL justLoaded;

@end

@implementation MineYearViewController

# pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.yearlyHistoryTable.delegate = self;
    self.yearlyHistoryTable.dataSource = self;
    
    _justLoaded = YES;
    
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
    service.ignoreCache = self.justLoaded;
    [service getAllTransactions];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.yearlyHistoryTable reloadData];
        
        /* go to the current year when loaded the first time */
        if (self.justLoaded) {
            [self.yearlyHistoryTable scrollToBottomAnimated:NO];
        }
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - helpers

- (void)presentLoginViewController
{
    UIViewController *loginViewController = [[MineLoginViewController alloc] init];
    [self.navigationController pushViewController:loginViewController animated:NO];
}

- (void)addNewTransactionBtnTapped {
    MineNewTransactionViewController *newTransactionViewController = [[MineNewTransactionViewController alloc] init];
    [self.navigationController pushViewController:newTransactionViewController animated:YES];
}

- (void)historyBtnTapped {
    MineTransactionHistoryViewController *historyViewController = [[MineTransactionHistoryViewController alloc] init];
    [self.navigationController pushViewController:historyViewController animated:YES];
}

- (void)getAllTransactionsDidSucceed:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.yearlyHistoryTable reloadData];
    });
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

# pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // display 10 years' transaction
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSInteger currentYear = [MineTimeUtil getCurrentYear];
    NSInteger num = [self numberOfSectionsInTableView:tableView];
    return [@(currentYear - num + section + 1) stringValue];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,  tableView.bounds.size.width, 40)];
    
    UILabel *labelHeader = [[UILabel alloc] initWithFrame:CGRectMake(10,5,320,30)];
    labelHeader.font = [UIFont fontWithName:@"Hiragino Kaku Gothic ProN" size:18];
    labelHeader.textColor = UIColorFromRGB(0xFF3300);
    labelHeader.textColor = [UIColor blackColor];
    
    [headerView addSubview:labelHeader];
                            
    [headerView setBackgroundColor:[UIColor whiteColor]];
    
    NSInteger currentYear = [MineTimeUtil getCurrentYear];
    NSInteger num = [self numberOfSectionsInTableView:tableView];
    labelHeader.text = [@(currentYear - num + section + 1) stringValue];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"yearHistoryTableViewCell";
    MineYearHistoryTableViewCell *cell = [self.yearlyHistoryTable dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[MineYearHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSInteger currentYear = [MineTimeUtil getCurrentYear];
    NSInteger num = [self numberOfSectionsInTableView:tableView];
    cell.year = currentYear - num + indexPath.section + 1;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 350;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(MineYearHistoryTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setTableViewContainerController:self];
    [cell setCollectionViewDataSourceDelegate:cell index:indexPath.row];

}
//
//#pragma mark - collection view data source
//
//- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView
//{
//    return 3;
//}
//
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
//{
//    return 4;
//}
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    MineYearHistoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:yearHistoryCollectionViewCellIdentifier forIndexPath:indexPath];
//    
//    NSInteger month = indexPath.row * 3 + indexPath.section + 1;
//    NSString *monthStr = [MineTimeUtil getShortMonthStr:month];
//    cell.monthLabel.text = monthStr;
//    
//    return cell;
//}
//
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(0, 3, 0, 3);
//}

@end
