//
//  ShellViewController.h
//  SEVEN
//
//  Created by Bobby Ren on 8/8/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileScrollProtocol.h"

@class ProfileScrollViewController;
@class ProfileViewController;
@class MBProgressHUD;

@interface ShellViewController : UIViewController <ProfileScrollProtocol>
{
    ProfileScrollViewController *miniProfile;

    int currentPage;

    NSMutableArray *allUsers;

    MBProgressHUD *progress;
    IBOutlet UILabel *labelName;
}

-(ProfileScrollViewController *)miniProfile;
@end
