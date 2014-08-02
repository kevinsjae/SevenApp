//
//  TraitAdjustorCell.h
//  SEVEN
//
//  Created by Bobby Ren on 8/2/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TraitAdjustorCell : UITableViewCell
{
    IBOutlet UIView *opaqueView;
    IBOutlet UIView *colorView;
    IBOutlet UILabel *labelTrait;

    IBOutlet NSLayoutConstraint *constraintLeftOffset;
}

-(void)setupWithInfo:(NSDictionary *)info;
@end
