//
//  MineAddTransactionService.h
//  Mine
//
//  Created by Zhi Li on 10/5/14.
//  Copyright (c) 2014 com.zhi.li. All rights reserved.
//

#import "MineService.h"

@interface MineAddTransactionService : MineService

- (void)addTransactionForToken:(NSString *)token timestamp:(NSInteger)timestamp price:(NSInteger)price;

@end
