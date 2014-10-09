//
//  MinePersistDataUtil.h
//  Mine
//
//  Created by Zhi Li on 10/8/14.
//  Copyright (c) 2014 com.zhi.li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MinePersistDataUtil : NSObject

+ (void)setObject:(id)value forKey:(NSString *)key;
+ (id)objectForKey:(NSString *)key;
+ (void)deleteKey:(NSString *)key;

@end
