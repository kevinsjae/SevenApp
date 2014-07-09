//
//  SignupEmailViewController.m
//  SEVEN
//
//  Created by Bobby Ren on 7/4/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import "SignupEmailViewController.h"

@interface SignupEmailViewController ()

@end

@implementation SignupEmailViewController

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

    [self.inputEmail becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if ([self.inputEmail.text length]) {

        [PFUser currentUser].email = self.inputEmail.text;
        [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            // use parse's email validation
            if (succeeded) {
                [self performSegueWithIdentifier:@"SignupGoToGender" sender:self];
            }
            else {
                [UIAlertView alertViewWithTitle:@"Signup error" message:@"Email not saved"];
            }
        }];
    }
    return YES;
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
