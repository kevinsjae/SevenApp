//
//  ModalSlideFromRightTransitionSegue.m
//  SEVEN
//
//  Created by Bobby Ren on 7/27/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import "ModalSlideFromRightTransitionSegue.h"

@implementation ModalSlideFromRightTransitionSegue

-(void)perform {
    UIViewController *srcViewController = (UIViewController *) self.sourceViewController;
    UIViewController *destViewController = (UIViewController *) self.destinationViewController;

    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [srcViewController.view.window.layer addAnimation:transition forKey:nil];

    [srcViewController presentViewController:destViewController animated:NO completion:nil];
}

@end
