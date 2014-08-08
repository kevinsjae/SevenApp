//
//  ShellViewController.h
//  SEVEN
//
//  Created by Bobby Ren on 8/8/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileScrollProtocol.h"

@class ProfileFastScrollViewController;
@class ProfilePagedBrowserViewController;

@interface ShellViewController : UIViewController <ProfileScrollProtocol>
{
    ProfileFastScrollViewController *fastProfile;
    ProfilePagedBrowserViewController *pagedProfile;

    int currentPage;

    NSMutableArray *allUsers;
}


@end
