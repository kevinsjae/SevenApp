//
//  ShellViewController.h
//  SEVEN
//
//  Created by Bobby Ren on 8/8/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileScrollProtocol.h"

@class ProfileMiniViewController;
@class ProfileViewController;
@class MBProgressHUD;

@interface ShellViewController : UIViewController <ProfileScrollProtocol>
{
    ProfileMiniViewController *miniProfile;

    int currentPage;

    NSMutableArray *allUsers;

    MBProgressHUD *progress;
}

-(ProfileMiniViewController *)miniProfile;
@end
