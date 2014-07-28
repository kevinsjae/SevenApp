//
//  ProfileVideoPreviewViewController.m
//  SEVEN
//
//  Created by Bobby Ren on 7/28/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import "ProfileVideoPreviewViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ProfileVideoPreviewViewController ()

@end

@implementation ProfileVideoPreviewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:nil];
    // setup media player
    [self playCurrentMedia];
}

-(void)playCurrentMedia {
    if (layer) {
        [layer removeFromSuperlayer];
        player = nil;
    }

    NSURL *url = self.mediaURLs[currentVideo];
    player = [[AVPlayer alloc] initWithURL:url];
    layer = [AVPlayerLayer playerLayerWithPlayer:player];
    layer.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view.layer addSublayer:layer];
    [player play];
}

-(void)playerDidReachEnd:(NSNotification *)n {
    int newVideo = (currentVideo+1) % [self.mediaURLs count];
    if (newVideo == currentVideo) {
        [player seekToTime:kCMTimeZero];
        [player play];
    }
    else {
        currentVideo = newVideo;
        [self playCurrentMedia];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
