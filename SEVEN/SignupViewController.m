//
//  SignupViewController.m
//  SEVEN
//
//  Created by Bobby Ren on 7/2/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import "SignupViewController.h"

@interface SignupViewController ()

@end

@implementation SignupViewController

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

-(IBAction)didClickButton:(id)sender {
    if ((UIButton *)sender == self.buttonEmail) {
        if ([self.inputUsername.text length] == 0) {
            [UIAlertView alertViewWithTitle:@"Username needed" message:@"Please enter a username"];
            return;
        }
        if ([self.inputUsername.text length] == 0) {
            [UIAlertView alertViewWithTitle:@"Password needed" message:@"Please enter a password"];
            return;
        }
        if ([self.inputConfirmation.text length] == 0) {
            [UIAlertView alertViewWithTitle:@"Confirmation needed" message:@"Please enter your password twice"];
            return;
        }
        if (![self.inputConfirmation.text isEqualToString:self.inputConfirmation.text]) {
            [UIAlertView alertViewWithTitle:@"Invalid password" message:@"Password and confirmation do not match"];
            return;
        }

        [self signup];
    }
    else if ((UIButton *)sender == self.buttonFacebook) {

    }
}

-(void)signup {
    [self dismissKeyboard];
    PFUser *user = [PFUser user];
    user.username = self.inputUsername.text;
    user.password = self.inputPassword.text;

    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [UIAlertView alertViewWithTitle:@"Welcome to SEVEN" message:[NSString stringWithFormat:@"Your login is %@", user.username]];
            [self performSegueWithIdentifier:@"GoToMainView" sender:self];
        }
        else {
            NSString *message = nil;
            if (error.code == 202) {
                message = @"Username already taken";
            }
            [UIAlertView alertViewWithTitle:@"Signup failed" message:message];
        }
    }];
}

-(void)dismissKeyboard {
    [self.inputUsername resignFirstResponder];
    [self.inputPassword resignFirstResponder];
    [self.inputConfirmation resignFirstResponder];
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

@end
