//
//  MineCreateTransactionAmountViewController.m
//  Mine
//
//  Created by Zhi Li on 7/27/14.
//  Copyright (c) 2014 com.zhi.li. All rights reserved.
//

#import "MineCreateTransactionItemsViewController.h"
#import "MineTransactionInfo.h"
#import "MineTransactionItem.h"
#import "MineTransactionItemCellTableViewCell.h"


@interface MineCreateTransactionItemsViewController ()

@property (nonatomic, strong) MineTransactionInfo *transaction;

@property (weak, nonatomic) IBOutlet UITextField *transactionItemDescription;
@property (weak, nonatomic) IBOutlet UITextField *transactionItemPrice;
@property (weak, nonatomic) IBOutlet UITableView *transactionItemsTableView;
@property (weak, nonatomic) IBOutlet UILabel *transactionItemsPlaceHolder;

- (IBAction)addNewTransactionItemBtnTapped:(id)sender;

@end

@implementation MineCreateTransactionItemsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTransaction];
    [self updateUI];
    
    self.transactionItemsTableView.delegate = self;
    self.transactionItemsTableView.dataSource = self;
}

- (void)initTransaction
{
    self.transaction = [[MineTransactionInfo alloc] init];
}



- (void)updateUI
{
    self.transactionItemsTableView.hidden = [self.transaction itemCount] == 0 ? YES : NO;
    self.transactionItemsPlaceHolder.hidden = !self.transactionItemsTableView.hidden;
    [self.transactionItemsTableView reloadData];
}

- (IBAction)addNewTransactionItemBtnTapped:(id)sender {
    
    NSString *description = [self.transactionItemDescription.text isEqualToString:@""] ? @"no description" : self.transactionItemDescription.text;
    
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * price = [f numberFromString:self.transactionItemPrice.text];
    
    MineTransactionItem *newItem = [[MineTransactionItem alloc] initWithDescription:description price:price];
    [self.transaction addTransactionItem:newItem];
    
    [self updateUI];
}

#pragma mark - table view delegate -

#pragma mark - table view data source -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.transaction itemCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MineTransactionItem *item = [self.transaction.transactionItems objectAtIndex:indexPath.row];
    NSString *description = item.description;
    NSNumber *price = item.price;
    
    static NSString *CellIdentifier = @"transactionItemsTableCell";
    MineTransactionItemCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MineTransactionItemCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        cell.description = [[UILabel alloc] init];
    }
    cell.cellDescription.text = description;
    cell.cellPrice.text = [price stringValue];
    return cell;
}

- (IBAction)transactionItemPrice:(id)sender {
}
@end
