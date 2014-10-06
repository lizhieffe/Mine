//
//  MineService.m
//  Mine
//
//  Created by Zhi Li on 7/26/14.
//  Copyright (c) 2014 com.zhi.li. All rights reserved.
//

#import "MineService.h"

@interface MineService ()

@property (strong, nonatomic) NSString *fullUrl;

@end

@implementation MineService

- (id)init {
    self = [super init];
    if (self) {
        _requestParameters = [[NSMutableDictionary alloc] init];
        _fullUrl = [[NSString alloc] init];
        _finished = false;
    }
    return self;
}

- (NSString *)hostUrl
{
    return @"http://localhost:9000";
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
}

- (void)start
{
    
    NSURL *URL = [NSURL URLWithString:[self fullUrl]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"POST"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    //    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
    //                                            completionHandler:
    //                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
    //
    //                                      NSString *results = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //                                      NSLog(results);
    //
    //                                  }];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:[self _completionBlock]];
    
    [task resume];
}

- (void (^)(NSData *data, NSURLResponse *response, NSError *error))_completionBlock
{
    return ^(NSData *data, NSURLResponse *response, NSError *error) {
        //        NSString *results = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        if (json && [json count] != 0 && [json objectForKey:MineResponseKeyErrorJson])
            [self completionBlockForSuccess](json, response);
        else
            [self completionBlockForFailure](json, response);
        
    };
}

- (void (^)(NSMutableDictionary *json, NSURLResponse *response))completionBlockForSuccess
{
    return ^(NSMutableDictionary *json, NSURLResponse *response) {
    };
}

- (void (^)(NSMutableDictionary *json, NSURLResponse *response))completionBlockForFailure
{
    return ^(NSMutableDictionary *json, NSURLResponse *response) {
    };
}

@end
