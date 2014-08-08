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
//    [labelTrait setBackgroundColor:[UIColor grayColor]];

    trait = info[@"trait"];
    [labelTrait setText:trait];
    CGRect rect = [trait boundingRectWithSize:CGSizeMake(self.contentView.frame.size.width, labelTrait.frame.size.height)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName:labelTrait.font}
                                              context:nil];
    constraintLabelWidth.constant = rect.size.width+10;

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
    if (self.canAdjust) {
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        [self.contentView addGestureRecognizer:pan];
    }
}

-(void)updateLevel {
    constraintLeftOffsetColor.constant = MIN_X_OFFSET + (level+1) * PIXELS_PER_LEVEL;
    [colorView setNeedsUpdateConstraints];
    [colorView layoutIfNeeded];
    float barRightBorderPosition = constraintLeftOffsetColor.constant;
    float textRightBorderPosition = 20 + constraintLabelWidth.constant;
    float diff = barRightBorderPosition - textRightBorderPosition;
    if (diff < 20)
        diff = 20;
    constraintLeftOffsetLabel.constant = diff;
    [labelTrait setNeedsUpdateConstraints];
    [labelTrait layoutIfNeeded];
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
