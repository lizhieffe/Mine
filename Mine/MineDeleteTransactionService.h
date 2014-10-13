//
//  MineDeleteTransactionService.h
//  Mine
//
//  Created by Zhi Li on 10/12/14.
//  Copyright (c) 2014 com.zhi.li. All rights reserved.
//

#import "MineService.h"

@interface MineDeleteTransactionService : MineService

- (void)deleteTransactionWithId:(long)transactionId;

@end
