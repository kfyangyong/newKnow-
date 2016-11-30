//
//  HomeCell.m
//  小知
//
//  Created by qingyun on 16/3/9.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "HomeCell.h"
#import "HomeModels.h"
#import "UIImageView+WebCache.h"

@interface HomeCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property (weak, nonatomic) IBOutlet UILabel *redNumberLabel;

@end

@implementation HomeCell

- (void)setModel:(HomeModels *)model{
    _model = model;
    _titleLabel.text = model.title;
    _sourceLabel.text = model.nickname;
    _redNumberLabel.text =[ NSString stringWithFormat:@"阅读%ld", (long)model.readNum];
    [_imgView sd_setImageWithURL:[NSURL URLWithString:model.imgurl] placeholderImage:[UIImage imageNamed:@"social-placeholder"]];
}

@end
