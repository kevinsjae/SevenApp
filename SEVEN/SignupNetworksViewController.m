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
#import "SignupAddFriendsViewController.h"

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
    [self.buttonEmail setTag:ConnectTypeEmail];
    [self.buttonFacebook setTag:ConnectTypeFacebook];
    [self.buttonInstagram setTag:ConnectTypeInstagram];
    [self.buttonTwitter setTag:ConnectTypeTwitter];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    SignupAddFriendsViewController *controller = (SignupAddFriendsViewController *)[segue destinationViewController];
    // Pass the selected object to the new view controller.
    [controller setConnectType:((UIButton *)sender).tag];
}

- (IBAction)didClickButton:(id)sender {
    [self performSegueWithIdentifier:@"SignupGoToAddFriends" sender:sender];
}

@end
