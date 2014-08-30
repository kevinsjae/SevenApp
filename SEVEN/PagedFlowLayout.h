//
//  PagedFlowLayout.h
//  SEVEN
//
//  Created by Bobby Ren on 8/8/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PagedFlowLayoutDelegate <NSObject>

-(int)spacing;
-(CGSize)pageSize;

@end

@interface PagedFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, weak) id delegate;

@end
