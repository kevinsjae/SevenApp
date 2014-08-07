//
//  ProfileViewController.h
//  SEVEN
//
//  Created by Bobby Ren on 8/7/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileVideoPreviewViewController.h"

@class AVPlayer;
@class AVPlayerLayer;
@interface ProfileViewController : ProfileVideoPreviewViewController

-(void)playCurrentMedia;
@end
