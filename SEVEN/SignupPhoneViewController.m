//
//  SignupPhoneViewController.m
//  SEVEN
//
//  Created by Bobby Ren on 7/4/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import "SignupPhoneViewController.h"

@interface SignupPhoneViewController ()

@end

@implementation SignupPhoneViewController

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

    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    keyboardDoneButtonView.barStyle = UIBarStyleBlack;
    keyboardDoneButtonView.translucent = YES;
    keyboardDoneButtonView.tintColor = [UIColor whiteColor];
    [keyboardDoneButtonView sizeToFit];
    [keyboardDoneButtonView setItems:@[[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", @"Done")                                                                       style:UIBarButtonItemStyleBordered target:self                                                                     action:@selector(closeKeyboardInput:)]]];

    self.inputPhone.inputAccessoryView = keyboardDoneButtonView;
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([self.inputPhone.text length]) {
        [_appDelegate currentUserInfo].phone = self.inputPhone.text;
        [self performSegueWithIdentifier:@"SignupGoToVerifyPhone" sender:self];
    }
    return YES;
}

-(void)closeKeyboardInput:(id)sender {
    [self.inputPhone resignFirstResponder];
    [self textFieldShouldReturn:self.inputPhone];
}
@end
