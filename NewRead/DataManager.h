//
//  DataManager.h
//  NewRead
//
//  Created by qingyun on 16/3/14.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject


//代码创建数据库
+(instancetype)shareDB;
//存数据
- (void)save2DatabaseWithArray:(NSArray *)contentList;

//取数据
//- (NSArray *)getDataFromdDatabaseWithMsg:(NSString *)xuhao;

- (NSArray *)getDataFromdDatabaseWithMsg:(NSInteger)index;

//删除数据
- (BOOL)deleteFromeDatabase;

//删除一类
- (void)deleteFromDatabaseWithCateId:(NSString *)xuhao;
@end
