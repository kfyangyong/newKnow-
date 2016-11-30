//
//  DataManager.m
//  NewRead
//
//  Created by qingyun on 16/3/14.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "DataManager.h"
#import "HomeModels.h"
#import "FMDB.h"
#import "comment.h"
#define DataBaseName @"mydata.db"
#define TableName @"newRead"

@interface DataManager ()

@property (nonatomic,strong) FMDatabase *db;
@property (nonatomic,strong) NSArray *cateId;
@end
@implementation DataManager

static NSArray *names;

- (NSArray *)cateId{
    if (_cateId == nil) {
        _cateId = @[kgloab,kEconomic,kEat,kTourist,kSport,kFashion,kHealth,kRead,kEnotion,kScience,kMilitary,kConstellation,kMovie];
    }
    return _cateId;
}

//代码创建数据库
+(instancetype)shareDB{
    static DataManager *DBManager;
    static dispatch_once_t  onec;
    dispatch_once(&onec, ^{
        DBManager =  [[DataManager alloc] init];
        //1.创建数据库对象
        DBManager.db = [FMDatabase databaseWithPath:[DataManager dataPath]];
        //2.打开数据库
        if (![DBManager.db open]) {
//            NSLog(@"db open error");
            return ;
        }
        //3.创建表
        [DBManager createTable];
    });
    return DBManager;
}
- (BOOL)createTable{
    //sql
    NSString *sqlStr = @"create table if not exists newRead(aid integer primary key,imgurl text,lastId text,new_source text,nickname text, readNum text, title text,typeid text,videoCovers text, videourls text,weixin text,msg text)";
    if (![_db executeUpdate:sqlStr]) {
        return NO;
    }
    return YES;
}

//获取names ???????
- (NSArray *)getTableColumn:(NSString *)tabeName{
    
    FMResultSet *result = [_db getTableSchema:tabeName];
    NSMutableArray *columns = [NSMutableArray array];
    while ([result next]) {
        NSString *column = [result objectForColumnName:@"name"];
        [columns addObject:column];
    }
    return columns;
}
//文件路径
+ (NSString *)dataPath{
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *dataPath = [documentsPath stringByAppendingPathComponent:TableName];
 //   NSLog(@"%@",dataPath);
    return dataPath;
}
//获取 交集name
+ (NSArray *)nameWithArray1:(NSArray *)arr1 andArray2:(NSArray *)arr2{
    NSMutableArray *arr = [NSMutableArray array];
    [arr1 enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([arr2 containsObject:obj]) {
            [arr addObject:obj];
        }
    }];
    return arr;
}

//构造Sql 语句
+ (NSString *)crestSQLStringWithKeys:(NSArray *)keys{
    
    NSString *nameStr = [keys componentsJoinedByString:@","];
    NSString *valuesStr = [keys componentsJoinedByString:@",:"];
    valuesStr = [@":"stringByAppendingString:valuesStr];
    NSString *sqlStr = [NSString stringWithFormat:@"insert into %@(%@) values(%@)",TableName,nameStr,valuesStr];
    return sqlStr;
}

#pragma mark - 数据库操作
//存数据
- (void)save2DatabaseWithArray:(NSArray *)contentList{
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[DataManager dataPath]];
    //GCD
    [queue inDatabase:^(FMDatabase *db) {
        for (int i = 0; i <contentList.count; i++) {
            //获取网络数字典
            NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
            NSDictionary *contentDic = [contentList objectAtIndex:i];
            
            [dataDic addEntriesFromDictionary:contentDic];
            //获取keys
            NSArray *dataDicKeys = [dataDic allKeys];
            //获取交集key
            names = [self getTableColumn:TableName];
            NSArray *contentKeys = [DataManager nameWithArray1:names andArray2:dataDicKeys];
            //插入语句
            NSString *sqlStr = [DataManager crestSQLStringWithKeys:contentKeys];
            //准备插入字典
            NSMutableDictionary *insertDic = [NSMutableDictionary dictionary];
            [contentKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                id value = [dataDic objectForKey:obj];
                //对于字典，数组进行归档
                if ([value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSArray class]]) {
                    value = [NSKeyedArchiver archivedDataWithRootObject:value];
                }
                [insertDic setObject:value forKey:obj];
            }];
            //执行
            [db executeUpdate:sqlStr withParameterDictionary:insertDic];
//            NSLog(@"完成存储");
        }
    }];
}

//取数据
//- (NSArray *)getDataFromdDatabaseWithMsg:(NSString *)xuhao{
- (NSArray *)getDataFromdDatabaseWithMsg:(NSInteger)index{
    NSString *xuhao = self.cateId[index];
    NSMutableArray *modelArr = [NSMutableArray array];
       //排序
    NSString *sql =[NSString stringWithFormat:@"select * from newRead where typeid = %@ order by aid desc ",xuhao];
    FMResultSet *result = [_db executeQuery:sql];
    while ([result next]) {
        NSDictionary *dict = result.resultDictionary;
        
        NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithDictionary:dict];
        
        [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            //将二进制数据还原
            if ([obj isKindOfClass:[NSArray class]]) {
                NSDictionary *value = [NSKeyedUnarchiver unarchiveObjectWithData:obj];
                [muDic setValue:value forKey:key];
            }
            //为null
            if ([obj isKindOfClass:[NSNull class]]) {
                [muDic removeObjectForKey:key];
            }
        }];
        //字典转化为model
        HomeModels *status = [[HomeModels alloc] initWithDictionary:muDic];
        [modelArr addObject:status];
    }
    return modelArr;
}

//删除数据
- (BOOL)deleteFromeDatabase{
    //1sql 语句
    NSString *sql=@"delete from newRead";
    if (![_db executeUpdate:sql]) {
//        NSLog(@"=====%@",[_db lastErrorMessage]);
        return NO;
    }
    return YES;
}

//删除一类
- (void)deleteFromDatabaseWithCateId:(NSString *)xuhao{
    NSString *sql = @"delete from newRead where typeid = ?";
    //2.执行sql
    if (![_db executeUpdate:sql,xuhao]) {
//        NSLog(@"delete error==%@",[_db lastErrorMessage]);
    }
}

@end
