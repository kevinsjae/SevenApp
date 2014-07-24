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

@end
