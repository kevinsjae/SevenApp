//
//  TraitAdjustorCell.h
//  SEVEN
//
//  Created by Bobby Ren on 8/2/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MIN_TRAIT_LEVEL 0
#define MAX_TRAIT_LEVEL 99
#define MIN_X_OFFSET 20
#define MAX_X_OFFSET 320
#define PIXELS_PER_LEVEL ( (MAX_X_OFFSET - MIN_X_OFFSET) / (MAX_TRAIT_LEVEL - MIN_TRAIT_LEVEL + 1) )

@interface TraitAdjustorCell : UITableViewCell
{
    IBOutlet UIView *opaqueView;
    IBOutlet UIView *colorView;
    IBOutlet UILabel *labelTrait;

    IBOutlet NSLayoutConstraint *constraintLeftOffset;

    int level;
}

-(void)setupWithInfo:(NSDictionary *)info;
@end
