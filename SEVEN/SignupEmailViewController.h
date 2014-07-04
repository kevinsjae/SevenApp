//
//  SignupEmailViewController.h
//  SEVEN
//
//  Created by Bobby Ren on 7/4/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonStyledViewController.h"

@interface SignupEmailViewController : CommonStyledViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *inputEmail;

@end
