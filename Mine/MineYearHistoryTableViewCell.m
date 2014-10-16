//
//  MineYearHistoryTableViewCell.m
//  Mine
//
//  Created by Zhi Li on 10/14/14.
//  Copyright (c) 2014 com.zhi.li. All rights reserved.
//

#import "MineYearHistoryTableViewCell.h"
#import "MineYearHistoryCollectionViewCell.h"
#import "MineTimeUtil.h"
#import "MineTransactionInfo.h"
#import "MineMonthViewController.h"
#import "MineColorUtil.h"

static BOOL nibCollectionViewCellloaded = NO;

@interface MineYearHistoryTableViewCell ()

@property (strong, nonatomic) UIViewController *tableViewContainerController;

@end

@implementation MineYearHistoryTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(100, 80);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    if (!nibCollectionViewCellloaded) {
        UINib *nib = [UINib nibWithNibName:@"MineYearHistoryCollectionViewCell" bundle: nil];
        [self.collectionView registerNib:nib forCellWithReuseIdentifier:yearHistoryCollectionViewCellIdentifier];
    }
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.contentView addSubview:self.collectionView];
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.collectionView.frame = self.contentView.bounds;
}

- (void)setTableViewContainerController:(UIViewController *)containerController
{
    _tableViewContainerController = containerController;
}

-(void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate index:(NSInteger)index
{
    self.collectionView.dataSource = dataSourceDelegate;
//    self.collectionView.delegate = self;
    self.collectionView.delegate = dataSourceDelegate;
    self.collectionView.tag = index;
    
    [self.collectionView reloadData];
}

# pragma mark - collection view delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger month = indexPath.row * 3 + indexPath.section + 1;
    MineMonthViewController *historyViewController = [[MineMonthViewController alloc] initForYear:self.year month:month];
    
    self.tableViewContainerController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[@(self.year) stringValue] style:UIBarButtonItemStylePlain target:nil action:nil];

    [self.tableViewContainerController.navigationController pushViewController:historyViewController animated:YES];
}

# pragma mark - collection view data source

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView
{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MineYearHistoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:yearHistoryCollectionViewCellIdentifier forIndexPath:indexPath];
    
    NSInteger month = indexPath.row * 3 + indexPath.section + 1;
    NSString *monthStr = [MineTimeUtil getShortMonthStr:month];
    cell.monthLabel.text = [monthStr uppercaseString];
    
    NSInteger year = self.year;
    cell.incomeLabel.text = [NSString stringWithFormat:@"$%@", [@([[MineTransactionInfo sharedManager] getIncomeForYear:year month:month]) stringValue]];
    
    NSInteger absOutcome = abs((int)[[MineTransactionInfo sharedManager] getOutcomeForYear:year month:month]);
    cell.outcomeLabel.text = [NSString stringWithFormat:@"-$%@", [@(absOutcome) stringValue]];
    
    NSInteger currentYear = [MineTimeUtil getCurrentYear];
    NSInteger currentMonth = [MineTimeUtil getCurrentMonth];
    if (currentMonth == month && currentYear == year) {
        cell.monthLabel.backgroundColor = UIColorFromRGB(0xFF3300);
        cell.monthLabel.textColor = [UIColor whiteColor];
    }
    else {
        cell.monthLabel.backgroundColor = [UIColor whiteColor];
        cell.monthLabel.textColor = UIColorFromRGB(0xFF3300);
    }
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 3, 0, 3);
}

@end
