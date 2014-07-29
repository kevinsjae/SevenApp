//
//  CreateProfileViewController.h
//  SEVEN
//
//  Created by Bobby Ren on 7/27/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRCameraViewController.h"

@class AVPlayer;
@class VideoProgressIndicator;

@interface CreateProfileViewController : UIViewController <UIGestureRecognizerDelegate, BRCameraDelegate>
{
    AVPlayer *player;
    IBOutlet UIView *viewVideoBG;
    IBOutlet UIView *tutorialView;

    BRCameraViewController *cameraController;

    IBOutlet UILabel *labelMessage;
    IBOutlet UILabel *labelClose;

    NSDate *videoStartTimestamp;
    NSTimer *progressTimer;

    IBOutlet UIView *progressBG;
    VideoProgressIndicator *progressIndicator;

    NSMutableArray *mediaURLs;
    NSMutableArray *mediaLengths;

    BOOL cameraReady;
    BOOL shouldShowCameraOnAppear;
}
@end
