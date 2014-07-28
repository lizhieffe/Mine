//
//  MineTransactionItemCellTableViewCell.m
//  Mine
//
//  Created by Zhi Li on 7/27/14.
//  Copyright (c) 2014 com.zhi.li. All rights reserved.
//

#import "MineTransactionItemCellTableViewCell.h"

@implementation MineTransactionItemCellTableViewCell

- (id)initWithDescription:(NSString *)description price:(NSNumber *)price
{
    self = [super init];
    if (self) {
        _cellDescription.text = description;
        _cellPrice.text = [price stringValue];
    }
    return self;
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

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    _cellDescription.text = @"";
    _cellPrice.text = @"";
}

@end
