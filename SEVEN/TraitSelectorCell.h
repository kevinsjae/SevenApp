//
//  TraitSelectorCell.h
//  SEVEN
//
//  Created by Bobby Ren on 8/2/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TraitSelectorCell : UITableViewCell
{
    IBOutlet UIView *opaqueView;
    IBOutlet UILabel *labelTrait;
    IBOutlet UIImageView *iconConfirm;
}

-(void)setupWithInfo:(NSDictionary *)info;
@end
