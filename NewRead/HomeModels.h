//
//  HomeModels.h
//  小知
//
//  Created by qingyun on 16/1/27.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeModels : NSObject

@property (nonatomic,strong) NSString *nickname;
@property (nonatomic,strong) NSString *aid;
@property (nonatomic,strong) NSString *imgurl;
@property (nonatomic,strong) NSString *lastId;
@property (nonatomic,assign) NSInteger readNum;
@property (nonatomic,strong) NSString *title;

+ (instancetype)modelWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
