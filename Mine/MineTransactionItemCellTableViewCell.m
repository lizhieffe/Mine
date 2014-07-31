//
//  MineTransactionItemCellTableViewCell.m
//  Mine
//
//  Created by Zhi Li on 7/27/14.
//  Copyright (c) 2014 com.zhi.li. All rights reserved.
//

#import "MineTransactionItemCellTableViewCell.h"

@interface MineTransactionItemCellTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *border;

@end

@implementation MineTransactionItemCellTableViewCell

+ (MineTransactionItemCellTableViewCell *)generateCell {
    
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"MineTransactionItemCellTableViewCell" owner:self options:NULL];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    MineTransactionItemCellTableViewCell *customCell = nil;
    NSObject* nibItem = nil;
    while ((nibItem = [nibEnumerator nextObject]) != nil) {
        if ([nibItem isKindOfClass:[MineTransactionItemCellTableViewCell class]]) {
            customCell = (MineTransactionItemCellTableViewCell *)nibItem;
            break; // we have a winner
        }
    }
    
    int inset = 0;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(inset, 43, customCell.bounds.size.width - 2 *inset, 1)];
    lineView.backgroundColor = [UIColor blackColor];
    [customCell addSubview:lineView];
    
    return customCell;
}

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
