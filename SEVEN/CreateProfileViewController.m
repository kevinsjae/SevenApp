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

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:nil];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [tutorialView addGestureRecognizer:tap];

    [EffectsUtils gradientFadeInForView:labelMessage duration:3];
    [EffectsUtils gradientFadeInForView:labelClose duration:3];
}

-(void)playerDidReachEnd:(NSNotification *)n {
    [player seekToTime:kCMTimeZero];
    [player play];
}

-(void)handleGesture:(UIGestureRecognizer *)gesture {
    if ([gesture isKindOfClass:[UITapGestureRecognizer class]] && gesture.state == UIGestureRecognizerStateEnded) {

        [UIView animateWithDuration:1.5 animations:^{
            tutorialView.alpha = 0;
        } completion:^(BOOL finished) {
            [tutorialView removeFromSuperview];
            [self setupCamera];
        }];
    }
}

#pragma mark Camera
-(void)setupCamera {
    camera = [[SevenCamera alloc] init];
    [camera setDelegate:self];

    [camera startCameraFrom:self];
    [camera addOverlayWithFrame:_appDelegate.window.bounds];
}

#pragma mark Camera Delegate
-(void)dismissCamera {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)didSelectPhoto:(UIImage *)photo meta:(NSDictionary *)meta {
    //alertView = [UIAlertView alertViewWithTitle:@"Generating postcard..." message:nil cancelButtonTitle:nil otherButtonTitles:nil onDismiss:nil onCancel:nil];

//    selectedImage = photo;
//    [self imageSaved];
}

@end
