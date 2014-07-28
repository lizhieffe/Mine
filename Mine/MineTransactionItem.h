//
//  MineTransactionItem.h
//  Mine
//
//  Created by Zhi Li on 7/27/14.
//  Copyright (c) 2014 com.zhi.li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MineTransactionItem : NSObject

@property (nonatomic, strong) NSString *description;
@property (nonatomic, assign) NSNumber *price;

- (id)initWithDescription:(NSString *)description price:(NSNumber *)price;

@end
