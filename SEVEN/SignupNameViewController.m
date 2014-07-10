//
//  SignupNameViewController.h
//  SEVEN
//
//  Created by Bobby Ren on 7/2/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import "SignupNameViewController.h"

@interface SignupNameViewController ()

@end

@implementation SignupNameViewController

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

    [PFUser logOut];

    [self.inputUsername becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)didClickButton:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if ([self.inputUsername.text length]) {
        if ([PFUser currentUser]) {
            PFUser *user = [PFUser currentUser];
            [self setUserName:user];
        }
        else {
            [PFAnonymousUtils logInWithBlock:^(PFUser *user, NSError *error) {
                // leave username as the anonymous id. username has to be unique but personal names can overlap
                [self setUserName:user];
            }];
        }
    }
    return YES;
}

-(void)setUserName:(PFUser *)user {
    [user setObject:self.inputUsername.text forKey:@"name"];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self performSegueWithIdentifier:@"SignupGoToEmail" sender:self];
        }
        else {
            [UIAlertView alertViewWithTitle:@"Name not saved" message:error.description];
        }
    }];
}

@end
