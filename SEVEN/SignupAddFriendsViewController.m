//
//  SignupAddFriendsViewController.m
//  SEVEN
//
//  Created by Bobby Ren on 7/4/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import "SignupAddFriendsViewController.h"
#import "FriendCell.h"

@interface SignupAddFriendsViewController ()

@end

@implementation SignupAddFriendsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    allUserInfo = [NSMutableArray array];
    [self getUserInfoFromParse];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)getUserInfoFromParse {
    // load all userInfo - needs filtering/security?
    PFQuery *query = [PFQuery queryWithClassName:@"UserInfo"];
    [query includeKey:@"user"];

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *object in objects) {
                NSLog(@"%@", object.objectId);
                UserInfo *userInfo = [UserInfo fromPFObject:object];
                if (![allUserInfo containsObject:userInfo]) {
                    [allUserInfo addObject:userInfo];
                }
            }
            [self.tableViewFriends reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

}

#pragma mark Tableview Datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [allUserInfo count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendCell" forIndexPath:indexPath];

    UserInfo *userInfo = allUserInfo[indexPath.row];
    PFUser *user = userInfo.user;
    cell.textLabel.text = [NSString stringWithFormat:@"%@ --> %@", user.username, userInfo.email];
    return cell;
    
}
@end
