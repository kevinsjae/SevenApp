//
//  VideoProgressIndicator.h
//  SEVEN
//
//  Created by Bobby Ren on 7/28/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoProgressIndicator : UIView
{
    NSMutableArray *percents;
    NSArray *colors;
}

-(float)updateProgress:(float)timeInSec;
-(void)updateAllProgress:(NSArray *)videoLengths;
@end
