//
//  TraitAdjustorCell.m
//  SEVEN
//
//  Created by Bobby Ren on 8/2/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import "TraitAdjustorCell.h"

@implementation TraitAdjustorCell
-(void)setupWithInfo:(NSDictionary *)info {
    [labelTrait setFont:FontMedium(14)];
    [labelTrait setTextColor:[UIColor whiteColor]];

    trait = info[@"trait"];
    [labelTrait setText:trait];

    UIColor *color = info[@"color"];
    colorView.backgroundColor = color;

    if (info[@"level"]) {
        level = [info[@"level"] intValue];
    }
    else {
        level = 0;
    }

    [self updateLevel];

    for (UIGestureRecognizer * gesture in self.contentView.gestureRecognizers) {
        [self.contentView removeGestureRecognizer:gesture];
    }
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [self.contentView addGestureRecognizer:pan];
}

-(void)updateLevel {
    constraintLeftOffset.constant = MIN_X_OFFSET + (level+1) * PIXELS_PER_LEVEL;
    [colorView setNeedsUpdateConstraints];
    [UIView animateWithDuration:.5 animations:^{
        [colorView layoutIfNeeded];
    }];
}

-(void)handleGesture:(UIGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:self.contentView];
    if (gesture.state == UIGestureRecognizerStateBegan) {
        gestureStart = location;
        levelStart = level;
    }
    else if (gesture.state == UIGestureRecognizerStateChanged) {
        float xoffset = location.x - gestureStart.x;
        level = MIN(MAX_TRAIT_LEVEL, MAX(MIN_TRAIT_LEVEL, levelStart + xoffset / PIXELS_PER_LEVEL));
        [self updateLevel];
    }
    else if (gesture.state == UIGestureRecognizerStateEnded) {
        // save new level
        [self.delegate didChangeTrait:trait level:level];
    }
}
@end
