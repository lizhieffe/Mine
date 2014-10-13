//
//  MineTransactionHistoryTableViewCell.m
//  Mine
//
//  Created by Zhi Li on 10/4/14.
//  Copyright (c) 2014 com.zhi.li. All rights reserved.
//

#import "MineTransactionHistoryTableViewCell.h"
#import "MineTimeUtil.h"
#import "MineColorUtil.h"

@interface MineTransactionHistoryTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *sign;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation MineTransactionHistoryTableViewCell

+ (UITableViewCell *)generateCellWithId:(long)transactionId price:(NSInteger)price date:(NSDate *)date
{
    MineTransactionHistoryTableViewCell *cell = nil;
    cell = [[MineTransactionHistoryTableViewCell alloc] init];
    cell.day = [MineTimeUtil getDay:date];
    cell.month = [MineTimeUtil getMonth:date];
    cell.price = price;
    cell.transactionId = transactionId;
    
    [cell updateSign];
    [cell updateDateLabel];
    [cell updatePriceLabel];
    
    return cell;
}

//- (id)initWithPrice:(NSInteger)price date:(NSDate *)date
//{
//    self = [super init];
//    if (self) {
//        _day = [MineTimeUtil getDay:date];
//        _month = [MineTimeUtil getMonth:date];
//        _price = price;
//        
////        [self updateSign];
////        [self updateDateLabel];
////        [self updatePriceLabel];
//    }
//    return self;
//}

- (void)updateSign
{
    if (self.price > 0) {
        self.sign.image = [UIImage imageNamed:@"Add_100x100.png"];
        self.sign.backgroundColor = UIColorFromRGB(0x66FFCC);
    }
    else {
        self.sign.image = [UIImage imageNamed:@"Remove_100x100.png"];
        self.sign.backgroundColor = UIColorFromRGB(0xFF9966);
    }
}

- (void)updateDateLabel
{
    NSString *monthStr = [MineTimeUtil getShortMonthStr:self.month];
    self.dateLabel.text = [NSString stringWithFormat:@" %@.%ld", monthStr, self.day];
}

- (void)updatePriceLabel
{
    self.priceLabel.text = [NSString stringWithFormat:@"%ld$", self.price];
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
