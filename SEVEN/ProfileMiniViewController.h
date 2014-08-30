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

@class ProfileViewController;
@interface ProfileMiniViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, PagedFlowLayoutDelegate>
{
    IBOutlet UICollectionView *_collectionView;
    int page;
}

@property (nonatomic) id<ProfileScrollProtocol> delegate;
@property (nonatomic, weak) NSMutableArray *allUsers;
@property (nonatomic) NSMutableDictionary *profileViewControllers;
@property (nonatomic) BOOL isMini;

-(int)pageWidth;
-(int)pageHeight;
-(void)jumpToPage:(int)page animated:(BOOL)animated;
-(void)refresh;
-(ProfileViewController *)profileForIndex:(NSIndexPath *)index;
-(ProfileViewController *)currentProfile;
@end
