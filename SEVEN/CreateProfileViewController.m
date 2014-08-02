//
//  CreateProfileViewController.m
//  SEVEN
//
//  Created by Bobby Ren on 7/27/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import "CreateProfileViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "EffectsUtils.h"
#import "VideoProgressIndicator.h"
#import "ProfileVideoPreviewViewController.h"
#import "BRCameraViewController.h"

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
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    [self showTutorialView];

    mediaURLs = [NSMutableArray array]; // reference to two recorded clips (URLs)
    mediaLengths = [NSMutableArray array]; // reference to two recorded clips (lengths)

    [self setupFonts];
}

-(void)setupFonts {
    NSString *message = @"SEVEN is about real people who are looking for the perfect date.\n\nShow off your smile by creating a visual profile.";
    NSArray *highlights = @[@"real people", @"visual profile"];
    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:message];
    [titleString addAttribute:NSFontAttributeName value:FontRegular(15) range:[message rangeOfString:message]];

    for (NSString *highlightedString in highlights) {
        [titleString addAttribute:NSForegroundColorAttributeName value:COL_LIGHTBLUE range:[message rangeOfString:highlightedString]];
        [titleString addAttribute:NSFontAttributeName value:FontMedium(16) range:[message rangeOfString:highlightedString]];
    }
    [labelMessage setAttributedText:titleString];

    [labelClose setFont:FontRegular(15)];
    [labelClose setTextColor:COL_LIGHTBLUE];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (shouldShowCameraOnAppear) {
        [self resetCamera];
    }
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

#pragma mark Tutorial overlay
-(void)showTutorialView {
    [viewVideoBG.layer setCornerRadius:viewVideoBG.frame.size.width/2];
    viewVideoBG.contentMode = UIViewContentModeScaleAspectFill;

    NSURL *url = [[NSBundle mainBundle] URLForResource:@"SEVEN_ProfileSample_002" withExtension:@"mp4"];

    AVURLAsset *asset = [AVURLAsset assetWithURL:url];
    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset: asset];
    player = [[AVPlayer alloc] initWithPlayerItem:item];

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
                                               object:item];

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

#pragma mark Gesture
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
            [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
            [tutorialView removeFromSuperview];
            [self setupCamera];
        }];
    }
    else if ([gesture isKindOfClass:[UILongPressGestureRecognizer class]]) {
        if (gesture.state == UIGestureRecognizerStateBegan) {
            if ([mediaURLs count] < 2) {
                NSLog(@"Gesture press started recording");
                [cameraController startRecording];
            }
        }
        else if (gesture.state == UIGestureRecognizerStateEnded) {
            NSLog(@"Gesture press up stopped recording");
            [cameraController stopRecording];

            // if camera already stopped, camera will just ignore this command
        }
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (cameraController && !cameraReady) {
        NSLog(@"Camera not ready");
        return NO;
    }
    NSLog(@"Camera ready: %d", cameraReady);
    return YES;
}

#pragma mark Camera
-(void)setupCamera {
    cameraController = [[BRCameraViewController alloc] init];
    [cameraController setDelegate:self];
//    [self.view addSubview:cameraController.view];
    [self.navigationController presentViewController:cameraController animated:NO completion:nil];

    CGRect frame = self.view.frame;
    [cameraController addOverlayToFrame:frame]; // avoid the nav bar
    [cameraController.overlay addSubview:progressBG];

    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    press.minimumPressDuration = 0.1;
    press.delegate = self;
    [cameraController.overlay addGestureRecognizer:press];

    cameraReady = YES;
    shouldShowCameraOnAppear = NO;
}

-(void)resetCamera {
    [mediaLengths removeAllObjects];
    [mediaURLs removeAllObjects];
    [progressIndicator updateProgress:0];
    [self setupCamera];
}

#pragma mark Camera Delegate
-(void)didStartRecordingVideo {
    currentLength = 0;
    cameraReady = NO;
}

-(void)didStopRecordingVideo {
    cameraReady = YES;
    NSArray *allLengths = [mediaLengths arrayByAddingObject:@(MIN(3.0, currentLength))];
    [progressIndicator updateAllProgress:allLengths];
}

-(void)didRecordMediaWithURL:(NSURL *)url {
    NSLog(@"URL: %@", url.path);
    if (currentLength > 0) {
        [mediaLengths addObject:@(MIN(3.0, currentLength))];
        [mediaURLs addObject:url];
        NSLog(@"Saved videos: %lu", [mediaURLs count]);

        [progressIndicator updateAllProgress:mediaLengths];
    }

    cameraReady = YES;

    if ([mediaURLs count] == 2) {
        [self goToPreview];
    }
}

-(void)tick:(float)secondsPassed {
    //[progressIndicator updateProgress:secondsPassed];

    currentLength = secondsPassed;
    NSArray *allLengths = [mediaLengths arrayByAddingObject:@(MIN(3.0, currentLength))];
    [progressIndicator updateAllProgress:allLengths];
    NSLog(@"Current video length: %f", currentLength);

    if (secondsPassed >= 3.0) {
        [cameraController stopRecording];
    }
}

#pragma mark preview
-(void)goToPreview {
    // preview here, no more recording
    [self dismissViewControllerAnimated:NO completion:^{
        [self performSegueWithIdentifier:@"CameraToPreview" sender:self];
        cameraController = nil;
        shouldShowCameraOnAppear = YES;
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ProfileVideoPreviewViewController *previewController = (ProfileVideoPreviewViewController *)[segue destinationViewController];
    [previewController setupMedia:mediaURLs];
    // Pass the selected object to the new view controller.
}

@end
