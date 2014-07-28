//
//  IntroViewController.h
//  SEVEN
//
//  Created by Bobby Ren on 7/24/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AVPlayer;
@interface IntroViewController : UIViewController <UIScrollViewDelegate>
{
    NSMutableArray *players;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (weak, nonatomic) IBOutlet UIView *barRed;
@property (weak, nonatomic) IBOutlet UIView *barBlue;
@property (weak, nonatomic) IBOutlet UIView *barGreen;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintWidthRed;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintWidthBlue;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintWidthGreen;

@end
