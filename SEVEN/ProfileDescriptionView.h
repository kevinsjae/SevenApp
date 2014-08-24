//
//  ProfileDescriptionView.h
//  SEVEN
//
//  Created by Bobby Ren on 8/15/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProfileDescriptionDelegate <NSObject>

-(void)didClickExpand;
-(void)expandUp;
-(void)expandDown;

@end
@interface ProfileDescriptionView : UIView
@property (nonatomic) PFUser *user;
@property (nonatomic, weak) id delegate;

@property (weak, nonatomic) IBOutlet UIButton *buttonExpand;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelGender;
@property (weak, nonatomic) IBOutlet UILabel *labelAge;
@property (weak, nonatomic) IBOutlet UILabel *labelLocation;
@property (weak, nonatomic) IBOutlet UILabel *labelOrientation;
@property (weak, nonatomic) IBOutlet UILabel *labelDescription;
@property (weak, nonatomic) IBOutlet UILabel *labelLookingForTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelLookingForDetails;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *constraintNameWidth;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *constraintDescriptionHeight;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *constraintLookingForHeight;

-(void)setupWithUser:(PFUser *)_user;
@end
