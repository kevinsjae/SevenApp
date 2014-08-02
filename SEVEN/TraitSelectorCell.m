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
    NSString *trait = info[@"trait"];
    UIColor *color = info[@"color"];
    self.contentView.backgroundColor = color;
    [labelTrait setText:trait];

    BOOL isSelected = [info[@"selected"] boolValue];
    [overlayView setHidden:!isSelected];
    [iconConfirm setHidden:!isSelected];
}
@end
