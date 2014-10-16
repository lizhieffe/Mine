//
//  MineHistogramViewController.h
//  Mine
//
//  Created by Zhi Li on 10/14/14.
//  Copyright (c) 2014 com.zhi.li. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PNBarChart;

@interface MineHistogramViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *totalAmountBackground;
@property (weak, nonatomic) IBOutlet UIView *incomeBackground;
@property (weak, nonatomic) IBOutlet UIView *outcomeBackground;

@property (weak, nonatomic) IBOutlet UILabel *totalIncome;
@property (weak, nonatomic) IBOutlet UILabel *totalOutcome;
@property (weak, nonatomic) IBOutlet UILabel *totalAmount;

@property (assign, nonatomic) NSInteger year;
@property (assign, nonatomic) NSInteger month;
@property (assign, nonatomic) NSInteger day;

@property (strong, nonatomic) NSArray *xLabelArray;
@property (strong, nonatomic) NSArray *incomeArray;
@property (strong, nonatomic) NSArray *outcomeArray;
@property (strong, nonatomic) NSArray *balanceArray;

@property (assign, nonatomic) NSInteger incomeSum;
@property (assign, nonatomic) NSInteger outcomeSum;
@property (assign, nonatomic) NSInteger balanceSum;

- (id)initWithXLabelArray:(NSArray *)xLabelArray incomeArray:(NSArray *)incomeArray outcomeArray:(NSArray *)outcomeArray balanceArray:(NSArray *)balanceArray;

@end
