//
//  JKCycleScrollView.m
//  Pods
//
//  Created by JK.PENG on 2017/1/6.
//
//

#import "JKCycleScrollView.h"

@interface JKCycleScrollView() <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>{
    BOOL _autoScrollFlag;                  // the flag indicated if can be scrolled automatically
    BOOL _cycleScrollEnabled;              // indicated if it can be scrolled Cyclically
}

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger numberOfItems;                  // items in collectionView;
@property (nonatomic, assign) NSInteger numberOfRecources;              // numbers of dataSource
@property (nonatomic, assign) NSInteger item;
@property (nonatomic, assign) NSInteger currentPage;                    // in case the pageControl is setted in hidden;
@property (nonatomic, assign) UICollectionViewScrollDirection  scrollDirection; // default is UICollectionViewScrollDirectionVertic

@end

@implementation JKCycleScrollView


#pragma mark - life cycle
- (void)dealloc {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (instancetype)initWithFrame:(CGRect)frame scrollDirection:(UICollectionViewScrollDirection)direction{
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollDirection = direction;
        _cycleScrollEnabled = NO;
        _autoScrollFlag = NO;
        _scrollEnabled = YES;
    }
    return self;
}

#pragma mark - public methods
- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier {
    [self.collectionView registerClass:cellClass forCellWithReuseIdentifier:identifier];
}

- (id)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.item inSection:0];
    return [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
}

- (void)reloadData {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.numberOfRecources = [self.dataSource numberOfItemsInCollectionView:self];
        [self.collectionView reloadData];
        [self scrollToOriginPositon];
        [self parpreAutoScrollIfNeeded];
    });
}

- (void)stopAutoScroll {
    if (!_autoScrollFlag) {
        return;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)resumeAutoScroll {
    if (!_autoScrollFlag) {
        return;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(autoScrollCollectionView) withObject:nil afterDelay:self.autoScrollTimeInterval];
}

#pragma mark - priviate methods
- (void)autoScrollCollectionView {
    if (!_autoScrollFlag) {
        return;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    NSInteger page = [self scrollCurrentPage];
    [self scrollToPage:page+1 animated:YES];
    [self parpreAutoScrollIfNeeded];
}

- (void)scrollToPage:(NSInteger)page animated:(BOOL)animated {
    NSInteger targetPage = page;
    if (self.scrollType == JKScrollTypeAuto) {
        if (targetPage >= self.numberOfItems) {
            targetPage = 0;
        }
    }
    
    if (self.numberOfItems <= 1 || targetPage > self.numberOfItems-1) {
        return;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:targetPage inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

- (void)didScrollToPage:(NSInteger)page{
    if (!_cycleScrollEnabled) {
        self.currentPage = page;
        return;
    }
    
    if (self.numberOfItems <= 1) {
        return;
    }
    
    NSIndexPath *index;
    if (page >= 1 && page < self.numberOfItems-1) {
        self.currentPage = --page;
    } else if (page >= self.numberOfItems-1) {
        self.currentPage = 0;
        index = [NSIndexPath indexPathForItem:self.currentPage+1 inSection:0];
        [self.collectionView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    } else if (page < 1) {
        self.currentPage = self.numberOfItems-2;
        index = [NSIndexPath indexPathForItem:self.currentPage inSection:0];
        [self.collectionView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
}

- (NSInteger)itemFromIndexPath:(NSIndexPath*)indexPath {
    if (self.numberOfItems <= 1) {
        return indexPath.item;
    }
    
    NSInteger item = 0;
    switch (self.scrollType) {
        case JKScrollTypeNone:
        case JKScrollTypeAuto:
            item = indexPath.item;
            break;
        case JKScrollTypeCyclically:
        case JKScrollTypeAutoCyclically: {
            if (indexPath.item <= 0) {
                item = self.numberOfItems -3;
            } else if (indexPath.item > 0 && indexPath.item < self.numberOfItems -1) {
                item = indexPath.item - 1;
            } else if (indexPath.item >= indexPath.row - 1) {
                item = 0;
            }
            break;
        }
    }
    return item;
}

- (NSInteger)scrollCurrentPage {
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        CGFloat offsetX = self.collectionView.contentOffset.x;
        CGFloat itemWidth = CGRectGetWidth(self.collectionView.frame);
        if (offsetX >= 0){
            return  offsetX/itemWidth;
        }
    }else{
        CGFloat offsetY = self.collectionView.contentOffset.y;
        CGFloat itemHeight = CGRectGetHeight(self.collectionView.frame);
        if (offsetY >= 0){
            return  offsetY/itemHeight;
        }
    }
    return 0;
}

- (void)parpreAutoScrollIfNeeded {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoScrollCollectionView) object:nil];
    if (_autoScrollFlag) {
        [self performSelector:@selector(autoScrollCollectionView) withObject:nil afterDelay:self.autoScrollTimeInterval];
    }
}

- (void)scrollToOriginPositon {
    self.currentPage = 0;
    if (_cycleScrollEnabled && self.numberOfRecources > 1) {
        NSIndexPath *path = [NSIndexPath indexPathForItem:1 inSection:0];
        [self.collectionView scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    } else if (self.numberOfRecources == 1) {
        NSIndexPath *path = [NSIndexPath indexPathForItem:0 inSection:0];
        [self.collectionView scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    NSInteger page = [self scrollCurrentPage];
    [self didScrollToPage:page];
    if ([self.delegate respondsToSelector:@selector(collectionView:didScrollToIndex:)]) {
        [self.delegate collectionView:self didScrollToIndex:self.currentPage];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoScrollCollectionView) object:nil];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger page = [self scrollCurrentPage];
    [self didScrollToPage:page];
    [self parpreAutoScrollIfNeeded];
    if ([self.delegate respondsToSelector:@selector(collectionView:didScrollToIndex:)]) {
        [self.delegate collectionView:self didScrollToIndex:self.currentPage];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(collectionView:didSelectItemAtIndex:)]) {
        NSInteger item = [self itemFromIndexPath:indexPath];
        [self.delegate collectionView:self didSelectItemAtIndex:item];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (!self.dataSource && ![self.dataSource respondsToSelector:@selector(numberOfItemsInCollectionView:)]) {
        if (!self.dataSource) return 0;
        return 0;
    }
    
    self.numberOfRecources = [self.dataSource numberOfItemsInCollectionView:self];
    self.numberOfItems = self.numberOfRecources;
    if (self.numberOfItems <= 1) {
        return self.numberOfItems;
    }
    
    switch (self.scrollType) {
        case JKScrollTypeNone:
        case JKScrollTypeAuto:
            break;
        case JKScrollTypeAutoCyclically:
        case JKScrollTypeCyclically:
            self.numberOfItems += 2;
            break;
    }
    return self.numberOfItems;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.dataSource && ![self.dataSource respondsToSelector:@selector(collectionView:cellForItemAtIndex:)]) {
        if (!self.dataSource) return nil;
        return nil;
    }
    self.item = indexPath.row;
    NSInteger item = [self itemFromIndexPath:indexPath];
    UICollectionViewCell *cell = [self.dataSource collectionView:self cellForItemAtIndex:item];
    return cell;
}

#pragma mark - setter
- (void)setScrollType:(JKScrollTypeE)scrollType {
    if (_scrollType == scrollType) {
        return;
    }
    _scrollType = scrollType;
    switch (_scrollType) {
        case JKScrollTypeAuto:
            _cycleScrollEnabled = NO;
            _autoScrollFlag = YES;
            break;
        case JKScrollTypeAutoCyclically:
            _cycleScrollEnabled = YES;
            if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
                [self.collectionView setContentOffset:CGPointMake(CGRectGetWidth(self.bounds), 0)];
                
            }else{
                [self.collectionView setContentOffset:CGPointMake(0, CGRectGetHeight(self.bounds))];
            }
            _autoScrollFlag = YES;
            break;
        case JKScrollTypeCyclically:
            if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
                [self.collectionView setContentOffset:CGPointMake(CGRectGetWidth(self.bounds), 0)];
                
            }else{
                [self.collectionView setContentOffset:CGPointMake(0, CGRectGetHeight(self.bounds))];
            }
            _cycleScrollEnabled = YES;
            _autoScrollFlag = NO;
            break;
        case JKScrollTypeNone:
            _cycleScrollEnabled = NO;
            _autoScrollFlag = NO;
            break;
    }
}

- (void)setScrollEnabled:(BOOL)scrollEnabled{
    _scrollEnabled = scrollEnabled;
    self.collectionView.scrollEnabled = scrollEnabled;
}

#pragma mark - getter
- (NSTimeInterval)autoScrollTimeInterval {
    if (_autoScrollTimeInterval <= 3.0f) {
        _autoScrollTimeInterval = 3.0f;
    }
    return _autoScrollTimeInterval;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.scrollDirection = self.scrollDirection;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.scrollEnabled = self.scrollEnabled;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_collectionView];
        
        // align _collectionView from the left and right
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_collectionView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_collectionView)]];
        // align _collectionView from the top and bottom
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_collectionView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_collectionView)]];
    }
    return _collectionView;
}

@end
