//
//  LookingForViewController.h
//  SEVEN
//
//  Created by Bobby Ren on 8/4/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LookingForViewController : UIViewController
{
    IBOutlet UILabel *labelMessage;

    IBOutlet UILabel *labelGuys;
    IBOutlet UILabel *labelGirls;
    IBOutlet UILabel *labelBoth;

    IBOutlet UIButton *buttonGuys;
    IBOutlet UIButton *buttonGirls;
    IBOutlet UIButton *buttonBoth;

    IBOutlet UIImageView *iconGuys;
    IBOutlet UIImageView *iconGirls;
    IBOutlet UIImageView *iconBoth;

    Gender lookingForGender;
}

-(IBAction)didClickButton:(id)sender;
@end
