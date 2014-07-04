//
//  SignupNameViewController.h
//  SEVEN
//
//  Created by Bobby Ren on 7/2/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonStyledViewController.h"

@interface SignupNameViewController : CommonStyledViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *inputUsername;
- (IBAction)didClickButton:(id)sender;

@end
