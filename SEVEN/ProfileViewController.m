//
//  ProfileViewController.m
//  SEVEN
//
//  Created by Bobby Ren on 8/7/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import "ProfileViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>

@implementation ProfileViewController
-(void)viewDidLoad {
    if (!self.facebookFriend) {
        self.facebookFriend = [[PFUser currentUser] objectForKey:@"facebookFriend"];
    }
    [self.facebookFriend fetchIfNeeded];

    self.name = self.facebookFriend[@"name"];
    if (self.facebookFriend[@"firstName"])
        self.name = self.facebookFriend[@"firstName"];

    PFRelation *traitsRelation = [[PFUser currentUser] relationForKey:@"traits"];
    [[traitsRelation query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.traits = objects;
    }];

    [self setupFonts];

    [labelName setText:self.name];

    self.profileVideo = [[PFUser currentUser] objectForKey:@"profileVideo"];
    [self.profileVideo fetchIfNeeded];
    [self playCurrentMedia];
}

-(void)setupFonts {
    [labelName setFont:FontMedium(16)];
}

-(void)playCurrentMedia {
    PFFile *file = self.profileVideo[@"video"];
#if 1
    // load videos locally. not ideal, but it seems to be fine without having to stream it
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString  *documentsDirectory = [paths objectAtIndex:0];

        NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"profile.mp4"];

        [data writeToFile:filePath atomically:YES];
        NSURL *profileVideoURL = [NSURL fileURLWithPath:filePath];

        [self playMedia:profileVideoURL];
    }];
#else
    NSURL *profileVideoURL = [NSURL URLWithString:[file url]];
    [self playMedia:profileVideoURL];
#endif
}

-(void)playMedia:(NSURL *)profileVideoURL {
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:profileVideoURL];
    player = [[AVPlayer alloc] initWithPlayerItem:item];
    [player addObserver:self forKeyPath:@"status" options:0 context:nil];
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:player];
    layer.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [viewVideo.layer addSublayer:layer];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:item];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        NSLog(@"Status: %@", change);
        [self readyToPlay];
    }
}

-(void)readyToPlay {
    [player play];
}

-(void)playerDidReachEnd:(NSNotification *)n {
    [player seekToTime:kCMTimeZero];
    [player play];
}

@end
