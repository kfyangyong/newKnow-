//
//  FankuiVC.m
//  NewRead
//
//  Created by 青云 on 16/3/22.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "FankuiVC.h"

@interface FankuiVC ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation FankuiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *iterm = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(popMessage)];
    self.navigationItem.rightBarButtonItem = iterm;
}

//提交反馈
- (void)popMessage{
    [self.navigationController popToRootViewControllerAnimated:YES];
    //返回反馈信息
   // NSString *message = self.textView.text;
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
