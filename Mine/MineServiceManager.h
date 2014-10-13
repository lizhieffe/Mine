//
//  MineServiceManager.h
//  Mine
//
//  Created by Zhi Li on 10/9/14.
//  Copyright (c) 2014 com.zhi.li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MineServiceManager : NSObject

@property (strong, nonatomic) NSMutableDictionary *lastSucceedDates;

+ (id)sharedManager;

@end
