//
//  MineTransactionItemCellTableViewCell.h
//  Mine
//
//  Created by Zhi Li on 7/27/14.
//  Copyright (c) 2014 com.zhi.li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineTransactionItemCellTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *cellDescription;
@property (weak, nonatomic) IBOutlet UILabel *cellPrice;

+ (MineTransactionItemCellTableViewCell *)generateCell;
- (id)initWithDescription:(NSString *)description price:(NSNumber *)price;

@end
