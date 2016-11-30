//
//  DetailVC.m
//  NewRead
//
//  Created by 青云 on 16/3/19.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "DetailVC.h"
#import "AFNetworking.h"
@interface DetailVC ()<UIWebViewDelegate>

@property (nonatomic,strong) UIWebView *webView;

@end

@implementation DetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"详情"];
    self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    //加载页面
    NSString *url = [NSString stringWithFormat:@"http://api.myhaowai.com/appsite_api/html5/get_page?page=content&aid=%@&collected=0",self.aid];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
