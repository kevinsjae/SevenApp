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
}
@end
