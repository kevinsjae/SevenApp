//
//  FastScrollViewController.h
//  SEVEN
//
//  Created by Bobby Ren on 8/8/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileScrollProtocol.h"
#import "PagedFlowLayout.h"
#import "ProfileViewController.h"

@class ProfileViewController;
@interface ProfileScrollViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, PagedFlowLayoutDelegate, ProfileViewDelegate>
{
    IBOutlet UICollectionView *_collectionView;
    int page;
}

@property (nonatomic) id<ProfileScrollProtocol> delegate;
@property (nonatomic, weak) NSMutableArray *allUsers;
@property (nonatomic) NSMutableDictionary *profileViewControllers;
@property (nonatomic) BOOL isMini;

-(CGSize)pageSize; // actual size of profile
-(CGSize)pageBounds; // contains the spacing

-(void)jumpToPage:(int)page animated:(BOOL)animated;
-(void)refresh;
-(ProfileViewController *)profileForIndex:(NSIndexPath *)index;
-(ProfileViewController *)currentProfile;
@end
