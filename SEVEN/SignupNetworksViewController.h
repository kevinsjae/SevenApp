//
//  SignupNetworksViewController.h
//  SEVEN
//
//  Created by Bobby Ren on 7/4/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import "CommonStyledViewController.h"

@interface SignupNetworksViewController : CommonStyledViewController

@property (weak, nonatomic) IBOutlet UIButton *buttonEmail;
@property (weak, nonatomic) IBOutlet UIButton *buttonFacebook;
@property (weak, nonatomic) IBOutlet UIButton *buttonInstagram;
@property (weak, nonatomic) IBOutlet UIButton *buttonTwitter;
- (IBAction)didClickButton:(id)sender;

@end
