//
//  MineTransactionHistoryViewController.m
//  Mine
//
//  Created by Zhi Li on 10/4/14.
//  Copyright (c) 2014 com.zhi.li. All rights reserved.
//

#import "MineTransactionHistoryViewController.h"
#import "MineTransactionInfo.h"
#import "MinePreferenceService.h"
#import "MineTimeUtil.h"
#import "MineTransactionHistoryTableViewCell.h"
#import "MineTransactionItem.h"
#import "MineDeleteTransactionService.h"
#import "MineAlertViewUtil.h"

@interface MineTransactionHistoryViewController ()

@property (weak, nonatomic) IBOutlet UIButton *okBtn;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *incomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *expenseLabel;

@property (weak, nonatomic) IBOutlet UITableView *historyTableView;

@property (assign, nonatomic) NSInteger year;
@property (assign, nonatomic) NSInteger month;

@end

@implementation MineTransactionHistoryViewController

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

    // table view cell
    [self.historyTableView registerNib:[UINib nibWithNibName:@"MineTransactionHistoryTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyCustomCell"];
    
    [self updateDateLabel];
    [self updateIncomeLabel];
    [self updateExpenseLabel];
    
    self.historyTableView.delegate = self;
    self.historyTableView.dataSource = self;
    
    [self.okBtn addTarget:self action:@selector(okBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    
    /* notification */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteTransactionDidSucceed:) name:MineNotificationDeleteTransactionDidSucceed object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateDateLabel
{
    NSInteger month = [[MinePreferenceService sharedManager] displayMonth];
    NSInteger year = [[MinePreferenceService sharedManager] displayYear];
    NSString *monthStr = [MineTimeUtil getMonthStr:month];
    self.dateLabel.text = [NSString stringWithFormat:@"%@ %ld", monthStr, (long)year];
}

- (void)updateIncomeLabel
{
    NSInteger month = [[MinePreferenceService sharedManager] displayMonth];
    NSInteger year = [[MinePreferenceService sharedManager] displayYear];
    NSInteger amount = [[MineTransactionInfo sharedManager] getTotalIncomeForYear:year month:month];
    self.incomeLabel.text = [NSString stringWithFormat:@"%ld$", amount];
}

- (void)updateExpenseLabel
{
    NSInteger month = [[MinePreferenceService sharedManager] displayMonth];
    NSInteger year = [[MinePreferenceService sharedManager] displayYear];
    NSInteger amount = [[MineTransactionInfo sharedManager] getTotalExpenseForYear:year month:month];
    self.expenseLabel.text = [NSString stringWithFormat:@"%ld$", amount];
}

# pragma mark - btn action

- (void)okBtnTapped
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

# pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger month = [[MinePreferenceService sharedManager] displayMonth];
    NSInteger year = [[MinePreferenceService sharedManager] displayYear];
    NSArray *transactions = [[MineTransactionInfo sharedManager] getAllTransactionsForYear:year month:month];
    return transactions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger month = [[MinePreferenceService sharedManager] displayMonth];
    NSInteger year = [[MinePreferenceService sharedManager] displayYear];
    NSArray *transactions = [[MineTransactionInfo sharedManager] getAllTransactionsForYear:year month:month];
    NSInteger index = indexPath.row;
    MineTransactionItem *item = [transactions objectAtIndex:index];
    
    static NSString *cellIdentifier = @"MyCustomCell";
    MineTransactionHistoryTableViewCell *cell = [self.historyTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MineTransactionHistoryTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.price = item.price;
    cell.day = [MineTimeUtil getDay:item.transactionDate];
    cell.month = month;
    cell.transactionId = item.transactionId;
    
    [cell updatePriceLabel];
    [cell updateDateLabel];
    [cell updateSign];
    
    cell.rightUtilityButtons = [self rightButtons];
    cell.delegate = self;
    
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
            
            NSLog(@"Delete button was pressed");
            break;
        }
        default:
            break;
    }
}

# pragma mark - notification response handler

- (void)deleteTransactionDidSucceed:(NSNotification *)notification
{
    
    NSDictionary *errorJson = [notification.userInfo valueForKey:MineResponseKeyErrorJson];
    NSInteger errorCode = [[errorJson valueForKey:MineResponseKeyErrorCode] intValue];
    
    if (errorCode == 0) {
//        NSDictionary *responseJson = [notification.userInfo valueForKey:MineResponseKeyResponseJson];
//        NSString *deletedTransactionId = [responseJson valueForKey:MineResponseKeyResponseDeletedTransactionId];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.historyTableView reloadData];
            [self updateIncomeLabel];
            [self updateExpenseLabel];
        });
    }
    else {
        [MineAlertViewUtil showAlertViewWithErrorCode:errorCode];
    }
}

@end
