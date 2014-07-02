//
//  LoginViewController.h
//  SEVEN
//
//  Created by Bobby Ren on 7/2/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *inputUsername;
@property (weak, nonatomic) IBOutlet UITextField *inputPassword;
@property (weak, nonatomic) IBOutlet UIButton *buttonEmail;
@property (weak, nonatomic) IBOutlet UIButton *buttonFacebook;
- (IBAction)didClickButton:(id)sender;

@end
