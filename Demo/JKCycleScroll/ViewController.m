//
//  ViewController.m
//  JKCycleScroll
//
//  Created by JK.PENG on 2017/1/6.
//  Copyright © 2017年 baidu. All rights reserved.
//

#import "ViewController.h"
#import "JKCycleScrollView.h"
#import "TestCell.h"

@interface ViewController ()<JKCyclicScrollViewDataSource, JKCyclicScrollViewDelegate>

@property (nonatomic, strong) NSArray  *data;
@property (nonatomic, strong) JKCycleScrollView *scrollView;

@end

static NSString * const kCycleScrollViewReuseIdentifer = @"kCycleScrollViewReuseIdentifer";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.data = @[@"http://img.pconline.com.cn/images/upload/upc/tx/photoblog/1410/21/c4/39944979_39944979_1413878416125_mthumb.jpg",@"http://image92.360doc.com/DownloadImg/2015/12/1715/63143393_18.jpg",@"http://f.hiphotos.baidu.com/image/pic/item/b151f8198618367a9f738e022a738bd4b21ce573.jpg",@"http://img006.hc360.cn/hb/MTQ2MDc5MzQ2ODQyNy02OTQyMjQ1MjI=.jpg"];
    [self.scrollView reloadData];
    
}

#pragma mark - JKCyclicScrollViewDataSource
- (NSInteger)numberOfItemsInCollectionView:(JKCycleScrollView *)collectionView{
    return [self.data count];
}

- (UICollectionViewCell *)collectionView:(JKCycleScrollView *)collectionView cellForItemAtIndex:(NSInteger)index{
    TestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCycleScrollViewReuseIdentifer];
    NSString *url = self.data[index];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:url]];
    return cell;
}

#pragma mark - JKCyclicScrollViewDelegate
- (void)collectionView:(JKCycleScrollView *)collectionView didSelectItemAtIndex:(NSInteger)index{

}

- (void)collectionView:(JKCycleScrollView *)collectionView didScrollToIndex:(NSInteger)index{
    
}

#pragma mark - getter
- (JKCycleScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[JKCycleScrollView alloc] initWithFrame:CGRectZero scrollDirection:UICollectionViewScrollDirectionHorizontal];
        _scrollView.backgroundColor = [UIColor orangeColor];
        _scrollView.delegate = self;
        _scrollView.dataSource = self;
        _scrollView.scrollType = JKScrollTypeAutoCyclically;
        [_scrollView registerClass:[TestCell class] forCellWithReuseIdentifier:kCycleScrollViewReuseIdentifer];
        _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:_scrollView];
        // align _collectionView from the left and right
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_scrollView]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_scrollView)]];
        // align _collectionView from the top and bottom
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-100-[_scrollView(204)]" options:NSLayoutFormatAlignAllTop metrics:nil views:NSDictionaryOfVariableBindings(_scrollView)]];
    }
    return _scrollView;
}

@end
