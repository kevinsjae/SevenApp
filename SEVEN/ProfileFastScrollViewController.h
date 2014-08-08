//
//  FastScrollViewController.h
//  SEVEN
//
//  Created by Bobby Ren on 8/8/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileScrollProtocol.h"

@interface ProfileFastScrollViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    IBOutlet UICollectionView *_collectionView;

    NSMutableDictionary *profileViewControllers;
    int page;
}

@property (nonatomic) id<ProfileScrollProtocol> delegate;
@property (nonatomic) NSMutableArray *allUsers;

-(void)jumpToPage:(int)page animated:(BOOL)animated;
@end
