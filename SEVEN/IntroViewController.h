//
//  IntroViewController.h
//  SEVEN
//
//  Created by Bobby Ren on 7/24/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AVPlayer;
@class FBLoginView;
@interface IntroViewController : UIViewController <UIScrollViewDelegate, FBLoginViewDelegate>
{
    NSMutableArray *players;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (weak, nonatomic) IBOutlet UIView *viewLogo;
@property (weak, nonatomic) IBOutlet UIView *viewTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelSubtitle;

@property (weak, nonatomic) IBOutlet UIView *barRed;
@property (weak, nonatomic) IBOutlet UIView *barBlue;
@property (weak, nonatomic) IBOutlet UIView *barGreen;
@property (weak, nonatomic) IBOutlet FBLoginView *loginView;
@property (weak, nonatomic) IBOutlet UIButton *buttonFacebook;
@property (weak, nonatomic) IBOutlet UIButton *buttonFacebook2;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintWidthRed;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintWidthBlue;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintWidthGreen;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintVerticalButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintVerticalButton2;

- (IBAction)didClickButton:(id)sender;

@end
