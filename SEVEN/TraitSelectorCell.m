//
//  TraitSelectorCell.m
//  SEVEN
//
//  Created by Bobby Ren on 8/2/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import "TraitSelectorCell.h"

@implementation TraitSelectorCell
-(void)setupWithInfo:(NSDictionary *)info {
    [labelTrait setFont:FontRegular(14)];
    [labelTrait setTextColor:[UIColor whiteColor]];

    NSString *trait = info[@"trait"];
    [labelTrait setText:trait];

    UIColor *color = info[@"color"];
    self.contentView.backgroundColor = color;

    BOOL isSelected = [info[@"selected"] boolValue];
    [overlayView setHidden:!isSelected];
    [iconConfirm setHidden:!isSelected];
}
@end
