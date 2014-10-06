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

@interface MineTransactionHistoryViewController ()

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
    // Do any additional setup after loading the view from its nib.
    
    [self updateDateLabel];
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

# pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end
