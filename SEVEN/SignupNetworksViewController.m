//
//  SignupNetworksViewController.m
//  SEVEN
//
//  Created by Bobby Ren on 7/4/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import "SignupNetworksViewController.h"
#import "UIAlertView+MKBlockAdditions.h"
#import <AddressBook/AddressBook.h>
#import "FacebookHelper.h"

@interface SignupNetworksViewController ()

@end

@implementation SignupNetworksViewController

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

- (IBAction)didClickButton:(id)sender {
    if ((UIButton *)sender == self.buttonEmail) {
        [self initializeContactsPermission];
    }
    else if ((UIButton *)sender == self.buttonFacebook) {
        [self initializeFacebookPermission];
    }
    else {
        [self performSegueWithIdentifier:@"SignupGoToAddFriends" sender:self];
    }
}

#pragma mark Contacts/Address book
#pragma mark Contacts
-(void)initializeContactsPermission {
    ABAuthorizationStatus authStatus =  ABAddressBookGetAuthorizationStatus ();
    if (authStatus == kABAuthorizationStatusNotDetermined) {
        CFErrorRef error;
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(nil, &error);
        ABAddressBookRequestAccessWithCompletion(addressBook , ^(bool granted, CFErrorRef error){
            if (granted){
                [self performSegueWithIdentifier:@"SignupGoToAddFriends" sender:self];
            }
            else {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [UIAlertView alertViewWithTitle:@"Contact access denied" message:@"SEVEN will not be able to access your contacts list. To change this, please go to Settings->Privacy->Contacts to enable access." cancelButtonTitle:@"Close" otherButtonTitles:nil onDismiss:nil onCancel:^{
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                });
            }
        });
    }
    else if (authStatus == kABAuthorizationStatusAuthorized){
        [self performSegueWithIdentifier:@"SignupGoToAddFriends" sender:nil];
    }
    else {
        // already denied, cannot request it
        [UIAlertView alertViewWithTitle:@"Could not access contacts" message:@"In order to connect with friends, SEVEN needs access to your contact list. Please go to Settings->Privacy->Contacts to enable access." cancelButtonTitle:@"Close" otherButtonTitles:nil onDismiss:nil onCancel:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}

#pragma mark Facebook
-(void)initializeFacebookPermission {
    if (![PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        [PFFacebookUtils linkUser:[PFUser currentUser] permissions:@[@"user_friends"] block:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [UIAlertView alertViewWithTitle:@"You are now connected with facebook" message:nil];

                // get user info and store it so we can find this user
                [FacebookHelper updateFacebookUserInfo];

                [self performSegueWithIdentifier:@"SignupGoToAddFriends" sender:nil];
            }
            else {
                [UIAlertView alertViewWithTitle:@"Facebook connect error" message:error.description];
            }
        }];
    }
    else {
        [self performSegueWithIdentifier:@"SignupGoToAddFriends" sender:self];
    }
}

@end
