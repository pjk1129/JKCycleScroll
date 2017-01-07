# JKCycleScroll
简单易用的无限轮播器. 支持横向、竖向两种滑动方式

## Usage
    - (NSInteger)numberOfItemsInCollectionView:(JKCycleScrollView *)collectionView{
        return [self.data count];
    }
    
    - (UICollectionViewCell *)collectionView:(JKCycleScrollView *)collectionView cellForItemAtIndex:(NSInteger)index{
        TestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCycleScrollViewReuseIdentifer]；
        NSString *url = self.data[index];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:url]];
        return cell;
    }
    - (void)collectionView:(JKCycleScrollView *)collectionView didSelectItemAtIndex:(NSInteger)index{
        NSLog(@"didSelectItemAtIndex: %@",@(index));
    }
    - (void)collectionView:(JKCycleScrollView *)collectionView didScrollToIndex:(NSInteger)index{
        NSLog(@"didScrollToIndex: %@",@(index));
    }


## Author

iJecky <http://weibo.com/rubbishpicker>

## License

JKCycleScroll is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
