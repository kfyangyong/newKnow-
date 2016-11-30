//
//  HomeModels.m
//  小知
//
//  Created by qingyun on 16/1/27.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "HomeModels.h"

@implementation HomeModels

#pragma mark - 初始化方法
+ (instancetype)modelWithDictionary:(NSDictionary *)dict{
    return [[self alloc]initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    
    if (self = [super init]) {
        if ([dict isKindOfClass:[NSNull class]]) {
            return self;
        }
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
   // NSLog(@"no key");
}

@end
