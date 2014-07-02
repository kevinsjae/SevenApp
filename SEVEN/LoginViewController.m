//
//  LoginViewController.m
//  SEVEN
//
//  Created by Bobby Ren on 7/2/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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

-(IBAction)didClickButton:(id)sender {
    if ((UIButton *)sender == self.buttonEmail) {
        if ((UIButton *)sender == self.buttonEmail) {
            if ([self.inputUsername.text length] == 0) {
                [UIAlertView alertViewWithTitle:@"Username needed" message:@"Please enter a username"];
                return;
            }
            if ([self.inputPassword.text length] == 0) {
                [UIAlertView alertViewWithTitle:@"Password needed" message:@"Please enter a password"];
                return;
            }

            [self login];
        }
    }
    else if ((UIButton *)sender == self.buttonFacebook) {

    }
    else if ((UIButton *)sender == self.buttonBack) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)login {
    [self dismissKeyboard];

    [PFUser logInWithUsernameInBackground:self.inputUsername.text password:self.inputPassword.text block:^(PFUser *user, NSError *error) {
        if (user) {
            [UIAlertView alertViewWithTitle:@"Welcome to SEVEN" message:[NSString stringWithFormat:@"Good to see you, %@", user.username]];

            [self performSegueWithIdentifier:@"GoToMainView" sender:self];
        }
        else {
            NSString *message = nil;
            if (error.code == 101) {
                message = @"Invalid username or password";
            }
            [UIAlertView alertViewWithTitle:@"Login failed" message:message];
        }
    }];
}

-(void)dismissKeyboard {
    [self.inputUsername resignFirstResponder];
    [self.inputPassword resignFirstResponder];
}
@end
