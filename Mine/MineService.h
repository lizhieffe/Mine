//
//  MineService.h
//  Mine
//
//  Created by Zhi Li on 7/26/14.
//  Copyright (c) 2014 com.zhi.li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MineService : NSObject

@property (strong, nonatomic) NSMutableDictionary *requestParameters;
@property (nonatomic) BOOL finished;

- (NSString *)hostUrl;
- (NSString *)apiPath;
- (NSString *)HTTPMethod;
- (void)updateParameters;
- (void)start;

@end
