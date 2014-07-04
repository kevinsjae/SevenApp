//
//  SignupPhoneVerifyViewController.h
//  SEVEN
//
//  Created by Bobby Ren on 7/4/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonStyledViewController.h"

@interface SignupPhoneVerifyViewController : CommonStyledViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *inputCode;
@property (weak, nonatomic) IBOutlet UIButton *buttonResend;
- (IBAction)didClickButton:(id)sender;

@end
