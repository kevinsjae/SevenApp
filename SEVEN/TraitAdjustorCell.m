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

    NSString *trait = info[@"trait"];
    [labelTrait setText:trait];

    UIColor *color = info[@"color"];
    colorView.backgroundColor = color;

    if (info[@"level"]) {
        level = [info[@"level"] intValue];
    }

    [self updateLevel];
}

-(void)updateLevel {
    constraintLeftOffset.constant = MIN_X_OFFSET + level * PIXELS_PER_LEVEL;
    [colorView setNeedsUpdateConstraints];
    [UIView animateWithDuration:.5 animations:^{
        [colorView layoutIfNeeded];
    }];
}
@end
