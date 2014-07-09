//
//  SignupAddFriendsViewController.h
//  SEVEN
//
//  Created by Bobby Ren on 7/4/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import "CommonStyledViewController.h"

typedef enum {
    ConnectTypeNone,
    ConnectTypeEmail,
    ConnectTypeFacebook,
    ConnectTypeInstagram,
    ConnectTypeTwitter
} ConnectType;

@interface SignupAddFriendsViewController : CommonStyledViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *allUsers;
    NSMutableSet *usersToAdd;
}
@property (weak, nonatomic) IBOutlet UITableView *tableViewFriends;
@property (nonatomic) ConnectType connectType;

- (IBAction)didClickFinish:(id)sender;

@end
