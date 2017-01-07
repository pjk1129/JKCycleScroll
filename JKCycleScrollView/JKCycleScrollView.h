//
//  JKCycleScrollView.h
//  Pods
//
//  Created by JK.PENG on 2017/1/6.
//
//

#import <UIKit/UIKit.h>

@class JKCycleScrollView;

typedef NS_ENUM(NSUInteger, JKScrollTypeE) {
    JKScrollTypeNone = 0,                  // only scroll manually;
    JKScrollTypeAuto = 1,                  // scoll automatically without cyclic, when scroll to the end, it will scroll back to the first item;
    JKScrollTypeCyclically = 2,            // scroll manually, and when scroll to the end, it will still scroll to the next -- the first item
    JKScrollTypeAutoCyclically = 3,        // the same as the BMBannerScrollTypeCyclically, and add the automatic feature.
};

@protocol JKCyclicScrollViewDelegate <NSObject>
@optional
- (void)collectionView:(JKCycleScrollView *)collectionView didSelectItemAtIndex:(NSInteger)index;
- (void)collectionView:(JKCycleScrollView *)collectionView didScrollToIndex:(NSInteger)index;

@end

@protocol JKCyclicScrollViewDataSource <NSObject>
@required
- (UICollectionViewCell *)collectionView:(JKCycleScrollView *)collectionView cellForItemAtIndex:(NSInteger)index;
- (NSInteger)numberOfItemsInCollectionView:(JKCycleScrollView *)collectionView;

@end

@interface JKCycleScrollView : UIView

@property (nonatomic, weak) id<JKCyclicScrollViewDataSource> dataSource;
@property (nonatomic, weak) id<JKCyclicScrollViewDelegate> delegate;
@property (nonatomic, assign) JKScrollTypeE scrollType;            // set the scroll polocy;
@property (nonatomic, assign) NSTimeInterval autoScrollTimeInterval;    // default is 3.0;
@property (nonatomic, assign) BOOL          scrollEnabled;                  // default YES. turn off any dragging temporarily


- (instancetype)initWithFrame:(CGRect)frame scrollDirection:(UICollectionViewScrollDirection)direction;

- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier;
- (id)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier;

- (void)reloadData;

- (void)stopAutoScroll;
- (void)resumeAutoScroll;

@end
