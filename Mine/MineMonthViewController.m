//
//  MineTransactionHistoryViewController.m
//  Mine
//
//  Created by Zhi Li on 10/4/14.
//  Copyright (c) 2014 com.zhi.li. All rights reserved.
//

#import "MineMonthViewController.h"
#import "MineTransactionInfo.h"
#import "MinePreferenceService.h"
#import "MineTimeUtil.h"
#import "MineTransactionHistoryTableViewCell.h"
#import "MineTransactionItem.h"
#import "MineDeleteTransactionService.h"
#import "MineAlertViewUtil.h"
#import "MineNewTransactionViewController.h"
#import "MineHistogramViewController.h"

@interface MineMonthViewController ()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *incomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *expenseLabel;

@property (weak, nonatomic) IBOutlet UITableView *historyTableView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *addNewTransactionBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *histogramBtn;

@property (assign, nonatomic) NSInteger year;
@property (assign, nonatomic) NSInteger month;

@property (strong, nonatomic) NSIndexPath *indexPathToDelete;

@end

@implementation MineMonthViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initForYear:(NSInteger)year month:(NSInteger)month
{
    self = [super init];
    if (self) {
        self.year = year;
        self.month = month;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self updateDateLabel];
    [self updateIncomeLabel];
    [self updateExpenseLabel];
    
    self.addNewTransactionBtn.target = self;
    self.addNewTransactionBtn.action = @selector(addNewTransactionBtnTapped);
    
    self.histogramBtn.target = self;
    self.histogramBtn.action = @selector(histogramBtnTapped);
    
    // table view cell
    [self.historyTableView registerNib:[UINib nibWithNibName:@"MineTransactionHistoryTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyCustomCell"];
    
    self.historyTableView.delegate = self;
    self.historyTableView.dataSource = self;
    
    /* notification */
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAllTransactionsDidSucceed:) name:MineNotificationGetAllTransactionsDidSucceed object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteTransactionDidSucceed:) name:MineNotificationDeleteTransactionDidSucceed object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateDateLabel
{
    NSString *monthStr = [MineTimeUtil getMonthStr:self.month];
    self.dateLabel.text = [NSString stringWithFormat:@"%@ %ld", monthStr, (long)self.year];
}

- (void)updateIncomeLabel
{
    NSInteger amount = [[MineTransactionInfo sharedManager] getIncomeForYear:self.year month:self.month];
    self.incomeLabel.text = [NSString stringWithFormat:@"%ld$", amount];
}

- (void)updateExpenseLabel
{
    NSInteger amount = [[MineTransactionInfo sharedManager] getOutcomeForYear:self.year month:self.month];
    self.expenseLabel.text = [NSString stringWithFormat:@"%ld$", amount];
}

# pragma mark - btn action

- (void)addNewTransactionBtnTapped {
    NSInteger day = [MineTimeUtil getCurrentDay];
    NSDate *date = [MineTimeUtil getDateForYear:self.year month:self.month day:day];
    MineNewTransactionViewController *newTransactionViewController = [[MineNewTransactionViewController alloc] initWithDate:date];
    [self.navigationController pushViewController:newTransactionViewController animated:YES];
}

- (void)histogramBtnTapped {
    NSInteger year = self.year;
    
    // set navigation bar back btn title
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[@(year) stringValue] style:UIBarButtonItemStylePlain target:nil action:nil];
    
    NSMutableArray *months = [[NSMutableArray alloc] init];
    for (int i = 0; i < 12; i ++)
        [months addObject:[MineTimeUtil getShortMonthStr:(i + 1)]];
    NSArray *incomeArray = [[MineTransactionInfo sharedManager] getIncomeForYear:year];
    NSArray *outcomeArray = [[MineTransactionInfo sharedManager] getAbsOutcomeForYear:year];
    NSArray *balanceArray = [[MineTransactionInfo sharedManager] getTotalAmountForYear:year];
    
    MineHistogramViewController *histogramViewController = [[MineHistogramViewController alloc] initWithXLabelArray:months incomeArray:incomeArray outcomeArray:outcomeArray balanceArray:balanceArray];
    histogramViewController.year = year;
    [self.navigationController pushViewController:histogramViewController animated:YES];
}

# pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *transactions = [[MineTransactionInfo sharedManager] getAllTransactionsForYear:self.year month:self.month];
    return transactions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *transactions = [[MineTransactionInfo sharedManager] getAllTransactionsForYear:self.year month:self.month];
    NSInteger index = indexPath.row;
    MineTransactionItem *item = [transactions objectAtIndex:(transactions.count - index - 1)];
    
    static NSString *cellIdentifier = @"MyCustomCell";
    MineTransactionHistoryTableViewCell *cell = [self.historyTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MineTransactionHistoryTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.price = item.price;
    cell.day = [MineTimeUtil getDay:item.transactionDate];
    cell.month = self.month;
    cell.transactionId = item.transactionId;
    
    [cell updatePriceLabel];
    [cell updateDateLabel];
    [cell updateSign];
    
    cell.rightUtilityButtons = [self rightButtons];
    cell.delegate = self;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

# pragma mark - table view cell left buttons

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"Delete"];
    
    return rightUtilityButtons;
}

# pragma mark - SWTableViewCell delegate

- (void)swipeableTableViewCell:(MineTransactionHistoryTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            MineDeleteTransactionService *service = [[MineDeleteTransactionService alloc] init];
            [service deleteTransactionWithId:cell.transactionId];
            self.indexPathToDelete = [self.historyTableView indexPathForCell:cell];
            
            NSLog(@"Delete button was pressed");
            break;
        }
        default:
            break;
    }
}

# pragma mark - notification response handler

- (void)getAllTransactionsDidSucceed:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateExpenseLabel];
        [self updateIncomeLabel];
        [self.historyTableView reloadData];
    });
}

- (void)deleteTransactionDidSucceed:(NSNotification *)notification
{
    NSDictionary *errorJson = [notification.userInfo valueForKey:MineResponseKeyErrorJson];
    NSInteger errorCode = [[errorJson valueForKey:MineResponseKeyErrorCode] intValue];

    if (errorCode == 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.indexPathToDelete) {
                NSArray *indexPaths = [[NSArray alloc] initWithObjects:self.indexPathToDelete, nil];
                [self.historyTableView beginUpdates];
                [self.historyTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
                [self.historyTableView endUpdates];
            }
            [self updateIncomeLabel];
            [self updateExpenseLabel];
        });
    }
    else {
        [MineAlertViewUtil showAlertViewWithErrorCode:errorCode delegate:self];
    }
}

@end
