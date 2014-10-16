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
#import "MineMonthViewController.h"
#import "UITableView+Mine.h"
#import "MineHistogramViewController.h"
#import "MineTransactionInfo.h"
#import "MineSettingsViewController.h"
#import "MineViewUtil.h"

@interface MineYearViewController ()

@property (weak, nonatomic) IBOutlet UITableView *yearlyHistoryTable;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *histogramBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *todayBtn;
@property (strong, nonatomic) IBOutlet UIView *infoIconView;

@property (strong, nonatomic) UIBarButtonItem *addBtn;
@property (strong, nonatomic) UIBarButtonItem *settingBtn;

@property (assign, nonatomic) BOOL justLoaded;

@end

@implementation MineYearViewController

# pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // navigation bar item color
    self.navigationController.navigationBar.tintColor = UIColorFromRGB(0xFF3300);
    
    // navigation bar title font and color
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Hiragino Kaku Gothic ProN" size:17], NSFontAttributeName, UIColorFromRGB(0xFF3300), NSForegroundColorAttributeName, nil]];
    
    self.addBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addBtnTapped)];
    self.settingBtn = [[UIBarButtonItem alloc] initWithCustomView:self.infoIconView];
    
    NSMutableArray *rightBtns = [[NSMutableArray alloc] init];
    [rightBtns addObject:self.addBtn];
    [rightBtns addObject:self.settingBtn];
    [self.navigationItem setRightBarButtonItems:rightBtns];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(settingBtnTapped)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [self.settingBtn.customView addGestureRecognizer:singleTap];
    [self.settingBtn.customView setUserInteractionEnabled:YES];
    
    self.histogramBtn.target = self;
    self.histogramBtn.action = @selector(histogramBtnTapped);
    
    self.todayBtn.target = self;
    self.todayBtn.action = @selector(todayBtnTapped);
    
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
    
    /* notification */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAllTransactionsDidSucceed:) name:MineNotificationGetAllTransactionsDidSucceed object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentLoginViewController) name:MineNotificationShowLoginView object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (![MinePreferenceService isUserLoggedIn]) {
        [MinePreferenceService cleanCurrentUserInfo];
        [self presentLoginViewController];
    }
    else {
        [self.navigationController setNavigationBarHidden:NO];

        MineGetAllTransactionsService *service = [[MineGetAllTransactionsService alloc] init];
        service.ignoreCache = self.justLoaded;
        [service getAllTransactions];
    
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.yearlyHistoryTable reloadData];
        
            /* go to the current year when loaded the first time */
            if (self.justLoaded) {
                [self.yearlyHistoryTable scrollToBottomAnimated:NO];
                self.justLoaded = NO;
            }
        });
    }
}

# pragma mark - helpers

- (void)presentLoginViewController
{
    UIViewController *loginViewController = [[MineLoginViewController alloc] init];
    [self.navigationController pushViewController:loginViewController animated:NO];
}

- (void)addBtnTapped {
    NSInteger year = [self getYearOfMostVisibleCell];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[@(year) stringValue] style:UIBarButtonItemStylePlain target:nil action:nil];
    
    NSInteger month = [MineTimeUtil getCurrentMonth];
    NSInteger day = [MineTimeUtil getCurrentDay];
    NSDate *date = [MineTimeUtil getDateForYear:year month:month day:day];
    
    MineNewTransactionViewController *newTransactionViewController = [[MineNewTransactionViewController alloc] initWithDate:date];
    [self.navigationController pushViewController:newTransactionViewController animated:YES];
}

- (void)settingBtnTapped
{
    NSInteger year = [self getYearOfMostVisibleCell];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[@(year) stringValue] style:UIBarButtonItemStylePlain target:nil action:nil];

    UIViewController *controller = [[MineSettingsViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)histogramBtnTapped {
    NSInteger year = [self getYearOfMostVisibleCell];
    
    // set navigation bar back btn title
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[@(year) stringValue] style:UIBarButtonItemStylePlain target:nil action:nil];

    NSMutableArray *months = [[NSMutableArray alloc] init];
    for (int i = 0; i < 12; i ++)
         [months addObject:[MineTimeUtil getShortMonthStr:(i + 1)]];
    NSArray *incomeArray = [[MineTransactionInfo sharedManager] getIncomeForYear:year];
    NSArray *outcomeArray = [[MineTransactionInfo sharedManager] getAbsOutcomeForYear:year];
    
    MineHistogramViewController *histogramViewController = [[MineHistogramViewController alloc] initWithXLabelArray:months incomeArray:incomeArray outcomeArray:outcomeArray];
    histogramViewController.year = year;
    [self.navigationController pushViewController:histogramViewController animated:YES];
}

- (void)todayBtnTapped
{
    [self.yearlyHistoryTable scrollToBottomAnimated:NO];
    [MineViewUtil presentMonthViewControllerFormViewController:self year:[MineTimeUtil getCurrentYear] month:[MineTimeUtil getCurrentMonth]];
}

- (void)getAllTransactionsDidSucceed:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.yearlyHistoryTable reloadData];
    });
}

- (NSIndexPath *)getIndexpathOfMostVisibleCell
{
    NSArray *visibleCells = [self.yearlyHistoryTable indexPathsForVisibleRows];
    if ([visibleCells count] == 1)
        return [visibleCells objectAtIndex:0];
    
    CGFloat offset = self.yearlyHistoryTable.contentOffset.y;
    
    CGRect rectOfCellInTableView_0 = [self.yearlyHistoryTable rectForRowAtIndexPath:[visibleCells objectAtIndex:0]];
    
    if (rectOfCellInTableView_0.origin.y >= offset)
        return [visibleCells objectAtIndex:0];
    
    CGRect rectOfCellInTableView_1 = [self.yearlyHistoryTable rectForRowAtIndexPath:[visibleCells objectAtIndex:1]];
    if (rectOfCellInTableView_1.origin.y - offset > ([[UIScreen mainScreen] bounds].size.height / 2))
        return [visibleCells objectAtIndex:0];
    
    return [visibleCells objectAtIndex:1];
}

- (NSInteger)getYearOfMostVisibleCell
{
    CGFloat offset = self.yearlyHistoryTable.contentOffset.y;
    NSInteger sectionHeight = [self tableView:self.yearlyHistoryTable heightForHeaderInSection:0] + [self tableView:self.yearlyHistoryTable heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    int section;
    if ((NSInteger)offset % sectionHeight > sectionHeight / 2)
        section = offset / sectionHeight + 1;
    else
        section = offset / sectionHeight;
    
    NSInteger currentYear = [MineTimeUtil getCurrentYear];
    NSInteger num = [self numberOfSectionsInTableView:self.yearlyHistoryTable];
    
    return currentYear - num + section + 1;
}

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

@end
