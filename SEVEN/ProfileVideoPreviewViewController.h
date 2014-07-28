//
//  ProfileVideoPreviewViewController.h
//  SEVEN
//
//  Created by Bobby Ren on 7/28/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class AVPlayer;
@class AVPlayerLayer;
@interface ProfileVideoPreviewViewController : UIViewController
{
    AVPlayer *player;
    NSURL *profileVideoURL;
}

@property (nonatomic, strong) NSArray *mediaURLs;

// merging videos
@property(nonatomic, strong) AVAsset *firstAsset;
@property(nonatomic, strong) AVAsset *secondAsset;

@end
