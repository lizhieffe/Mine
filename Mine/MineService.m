//
//  MineService.m
//  Mine
//
//  Created by Zhi Li on 7/26/14.
//  Copyright (c) 2014 com.zhi.li. All rights reserved.
//

#import "MineService.h"
#import "MineTimeUtil.h"
#import "MinePersistDataUtil.h"
#import "MinePreferenceService.h"
#import "MineConstant.h"
#import "MineServiceManager.h"
#import "MineAlertViewUtil.h"
#import "Reachability.h"

@interface MineService ()

@property (strong, nonatomic) NSString *fullUrl;


@end

@implementation MineService

- (id)init {
    self = [super init];
    if (self) {
        _requestParameters = [[NSMutableDictionary alloc] init];
        _fullUrl = [[NSString alloc] init];
        _finished = NO;
        _ignoreCache = NO;
        _expireTimeInterval = -1;
        _token = [MinePreferenceService token];
        _timeout = 10;
    }
    return self;
}

- (NSString *)hostUrl
{
//    return @"http://192.168.1.131:9000";
    return @"http://54.69.249.96:9000";
}

- (NSString *)apiPath
{
    return nil;
}

- (NSString *)HTTPMethod
{
    return nil;
}

- (NSString *)fullUrl
{
    
    // lazy initialization
    if (!_fullUrl || [_fullUrl length] == 0) {
        _fullUrl = [NSString stringWithFormat:@"%@%@", [self hostUrl], [self apiPath]];
        
        if (self.requestParameters && [self.requestParameters count] > 0) {
            NSInteger i = 0;
            for (id key in self.requestParameters) {
                if (i++ != 0)
                    _fullUrl = [NSString stringWithFormat:@"%@&", _fullUrl];
                else
                    _fullUrl = [NSString stringWithFormat:@"%@?", _fullUrl];
                
                _fullUrl = [NSString stringWithFormat:@"%@%@=%@", _fullUrl, key, [self.requestParameters objectForKey:key]];
            }
        }
    }
    
    return _fullUrl;
}

- (void)updateParameters
{
    if (_token)
        [self.requestParameters setObject:self.token forKey:MineRequestParameterToken];
}

- (void)start
{
    NSDate *lastSucceedDate = [self lastSucceedDate];
    if (!self.ignoreCache && lastSucceedDate && self.expireTimeInterval >= 0 && [lastSucceedDate timeIntervalSinceNow] * (-1) <= self.expireTimeInterval)
        return;
    
    lastSucceedDate = [self lastSucceedDateInCache];
    if (self.ignoreCache || !lastSucceedDate || self.expireTimeInterval < 0 || [lastSucceedDate timeIntervalSinceNow] * (-1) > self.expireTimeInterval) {
        
        if (![self connectedToNetwork]) {
            [MineAlertViewUtil showAlertViewWithErrorCode:9 delegate:nil];
            return;
        }
        
        NSURL *URL = [NSURL URLWithString:[self fullUrl]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:self.timeout];
        [request setHTTPMethod:@"POST"];
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:[self _completionBlock]];
        [task resume];
    }
    else {
        NSDictionary *lastSucceedJson = [self lastSucceedJsonInCache];
        [self completionBlockForSuccess](lastSucceedJson, nil);
    }
}

- (void (^)(NSData *data, NSURLResponse *response, NSError *error))_completionBlock
{
    return ^(NSData *data, NSURLResponse *response, NSError *error) {
        NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if (json && [json count] != 0 && [json objectForKey:MineResponseKeyErrorJson]) {
            
            NSDictionary *errorJson = [json valueForKey:MineResponseKeyErrorJson];
            NSInteger errorCode = [[errorJson valueForKey:MineResponseKeyErrorCode] intValue];
            if (errorCode == 0) {
                [self setlastSucceedDate:[NSDate date]];
                [self setLastSucceedDateInCache:[NSDate date]];
                [self setLastSucceedJsonInCache:json];
            }
            
            [self completionBlockForSuccess](json, response);
        }
        else
            [self completionBlockForFailure](json, response);
        
    };
}

- (void (^)(NSDictionary *json, NSURLResponse *response))completionBlockForSuccess
{
    return ^(NSDictionary *json, NSURLResponse *response) {
    };
}

- (void (^)(NSDictionary *json, NSURLResponse *response))completionBlockForFailure
{
    return ^(NSDictionary *json, NSURLResponse *response) {
    };
}

- (NSDate *)lastSucceedDate
{
    MineServiceManager *sharedManager = [MineServiceManager sharedManager];
    NSString *className = NSStringFromClass([self class]);
    return [sharedManager.lastSucceedDates objectForKey:className];
}

- (void)setlastSucceedDate:(NSDate *)date
{
    MineServiceManager *sharedManager = [MineServiceManager sharedManager];
    NSString *className = NSStringFromClass([self class]);
    [sharedManager.lastSucceedDates setObject:date forKey:className];
}

- (NSDate *)lastSucceedDateInCache
{
    NSString *className = NSStringFromClass([self class]);
    NSString *path = [NSString stringWithFormat:@"%@_lastSucceedDate", className];
    NSDate *lastSucceedDate = [MinePersistDataUtil objectForKey:path];
    return lastSucceedDate;
}

- (NSDictionary *)lastSucceedJsonInCache
{
    NSString *className = NSStringFromClass([self class]);
    NSString *path = [NSString stringWithFormat:@"%@_lastSucceedJson", className];
    NSDictionary *json = [MinePersistDataUtil objectForKey:path];
    return json;
}

- (void)setLastSucceedDateInCache:(NSDate *)lastSucceedDate
{    
    NSString *className = NSStringFromClass([self class]);
    NSString *path = [NSString stringWithFormat:@"%@_lastSucceedDate", className];
    [MinePersistDataUtil setObject:lastSucceedDate forKey:path];
}

- (void)setLastSucceedJsonInCache:(NSDictionary *)json
{
    NSString *className = NSStringFromClass([self class]);
    NSString *path = [NSString stringWithFormat:@"%@_lastSucceedJson", className];
    [MinePersistDataUtil setObject:json forKey:path];
}

- (BOOL)connectedToNetwork
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

@end
