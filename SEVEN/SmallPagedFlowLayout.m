//
//  SmallPagedFlowLayout.m
//  SEVEN
//
//  Created by Bobby Ren on 8/8/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import "SmallPagedFlowLayout.h"

@implementation SmallPagedFlowLayout

- (CGSize)collectionViewContentSize
{
    // Only support single section for now.
    // Only support Horizontal scroll
    NSUInteger count = [self.collectionView.dataSource collectionView:self.collectionView
                                               numberOfItemsInSection:0];

    CGSize canvasSize = self.collectionView.frame.size;
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

- (CGRect)frameForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize canvasSize = self.collectionView.frame.size;

    NSUInteger rowCount = (canvasSize.height - self.itemSize.height) / (self.itemSize.height + self.minimumInteritemSpacing) + 1;
    NSUInteger columnCount = (canvasSize.width - self.itemSize.width) / (self.itemSize.width + self.minimumLineSpacing) + 1;

    NSUInteger page = indexPath.row / (rowCount * columnCount);
    NSUInteger remainder = indexPath.row - page * (rowCount * columnCount);
    NSUInteger row = remainder / columnCount;
    NSUInteger column = remainder - row * columnCount;

    CGRect cellFrame = CGRectZero;
    cellFrame.origin.x = column * (self.itemSize.width + self.minimumLineSpacing);
    cellFrame.origin.y = row * (self.itemSize.height + self.minimumInteritemSpacing);
    cellFrame.size.width = self.itemSize.width;
    cellFrame.size.height = self.itemSize.height;

    /*
    NSLog(@"index %d row %d col %d page %d", indexPath.row, row, column, page);
    if (page > 0)
        NSLog(@"Here");
     */

    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal)
    {
        cellFrame.origin.x += page * (self.itemSize.width+self.minimumInteritemSpacing) + self.sectionInset.left;
    }

    return cellFrame;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes * attr = [super layoutAttributesForItemAtIndexPath:indexPath];
    attr.frame = [self frameForItemAtIndexPath:indexPath];
    return attr;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSUInteger count = [self.collectionView.dataSource collectionView:self.collectionView
                                               numberOfItemsInSection:0];

    NSMutableArray * attrs = [NSMutableArray array];

    for (NSUInteger idx = 0; idx < count; ++idx)
    {
        UICollectionViewLayoutAttributes * attr = nil;
        NSIndexPath * idxPath = [NSIndexPath indexPathForRow:idx inSection:0];
        CGRect itemFrame = [self frameForItemAtIndexPath:idxPath];
        if (CGRectIntersectsRect(itemFrame, rect))
        {
            attr = [self layoutAttributesForItemAtIndexPath:idxPath];
            [attrs addObject:attr];
        }
    }
    
    return attrs;
}

-(UICollectionViewScrollDirection)scrollDirection {
    return UICollectionViewScrollDirectionHorizontal;
}


#pragma mark flow layout delegate
// these specify the layout for this flow, not the flowlayoutdelegate functions
-(CGFloat)minimumInteritemSpacing {
    return 0;
}

-(CGFloat)minimumLineSpacing {
    return 0;
}

-(UIEdgeInsets)sectionInset {
    float top = 0;
    float bottom = 0;
    float left = 40;
    float right = 40;
    return UIEdgeInsetsMake(top, left, bottom, right);
}
 
-(CGSize)itemSize {
    float width = 240;
    // must preserve ratio or we get weird offsets at top and bottom
    return CGSizeMake(width, self.collectionView.frame.size.height/self.collectionView.frame.size.width*width);
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    CGSize collectionViewSize = self.collectionView.bounds.size;
    CGFloat proposedContentOffsetCenterX = proposedContentOffset.x + self.collectionView.bounds.size.width * 0.5f;

    CGRect proposedRect = self.collectionView.bounds;
    float velocityContribution = fabs(velocity.x) > 2? fabs(velocity.x)*200:0;
    proposedRect.size.width += velocityContribution;
    if (velocity.x < 0) {
        proposedRect.origin.x -= velocityContribution;
    }
    NSLog(@"Velocity: %f contribute %f ", velocity.x, velocityContribution);

    // Comment out if you want the collectionview simply stop at the center of an item while scrolling freely
    // proposedRect = CGRectMake(proposedContentOffset.x, 0.0, collectionViewSize.width, collectionViewSize.height);

    UICollectionViewLayoutAttributes* candidateAttributes;
    for (UICollectionViewLayoutAttributes* attributes in [self layoutAttributesForElementsInRect:proposedRect])
    {

        // == Skip comparison with non-cell items (headers and footers) == //
        if (attributes.representedElementCategory != UICollectionElementCategoryCell)
        {
            continue;
        }

        // == First time in the loop == //
        if(!candidateAttributes)
        {
            candidateAttributes = attributes;
            continue;
        }

        if (fabsf(attributes.center.x - proposedContentOffsetCenterX) < fabsf(candidateAttributes.center.x - proposedContentOffsetCenterX))
        {
            candidateAttributes = attributes;
        }
    }

    return CGPointMake(candidateAttributes.center.x - self.collectionView.bounds.size.width * 0.5f, proposedContentOffset.y);

}

@end
