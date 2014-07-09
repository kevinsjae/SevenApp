//
//  SignupAddFriendsViewController.h
//  SEVEN
//
//  Created by Bobby Ren on 7/4/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import "CommonStyledViewController.h"

@interface SignupAddFriendsViewController : CommonStyledViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *allUsers;
    NSMutableSet *usersToAdd;
}
@property (weak, nonatomic) IBOutlet UITableView *tableViewFriends;

- (IBAction)didClickFinish:(id)sender;

@end
