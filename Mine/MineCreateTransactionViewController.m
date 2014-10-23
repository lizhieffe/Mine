//
//  MineCreateTransactionViewController.m
//  Mine
//
//  Created by Zhi Li on 10/23/14.
//  Copyright (c) 2014 com.zhi.li. All rights reserved.
//

#import "MineCreateTransactionViewController.h"
#import "MineTimeUtil.h"

@interface MineCreateTransactionViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *absAmountCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *isOutcomeCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *dateCell;

@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UISwitch *isOutcomeSwitch;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextField *dateTextField;

@property (assign, nonatomic) NSInteger amount;
@property (assign, nonatomic) BOOL isOutcome;
@property (strong, nonatomic) NSDate *date;

@end

@implementation MineCreateTransactionViewController

- (id)initWithDate:(NSDate *)date
{
    self = [super init];
    if (self) {
        _amount = 0;
        _isOutcome = YES;
        _date = date;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.title = @"New Transaction";
    
    [self updateAmountTextField];
    [self updateDateLabel];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.amountTextField becomeFirstResponder];
}

# pragma mark - UI

- (void)updateAmountTextField
{
    if (self.amount == 0)
        self.amountTextField.text = nil;
    else {
        NSString *amountText = [NSString stringWithFormat:@"$%ld", self.amount];
        self.amountTextField.text = amountText;
    }
}

- (void)updateDateLabel
{
    NSString *dateLabelText = @"";
    
    NSDate *today = [NSDate date];
    if ([MineTimeUtil isDate:self.date theSameWithDate:today])
        dateLabelText = @"Today";
    else {
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"MMMM dd, yyyy EE"];
        dateLabelText = [format stringFromDate:self.date];
    }
    
    self.dateLabel.text = dateLabelText;
}

# pragma mark - UITableViewDelegate

# pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    if (section == 0 && row == 0) {
        return self.absAmountCell;
    }
    else if (section == 0 && row == 1) {
        return self.isOutcomeCell;
    }
    else
        return self.dateCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return 2;
    else
        return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


@end
