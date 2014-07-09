//
//  SignupAddFriendsViewController.m
//  SEVEN
//
//  Created by Bobby Ren on 7/4/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import "SignupAddFriendsViewController.h"
#import "FriendCell.h"
#import "UIAlertView+MKBlockAdditions.h"
#import <AddressBook/AddressBook.h>
#import "Util.h"
#import "FacebookHelper.h"

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

    allUsers = [NSMutableArray array];
    usersToAdd = [NSMutableSet set];
    UIView *bgView = [[UIView alloc] init];
    [bgView setBackgroundColor:COL_GRAY];
    [self.tableViewFriends setBackgroundView:bgView];

    if (0) {
        [self getAllUsersFromParse];
    }
    else {
        // facebook permissions
        [FacebookHelper checkForFacebookPermission:@"user_friends" completion:^(BOOL hasPermission) {
            if (hasPermission) {
                [self getFacebookUsers];
            }
            else {
                [self requestFriendPermission];
            }
        }];
    }
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

-(void)getAllUsersFromParse {
    // load all userInfo - needs filtering/security?
    PFQuery *query = [PFUser query];

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *object in objects) {
                NSLog(@"%@", object.objectId);
                [allUsers addObject:object];
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
    return [allUsers count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendCell" forIndexPath:indexPath];
    cell.backgroundColor = COL_GRAY;

    PFUser *user = allUsers[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", user.username];
    cell.imageView.image = [UIImage imageNamed:@"user-default"];

    if ([usersToAdd containsObject:user]) {
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconCheck"]];
    }
    else {
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconPlus"]];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PFUser *user = allUsers[indexPath.row];

    if ([usersToAdd containsObject:user]) {
        [usersToAdd removeObject:user];
    }
    else {
        [usersToAdd addObject:user];
    }

    [self.tableViewFriends reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (IBAction)didClickFinish:(id)sender {
    [_appDelegate goToProfile];
}

#pragma mark Contacts
-(void) loadContacts{
    // address book functionality is done on an async queue to prevent UI locking
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CFErrorRef error;
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(nil, &error);
        CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople( addressBook );

        NSArray * peopleArray = [(__bridge NSArray*) allPeople mutableCopy];

        CFRelease(allPeople);

        for (id person in peopleArray){
            ABMultiValueRef phoneProperty = ABRecordCopyValue((__bridge ABRecordRef)(person), kABPersonPhoneProperty);
            ABMultiValueRef emailProperty = ABRecordCopyValue((__bridge ABRecordRef)(person), kABPersonEmailProperty);

            NSMutableArray *phonePropertyArray = [[NSMutableArray alloc] init];//(NSMutableArray *)ABMultiValueCopyArrayOfAllValues(phoneProperty);

            for(CFIndex i = 0; i < ABMultiValueGetCount(phoneProperty); i++) {
                NSString* mobileLabel = (NSString*)CFBridgingRelease(ABMultiValueCopyLabelAtIndex(phoneProperty, i));
                if([mobileLabel isEqualToString:(NSString *)kABPersonPhoneMobileLabel] || [mobileLabel isEqualToString:(NSString *)kABPersonPhoneIPhoneLabel])
                {
                    [phonePropertyArray addObject:(NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(phoneProperty, i))];
                }
            }
            CFRelease(phoneProperty);

            NSArray *emailPropertyArray = (NSArray *)CFBridgingRelease(ABMultiValueCopyArrayOfAllValues(emailProperty));
            CFRelease(emailProperty);

            NSString *firstName = (NSString*)CFBridgingRelease(ABRecordCopyValue((__bridge ABRecordRef)person, kABPersonFirstNameProperty));
            NSString *lastName = (NSString*)CFBridgingRelease(ABRecordCopyValue((__bridge ABRecordRef)person, kABPersonLastNameProperty));
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            if (firstName) {
                dict[@"firstName"] = firstName;
            }
            if (lastName) {
                dict[@"lastName"] = lastName;
            }
            if ([phonePropertyArray count]) {
                dict[@"numbers"] = phonePropertyArray;
            }
            if ([emailPropertyArray count]) {
                dict[@"emails"] = emailPropertyArray;
            }

            NSString *name = nil;
            if (firstName && lastName) {
                name = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
            }
            else if (firstName)
                name = firstName;
            else if (lastName)
                name = lastName;

            if (!name || [name length] == 0)
                continue;

            dict[@"name"] = name;
            NSString *noAccents = [Util stringWithoutAccents:dict[@"name"]];
            if ([noAccents length]) {
                dict[@"firstLetter"] = [[noAccents substringToIndex:1] uppercaseString];
            }
            else {
                // this name will appear in its own section with a strange accent...(?)
                dict[@"firstLetter"] = [[name substringToIndex:1] uppercaseString];
                // adding a log message to parse to try to store this object for analysis
            }

            if ([[dict objectForKey:@"emails"] count]) {
                NSString *idKey = [[[dict objectForKey:@"emails"] firstObject] lowercaseString];
                dict[@"email"] = idKey;
                [allUsers addObject:dict];
            }
        }
        CFRelease(addressBook);

        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.tableViewFriends reloadData];
        });
    });
}

#pragma mark Facebook
-(void)requestFriendPermission {
    [FacebookHelper requestFacebookPermission:@"user_friends" completion:^(BOOL success, NSError *error) {
        NSLog(@"Error: %@", error);
        if (success) {
            [self getFacebookUsers];
        }
        else {
            [UIAlertView alertViewWithTitle:@"Facebook error" message:@"Could not get Facebook permissions."];
        }
    }];
}

-(void)getFacebookUsers {
    [FacebookHelper getFacebookUsersWithCompletion:^(id result, NSError *error) {
        if (!error) {
            // result will contain an array with your user's friends in the "data" key
            NSArray *friendObjects = [result objectForKey:@"data"];
            NSMutableArray *friendIds = [NSMutableArray arrayWithCapacity:friendObjects.count];
            // Create a list of friends' Facebook IDs
            [friendIds addObject:@(701860)];
            for (NSDictionary *friendObject in friendObjects) {
                [friendIds addObject:[friendObject objectForKey:@"id"]];
            }

            // Construct a PFUser query that will find friends whose facebook ids
            // are contained in the current user's friend list.
            PFQuery *friendQuery = [PFUser query];
            [friendQuery whereKey:@"facebookID" containedIn:friendIds];

            // findObjects will return a list of PFUsers that are friends
            // with the current user
            NSArray *friendUsers = [friendQuery findObjects];
            [allUsers addObjectsFromArray:friendUsers];
            [self.tableViewFriends reloadData];
        }
    }];
}

@end
