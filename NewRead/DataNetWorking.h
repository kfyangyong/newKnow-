//
//  DataNetWorking.h
//  NewRead
//
//  Created by 青云 on 16/3/22.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AboutNetData <NSObject>

- (void)refreshTable;

//加载失败
- (void)loadError;

//网络更改
- (void)netChangeWithMessage:(NSString *)message;
@end
@interface DataNetWorking : NSObject

@property (nonatomic, strong) NSArray *cateId;
@property (nonatomic, assign) NSInteger countNum;
@property (nonatomic, assign) id<AboutNetData> delegate;

//请求更多
- (void)getMoreWithCateId:(NSInteger)currentIndex;

//刷新数据
- (void)getNewsWithCateId:(NSInteger)currentIndex;

@end
