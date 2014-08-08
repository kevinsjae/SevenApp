//
//  ProfilePagedBrowserViewController.h
//  SEVEN
//
//  Created by Bobby Ren on 8/8/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import "LazyPagedViewController.h"

@interface ProfilePagedBrowserViewController : LazyPagedViewController
{
    int page;
    NSMutableArray *allUsers;
}
@end
