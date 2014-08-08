//
//  ProfilePagedBrowserViewController.h
//  SEVEN
//
//  Created by Bobby Ren on 8/8/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import "LazyPagedViewController.h"
#import "ProfileScrollProtocol.h"

@interface ProfilePagedBrowserViewController : LazyPagedViewController
{
    int page;
    NSMutableDictionary *profileViewControllers;
}

@property (nonatomic) id<ProfileScrollProtocol> delegate;
@property (nonatomic) NSMutableArray *allUsers;

-(void)jumpToPage:(int)page animated:(BOOL)animated;
@end
