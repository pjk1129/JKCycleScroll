//
//  TestCell.m
//  JKCycleScroll
//
//  Created by JK.PENG on 2017/1/6.
//  Copyright © 2017年 baidu. All rights reserved.
//

#import "TestCell.h"

@implementation TestCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self imageView];
    }
    return self;
}

#pragma mark -  getter
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(2, 2, 2, 2));
        }];
    }
    return _imageView;
}

@end
