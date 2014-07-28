//
//  CreateProfileViewController.h
//  SEVEN
//
//  Created by Bobby Ren on 7/27/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPCameraDelegate.h"

@class SevenCamera;
@class AVPlayer;
@interface CreateProfileViewController : UIViewController <GPCameraDelegate>
{
    AVPlayer *player;
    IBOutlet UIView *viewVideoBG;
    IBOutlet UIView *tutorialView;

    SevenCamera *camera;

    IBOutlet UILabel *labelMessage;
    IBOutlet UILabel *labelClose;

    NSDate *videoStartTimestamp;
    NSTimer *progressTimer;
}
@end
