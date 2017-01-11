//
//  TestCell.m
//  JKCycleScroll
//
//  Created by JK.PENG on 2017/1/6.
//  Copyright © 2017年 baidu. All rights reserved.
//

#import "TestCell.h"

@implementation TestCell

- (instancetype)initWithFrame:(CGRect)frame{
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
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_imageView];
        // align _imageView from the left and right
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-2-[_imageView]-2-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_imageView)]];
        // align _imageView from the top and bottom
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-2-[_imageView]-2-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_imageView)]];
    }
    return _imageView;
}

@end
