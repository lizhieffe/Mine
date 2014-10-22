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
@property (nonatomic, assign) BOOL finished;
@property (nonatomic, assign) BOOL ignoreCache;
@property (assign, nonatomic) NSInteger expireTimeInterval;
@property (strong, nonatomic) NSString *token;
@property (assign, nonatomic) NSInteger timeout;
@property (weak, nonatomic) id <NSURLConnectionDelegate> connectionDelegate;

- (NSString *)hostUrl;
- (NSString *)apiPath;
- (NSString *)HTTPMethod;
- (void)updateParameters;
- (void)start;
- (NSDate *)lastSucceedDate;
- (NSDate *)lastSucceedDateInCache;
- (NSDictionary *)lastSucceedJsonInCache;

@end
