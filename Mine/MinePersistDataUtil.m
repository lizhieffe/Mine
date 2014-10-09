//
//  MinePersistDataUtil.m
//  Mine
//
//  Created by Zhi Li on 10/8/14.
//  Copyright (c) 2014 com.zhi.li. All rights reserved.
//

#import "MinePersistDataUtil.h"

@implementation MinePersistDataUtil

+ (void)setObject:(id)value forKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSArray class]])
        [userDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:value] forKey:key];
    else
        [userDefaults setObject:value forKey:key];
    
//    NSDictionary *dict = [self getDict];
//    [dict setValue:value forKey:key];
//    [self saveDict:dict];
}

+ (id)objectForKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSObject *object = [userDefaults objectForKey:key];
    if ([object isKindOfClass:[NSData class]])
        return [NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)object];
    else
        return object;
    
    
//    NSDictionary *dict = [self getDict];
//    return [dict objectForKey:key];
}

+ (void)deleteKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:key];
    
    
//    NSMutableDictionary *dict = [self getDict];
//    [dict removeObjectForKey:key];
//    [self saveDict:dict];
}

+ (NSMutableDictionary *)getDict
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths objectAtIndex:0];
    NSString *myFile = [docPath stringByAppendingPathComponent:@"minePreferenceService.plist"];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:myFile];
    if (!dict) {
        dict = [[NSMutableDictionary alloc] init];
        [self saveDict:dict];
    }
    return dict;
}

+ (void)saveDict:(NSDictionary *)dict
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths objectAtIndex:0];
    NSString *myFile = [docPath stringByAppendingPathComponent:@"minePreferenceService.plist"];
    [dict writeToFile:myFile atomically:YES];
}

@end

