//
//  MineHistogramViewController.m
//  Mine
//
//  Created by Zhi Li on 10/14/14.
//  Copyright (c) 2014 com.zhi.li. All rights reserved.
//

#import "MineHistogramViewController.h"
#import "PNChart.h"
#import "MineTimeUtil.h"
#import "MineColorUtil.h"
#import "MineTransactionInfo.h"

@interface MineHistogramViewController ()

@end

@implementation MineHistogramViewController

- (id)initWithXLabelArray:(NSArray *)xLabelArray incomeArray:(NSArray *)incomeArray outcomeArray:(NSArray *)outcomeArray
{
    self = [super init];
    if (self) {
        _xLabelArray = xLabelArray;
        _incomeArray = incomeArray;
        _outcomeArray = outcomeArray;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (int i = 0; i < self.incomeArray.count; i ++)
        _incomeSum += [(NSNumber *)[_incomeArray objectAtIndex:i] longValue];
    for (int i = 0; i < self.outcomeArray.count; i ++)
        _outcomeSum += [(NSNumber *)[_outcomeArray objectAtIndex:i] longValue];
    
    self.totalIncome.text = [NSString stringWithFormat:@"$%ld", (long)self.incomeSum];
    
    self.totalOutcome.text = [NSString stringWithFormat:@"-$%ld", ABS((long)self.outcomeSum)];
    
    PNBarChart *incomeChart = [self generateBarChartWithXLabels:self.xLabelArray YValues:self.incomeArray withFrame:CGRectMake(0, 0, self.incomeBackground.frame.size.width, self.incomeBackground.frame.size.height)];
    
    PNBarChart *outcomeChart = [self generateBarChartWithXLabels:self.xLabelArray YValues:self.outcomeArray withFrame:CGRectMake(0, 0, self.outcomeBackground.frame.size.width, self.outcomeBackground.frame.size.height)];
    
    [self.incomeBackground addSubview:incomeChart];
    [self.outcomeBackground addSubview:outcomeChart];
}

# pragma mark - bar chart utility

- (PNBarChart *)generateBarChartWithXLabels:(NSArray *)labels YValues:(NSArray *)values withFrame:(CGRect)frame
{
    PNBarChart *barChart = [[PNBarChart alloc] initWithFrame:frame];
    barChart.backgroundColor = [UIColor clearColor];
    barChart.yLabelFormatter = ^(CGFloat yValue){
//        CGFloat yValueParsed = yValue;
//        NSString * labelText = [NSString stringWithFormat:@"%4f",yValueParsed];
        NSString *labelText = @"";
        return labelText;
    };
    
    [barChart setXLabels:labels];
    [barChart setYValues:values];
    
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    for (int i = 0; i < labels.count; i ++)
         [colors addObject:UIColorFromRGB(0xFF3300)];
    [barChart setStrokeColors:colors];
    [barChart strokeChart];
    
    return barChart;
}

@end
