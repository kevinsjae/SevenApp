//
//  SevenCamera.h
//  SEVEN
//
//  Created by Bobby Ren on 7/28/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import "GPCamera.h"

@interface SevenCamera : GPCamera
{
    NSTimer *timer;
}

-(void)addProgressIndicator:(UIView *)progressIndicator;
@end
