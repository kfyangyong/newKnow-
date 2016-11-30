//
//  UINavigationController+Notifion.m
//  NewRead
//
//  Created by 青云 on 16/3/20.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "UINavigationController+Notifion.h"

@implementation UINavigationController (Notifion)

//类的扩展 用于弹出视图
- (void)showNavigationViewWithTitle:(NSString *)title{
    
    //获取当前视图控制器
    if (self.viewControllers.count >1 ) {
        NSLog(@"%lu",(unsigned long)self.viewControllers.count);
        return;
    }
    //创建label
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
    lable.font = [UIFont systemFontOfSize:17];
    lable.backgroundColor = [UIColor orangeColor];
    [lable setText:title];
    lable.tintColor = [UIColor whiteColor];
    lable.textAlignment = NSTextAlignmentCenter;
    [self.view insertSubview:lable belowSubview:self.navigationBar];
    
    //弹出
    [UIView animateWithDuration:0.5 animations:^{
        lable.frame = CGRectMake(0, 64,[UIScreen mainScreen].bounds.size.width, 30);
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 delay:0.5 options:0 animations:^{
            lable.frame = CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, 30);
        } completion:^(BOOL finished) {
            [lable removeFromSuperview];
        }];
    }];
}
@end
