//
//  SmallPaged2FlowLayout.m
//  SEVEN
//
//  Created by Bobby Ren on 8/14/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import "SmallPaged2FlowLayout.h"

@implementation SmallPaged2FlowLayout

- (CGSize)collectionViewContentSize
{
    // Only support single section for now.
    // Only support Horizontal scroll
    NSUInteger count = [self.collectionView.dataSource collectionView:self.collectionView
                                               numberOfItemsInSection:0];

    CGSize canvasSize = _appDelegate.window.bounds.size;
    CGSize contentSize = self.itemSize;
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal)
    {
        NSUInteger rowCount = (canvasSize.height - self.itemSize.height) / (self.itemSize.height + self.minimumInteritemSpacing) + 1;
        NSUInteger columnCount = (canvasSize.width - self.itemSize.width) / (self.itemSize.width + self.minimumLineSpacing) + 1;
        NSUInteger page = ceilf((CGFloat)count / (CGFloat)(rowCount * columnCount));
        contentSize.width = page * self.itemSize.width + self.sectionInset.left + self.sectionInset.right;
    }

    return contentSize;
}

-(CGSize)itemSize {
    int width = 320;
    // must preserve ratio or we get weird offsets at top and bottom
    CGSize canvasSize = _appDelegate.window.bounds.size;
    return CGSizeMake(width, canvasSize.height/canvasSize.width*width);
}

-(UIEdgeInsets)sectionInset {
    float top = 0;
    float bottom = 0;
    float left = 0;
    float right = left;
    return UIEdgeInsetsMake(top, left, bottom, right);
}

@end
