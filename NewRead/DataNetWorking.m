//
//  DataNetWorking.m
//  NewRead
//
//  Created by 青云 on 16/3/22.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "DataNetWorking.h"
#import "AFNetworking.h"
#import "DataManager.h"
#import "comment.h"

@interface DataNetWorking ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, assign) BOOL isNew;

@end
@implementation DataNetWorking

- (NSArray *)cateId{
    if (_cateId == nil) {
        _cateId = @[kgloab,kEconomic,kEat,kTourist,kSport,kFashion,kHealth,kRead,kEnotion,kScience,kMilitary,kConstellation,kMovie];
    }
    return _cateId;
}

- (AFHTTPSessionManager *)manager{
    if (_manager == nil) {
        _manager = [[AFHTTPSessionManager alloc] init];
    }
    
    _manager.reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    __weak DataNetWorking * __weakSelf = self;
    [_manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        [__weakSelf handleNetState:status];
    }];
    //启动检测
    [_manager.reachabilityManager startMonitoring];
    return _manager;
}

// 处理网络状态改变的回调
- (void)handleNetState:(AFNetworkReachabilityStatus)state {
    if (!_delegate) {
        return;
    }
    if (_isShow) {
        return;
    }
    switch (state) {
        case AFNetworkReachabilityStatusNotReachable: {
            [self.delegate netChangeWithMessage:@"网络不可达"];
            _isShow = YES;
            break;
        }
        case AFNetworkReachabilityStatusReachableViaWWAN: {
            [self.delegate netChangeWithMessage:@"已为您切换到数据流量，是否继续使用"];
            _isShow = YES;
            break;
        }
        default:
            break;
    }
}

//请求更多
- (void)getMoreWithCateId:(NSInteger)currentIndex{
    
    NSString *url = [NSString stringWithFormat:@"http://api.myhaowai.com/appsite_api/category/get_category?devid=223a9163fb996833da252fded217590d&version=2.0.0&pcode=01100009&cateId=%@&direction=2&pageNumber=2&lastId=%@",self.cateId[currentIndex],self.lastId];
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html",@"application/javascript",@"application/json", nil];
    [self.manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //将数据存到数据库
        [[DataManager shareDB] save2DatabaseWithArray:responseObject[@"contentList"]];
        //取数据
//        NSLog(@"%@",responseObject[@"contentList"]);
        NSArray *arr = responseObject[@"contentList"];
        self.lastId =  arr.lastObject[@"lastId"];
//        NSLog(@"==========加载更多成功==========================%@==================",self.lastId);
        self.countNum = 0;
        //通知刷新table
        if (_delegate) {
            [self.delegate refreshTable];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"加载更多失败=============================");
        if (_delegate) {
            [self.delegate loadError];
        }
    }];
}


//刷新数据
- (void)getNewsWithCateId:(NSInteger)currentIndex{
    
    NSString *url = [NSString stringWithFormat:@"http://api.myhaowai.com/appsite_api/category/get_category?devid=223a9163fb996833da252fded217590d&version=2.0.0&pcode=01100009&cateId=%@&direction=1&pageNumber=2&lastId=0",self.cateId[currentIndex]];

    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html",@"application/javascript",@"application/json", nil];
    [self.manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *xuhao = self.cateId[currentIndex];
        [[DataManager shareDB] deleteFromDatabaseWithCateId:xuhao];
        //更新数
      //  self.countNum = [responseObject[@"count"] integerValue];
        //将数据转模型存储...
        NSArray *arr = responseObject[@"contentList"];
        [[DataManager shareDB] save2DatabaseWithArray:arr];
        //取数据
        self.lastId =  arr.lastObject[@"lastId"];
//        NSLog(@"==========shuaxin成功==========================%@==================",self.lastId);
        self.countNum = 1;
        if (_delegate) {
            [self.delegate refreshTable];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
     //   NSLog(@"%@",error);
        if (_delegate) {
            [self.delegate loadError];
        }
    }];
}

@end
