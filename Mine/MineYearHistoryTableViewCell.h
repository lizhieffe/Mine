//
//  MineYearHistoryTableViewCell.h
//  Mine
//
//  Created by Zhi Li on 10/14/14.
//  Copyright (c) 2014 com.zhi.li. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *yearHistoryCollectionViewCellIdentifier = @"yearHistoryCollectionViewCell";

@interface MineYearHistoryTableViewCell : UITableViewCell <UICollectionViewDelegate, UICollectionViewDataSource>

@property (assign, nonatomic) NSInteger year;

@property (nonatomic, strong) UICollectionView *collectionView;

- (void)setTableViewContainerController:(UIViewController *)containerController;
-(void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate index:(NSInteger)index;

@end
