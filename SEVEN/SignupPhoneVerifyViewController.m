//
//  SignupPhoneVerifyViewController.m
//  SEVEN
//
//  Created by Bobby Ren on 7/4/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import "SignupPhoneVerifyViewController.h"

@interface SignupPhoneVerifyViewController ()

@end

@implementation SignupPhoneVerifyViewController

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

    self.inputCode.inputAccessoryView = keyboardDoneButtonView;
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
    if ([self.inputCode.text length]) {
        // todo: do some web request to check against the verification
        [self performSegueWithIdentifier:@"SignupGoToNetworks" sender:self];
    }
    return YES;
}

- (IBAction)didClickButton:(id)sender {
    // resend code via SMS
}

-(void)closeKeyboardInput:(id)sender {
    [self.inputCode resignFirstResponder];
    [self textFieldShouldReturn:self.inputCode];
}
@end
