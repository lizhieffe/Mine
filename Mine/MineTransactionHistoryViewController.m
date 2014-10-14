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
#import "MineNewTransactionViewController.h"

@interface MineTransactionHistoryViewController ()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *incomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *expenseLabel;

@property (weak, nonatomic) IBOutlet UITableView *historyTableView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *addNewTransactionBtn;

@property (assign, nonatomic) NSInteger year;
@property (assign, nonatomic) NSInteger month;

@property (strong, nonatomic) NSIndexPath *indexPathToDelete;

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

    self.addNewTransactionBtn.target = self;
    self.addNewTransactionBtn.action = @selector(addNewTransactionBtnTapped);
    
    // table view cell
    [self.historyTableView registerNib:[UINib nibWithNibName:@"MineTransactionHistoryTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyCustomCell"];
    
    [self updateDateLabel];
    [self updateIncomeLabel];
    [self updateExpenseLabel];
    
    self.historyTableView.delegate = self;
    self.historyTableView.dataSource = self;
    
    
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
    NSString *monthStr = [MineTimeUtil getMonthStr:self.month];
    self.dateLabel.text = [NSString stringWithFormat:@"%@ %ld", monthStr, (long)self.year];
}

- (void)updateIncomeLabel
{
    NSInteger amount = [[MineTransactionInfo sharedManager] getTotalIncomeForYear:self.year month:self.month];
    self.incomeLabel.text = [NSString stringWithFormat:@"%ld$", amount];
}

- (void)updateExpenseLabel
{
    NSInteger amount = [[MineTransactionInfo sharedManager] getTotalExpenseForYear:self.year month:self.month];
    self.expenseLabel.text = [NSString stringWithFormat:@"%ld$", amount];
}

# pragma mark - btn action

//- (void)addBtnTapped
//{
//    [self.navigationController popToRootViewControllerAnimated:YES];
//}

- (void)addNewTransactionBtnTapped {
    MineNewTransactionViewController *newTransactionViewController = [[MineNewTransactionViewController alloc] init];
    [self.navigationController pushViewController:newTransactionViewController animated:YES];
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
