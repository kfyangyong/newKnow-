//
//  comment.h
//  NewRead
//
//  Created by qingyun on 16/3/13.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#ifndef comment_h
#define comment_h

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height

#define kMyURL @"http://api.myhaowai.com/appsite_api/category/get_category?"
#define kDevid @"223a9163fb996833da252fded217590d"
#define kVersion @"2.0.0"
#define kPcode @"01100009"

#define kTourist @"1508"//旅游
#define kEat @"1506"//美食
#define kConstellation @"1531"//星座
#define kMovie @"1512"//电影
#define kHealth @"1499"//健康
#define kEnotion @"1500"//情感
#define kRead @"1503"//阅读
#define kScience @"1502"//科技
#define kCar @"1515"//车
#define kFashion @"1505"//时尚
#define kSport @"1528"//运动
#define kMilitary @"1514"//军事
#define kEconomic @"1511"//财经

#define kgloab @"1497"

#define kTipAlert7(s, ...)     [[[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:(s), ##__VA_ARGS__] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil] show]
#define kTipAlert(s, ...) {UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示"                                                      message:[NSString stringWithFormat:(s), ##__VA_ARGS__]                                                       preferredStyle:UIAlertControllerStyleAlert];UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault                                                     handler:^(UIAlertAction * action) {}];[alert addAction:defaultAction];[self presentViewController:alert animated:YES completion:nil];}

#endif /* comment_h */
