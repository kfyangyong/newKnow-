//
//  MeTableViewController.m
//  NewRead
//
//  Created by qingyun on 16/3/15.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "MeTableViewController.h"
#import "AboutMyVC.h"
#import "FankuiVC.h"
#import "UIImageView+WebCache.h"

@interface MeTableViewController ()

@property (nonatomic,strong) NSArray *datas;

@end
@implementation MeTableViewController

static NSString *identifier = @"setCell";

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"设置";
    _datas = @[@"清除缓存",@"反馈信息",@"关于我们",@"版本更新"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    cell.textLabel.text = self.datas[indexPath.section];
    if (indexPath.section == 0) {
        //清除缓存
        NSInteger size = [[SDImageCache sharedImageCache] getSize];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f M", (CGFloat)size / 1024/1024];
    }else{
        cell.detailTextLabel.text = nil;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0://清空缓存
        {
            [[SDImageCache sharedImageCache] clearMemory];
            [[SDImageCache sharedImageCache] clearDisk];
            [tableView reloadData];
        }
            break;
        case 1:
        {
            FankuiVC *vc = [[FankuiVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            AboutMyVC *vc = [[AboutMyVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {
            NSString *str = @"已是最新版本";
            CGFloat systermVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
            NSLog(@"%f",systermVersion);
            if (systermVersion > 8.0) {
                [self showAlterWithMessage:str];
            }else{
                [self showAlterMessage:str];
            }
        }
            break;
        default:
            break;
    }
}

- (void)showAlterWithMessage:(NSString *)message{
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *acction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alter addAction:acction];
    [self presentViewController:alter animated:YES completion:nil];
}


- (void)showAlterMessage:(NSString *)message{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提醒" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alter show];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
