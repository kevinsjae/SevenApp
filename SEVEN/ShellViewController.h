//
//  ShellViewController.h
//  SEVEN
//
//  Created by Bobby Ren on 8/8/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProfileFastScrollViewController;
@class ProfilePagedBrowserViewController;

@interface ShellViewController : UIViewController
{
    ProfileFastScrollViewController *fastProfile;
    ProfilePagedBrowserViewController *pagedProfile;
}
@end
