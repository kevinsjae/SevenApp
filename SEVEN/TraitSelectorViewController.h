//
//  TraitSelectorViewController.h
//  SEVEN
//
//  Created by Bobby Ren on 7/29/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum TraitMode {
    TraitModeSelect,
    TraitModeAdjust
} TraitMode;

@interface TraitSelectorViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UILabel *labelMessage;
    NSMutableArray *allTraits;
    NSMutableArray *allColors;
    NSMutableArray *isSelected;

    NSMutableArray *allSelectedTraits;
    NSMutableArray *allSelectedColors; // to keep rows consistent in coloring
    NSMutableArray *allLevels;

    IBOutlet UITableView *tableview;

    BOOL mode;
}
@end
