//
//  CreateProfileViewController.m
//  SEVEN
//
//  Created by Bobby Ren on 7/27/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import "CreateProfileViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "SevenCamera.h"
#import "EffectsUtils.h"
#import "VideoProgressIndicator.h"
#import "ProfileVideoPreviewViewController.h"

@interface CreateProfileViewController ()

@end

@implementation CreateProfileViewController

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

    [self showTutorialView];

    mediaURLs = [NSMutableArray array]; // reference to two recorded clips (URLs)
    mediaLengths = [NSMutableArray array]; // reference to two recorded clips (lengths)
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

-(void)showTutorialView {
    [viewVideoBG.layer setCornerRadius:viewVideoBG.frame.size.width/2];
    viewVideoBG.contentMode = UIViewContentModeScaleAspectFill;

    NSURL *url = [[NSBundle mainBundle] URLForResource:@"SEVEN_ProfileSample_002" withExtension:@"mp4"];
    player = [[AVPlayer alloc] initWithURL:url];
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:player];
    layer.frame = CGRectMake(0, 0, viewVideoBG.frame.size.width, viewVideoBG.frame.size.height);
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [viewVideoBG.layer addSublayer:layer];
    [player play];

    progressIndicator = [[VideoProgressIndicator alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
    [progressBG setBackgroundColor:[UIColor clearColor]];
    [progressBG addSubview:progressIndicator];
    [progressIndicator updateProgress:0];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:nil];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [tutorialView addGestureRecognizer:tap];

#if TESTING
    [EffectsUtils gradientFadeInForView:labelMessage duration:.1];
    [EffectsUtils gradientFadeInForView:labelClose duration:.1];
    [EffectsUtils gradientFadeInForView:progressIndicator duration:.1];
#else
    [EffectsUtils gradientFadeInForView:labelMessage duration:3];
    [EffectsUtils gradientFadeInForView:labelClose duration:3];
    [EffectsUtils gradientFadeInForView:progressIndicator duration:3];
#endif
}

-(void)playerDidReachEnd:(NSNotification *)n {
    [player seekToTime:kCMTimeZero];
    [player play];
}

-(void)handleGesture:(UIGestureRecognizer *)gesture {
    if ([gesture isKindOfClass:[UITapGestureRecognizer class]] && gesture.state == UIGestureRecognizerStateEnded) {

#if TESTING
        float duration = 0.1;
#else
        float duration = 1.5;
#endif
        [UIView animateWithDuration:duration animations:^{
            tutorialView.alpha = 0;
        } completion:^(BOOL finished) {
            [tutorialView removeFromSuperview];
            [self setupCamera];
        }];
    }
    else if ([gesture isKindOfClass:[UILongPressGestureRecognizer class]]) {
        if (gesture.state == UIGestureRecognizerStateBegan) {
            if ([mediaURLs count] < 2)
                [camera startRecordingVideo];
        }
        else if (gesture.state == UIGestureRecognizerStateEnded) {
            [camera stopRecordingVideo];
        }
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (camera && !cameraReady) {
        return NO;
    }
    return YES;
}

#pragma mark Camera
-(void)setupCamera {
    camera = [[SevenCamera alloc] init];
    [camera setDelegate:self];

    [camera startCameraFrom:self];
    [camera addOverlayWithFrame:_appDelegate.window.bounds];

    [camera addProgressIndicator:progressBG];

    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    press.minimumPressDuration = 0.1;
    [camera.overlayView addGestureRecognizer:press];

    cameraReady = YES;
}

#pragma mark Camera Delegate
-(void)dismissCamera {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)didStartRecordingVideo {
    videoStartTimestamp = [NSDate date];
    progressTimer = [NSTimer scheduledTimerWithTimeInterval:.005 target:self selector:@selector(tick) userInfo:nil repeats:YES];
    [mediaLengths addObject:@0];
    NSLog(@"Media lengths: %@", mediaLengths);
    cameraReady = NO;
}

-(void)didStopRecordingVideo {
    NSLog(@"Timer stopped");
    if (progressTimer) {
        [progressTimer invalidate];
        progressTimer = nil;
    }
}

-(void)didRecordMediaWithURL:(NSURL *)url {
    NSLog(@"URL: %@", url.path);
    [mediaURLs addObject:url];
    cameraReady = YES;

    if ([mediaURLs count] == 2) {
        [self goToPreview];
    }
}

-(void)tick {
    float secondsPassed = [[NSDate date] timeIntervalSinceDate:videoStartTimestamp];
    //[progressIndicator updateProgress:secondsPassed];

    NSInteger mediaIndex = [mediaURLs count];
    mediaLengths[mediaIndex] = @(MIN(3.0, secondsPassed));
    [progressIndicator updateAllProgress:mediaLengths];
    NSLog(@"Total video length: %@", mediaLengths[mediaIndex]);

    if (secondsPassed > 3.0) {
        if (progressTimer) {
            [progressTimer invalidate];
            progressTimer = nil;
        }
        [camera stopRecordingVideo];
    }
}

#pragma mark preview
-(void)goToPreview {
    // preview here, no more recording
    [self dismissViewControllerAnimated:NO completion:^{
        [self performSegueWithIdentifier:@"CameraToPreview" sender:self];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UINavigationController *nav = (UINavigationController *)[segue destinationViewController];
    ProfileVideoPreviewViewController *previewController = nav.viewControllers[0];
    [previewController setMediaURLs:mediaURLs];
    // Pass the selected object to the new view controller.
}
@end
