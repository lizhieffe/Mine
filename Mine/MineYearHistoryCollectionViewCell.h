//
//  MineYearHistoryCollectionViewCell.h
//  
//
//  Created by Zhi Li on 10/14/14.
//
//

#import <UIKit/UIKit.h>

@interface MineYearHistoryCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *incomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *outcomeLabel;

@property (assign, nonatomic) NSInteger year;

@end
