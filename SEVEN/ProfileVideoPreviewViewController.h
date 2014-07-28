//
//  ProfileVideoPreviewViewController.h
//  SEVEN
//
//  Created by Bobby Ren on 7/28/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AVPlayer;
@class AVPlayerLayer;
@interface ProfileVideoPreviewViewController : UIViewController
{
    AVPlayer *player;
    AVPlayerLayer *layer;
    int currentVideo;
}

@property (nonatomic, strong) NSArray *mediaURLs;
@end
