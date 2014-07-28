//
//  IntroViewController.m
//  SEVEN
//
//  Created by Bobby Ren on 7/24/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//
// http://stackoverflow.com/questions/4368112/multiple-mpmovieplayercontroller-instances

#import "IntroViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "FacebookHelper.h"
#import "EffectsUtils.h"

static NSArray *movieList;

@interface IntroViewController ()

@end

@implementation IntroViewController

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

    movieList = @[@"SEVEN_IntroVideo_V01", @"SEVEN_IntroVideo_V02", @"SEVEN_IntroVideo_V03", @"SEVEN_IntroVideo_V01"];

    [self.scrollview setPagingEnabled:YES];
    [self.scrollview setBounces:NO];
    [self addPlayers];

    [self.pageControl setNumberOfPages:[movieList count]];
    [self.pageControl setCurrentPage:0];

    [self animateBarsWithDuration:3];
    [self animateFade:self.viewTitle duration:4];
    [self animateFade:self.labelSubtitle duration:4];
    [self animateButtonWithDuration:2];
}

-(void)addPlayers {
    players = [NSMutableArray array];

    for (NSString *movieTitle in movieList) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:movieTitle withExtension:@"mp4"];
        AVPlayer *player = [[AVPlayer alloc] initWithURL:url];
        AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:player];
        layer.frame = CGRectMake(self.scrollview.frame.size.width * players.count, 0, self.scrollview.frame.size.width, self.scrollview.frame.size.height);
        [self.scrollview.layer addSublayer:layer];
        [players addObject:player];
    }

    [self.scrollview setContentSize:CGSizeMake(self.scrollview.frame.size.width * [movieList count], self.scrollview.frame.size.height)];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:nil];
}

-(int)currentPage {
    return (int)(self.scrollview.contentOffset.x / self.scrollview.frame.size.width);
}
-(AVPlayer *)currentPlayer {
    return players[self.currentPage];
}

-(void)playerDidReachEnd:(NSNotification *)n {
    [self.currentPlayer seekToTime:kCMTimeZero];
    [self.currentPlayer play];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.currentPlayer play];
}

#pragma mark scrollviewdelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.currentPlayer play];
    [self.pageControl setCurrentPage:self.currentPage];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.currentPlayer pause];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int content_x = scrollView.contentOffset.x;
    float alpha = 1;
    if (content_x > self.view.frame.size.width)
        alpha = 0;
    else {
        alpha = (self.view.frame.size.width - content_x) / self.view.frame.size.width;
    }
    self.viewTitle.alpha = alpha;
    self.labelSubtitle.alpha = alpha;
    self.viewLogo.alpha = alpha;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark animations
-(void)animateBarsWithDuration:(float)duration {
    NSLog(@"Started");

    self.constraintWidthRed.constant = 70;
    [self.viewLogo setNeedsUpdateConstraints];
    [UIView animateWithDuration:duration/3.0 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.viewLogo layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.constraintWidthBlue.constant = 45;
        [self.viewLogo setNeedsUpdateConstraints];
        [UIView animateWithDuration:duration/3.0 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self.viewLogo layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.constraintWidthGreen.constant = 60;
            [self.viewLogo setNeedsUpdateConstraints];
            [UIView animateWithDuration:duration/3.0 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.viewLogo layoutIfNeeded];
            } completion:^(BOOL finished) {
                NSLog(@"Done");
            }];
        }];
    }];
}

-(void)animateFade:(UIView *)view duration:(float)duration {
    [EffectsUtils gradientFadeInForView:view duration:duration];
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

-(void)animateButtonWithDuration:(float)duration {
#if 1
    // animate motion
    self.constraintVerticalButton.constant = -70;
    self.constraintVerticalButton2.constant = -70;
    [self.buttonFacebook setNeedsUpdateConstraints];
    [self.buttonFacebook layoutIfNeeded];
    [self.buttonFacebook2 setNeedsUpdateConstraints];
    [self.buttonFacebook2 layoutIfNeeded];

    self.constraintVerticalButton.constant = 6;
    self.constraintVerticalButton2.constant = 6;
    [self.buttonFacebook setNeedsUpdateConstraints];
    [self.buttonFacebook2 setNeedsUpdateConstraints];
    [UIView animateWithDuration:duration animations:^{
        [self.buttonFacebook layoutIfNeeded];
        [self.buttonFacebook2 layoutIfNeeded];
    }];
//#else
    self.buttonFacebook.alpha = 0;
    self.buttonFacebook2.alpha = 0;
    [UIView animateWithDuration:duration animations:^{
        self.buttonFacebook.alpha = 1;
        self.buttonFacebook2.alpha = 1;
    }];
#endif
}

#pragma mark Facebook
- (IBAction)didClickButton:(id)sender {
    [self.buttonFacebook setEnabled:NO];
    [PFFacebookUtils logInWithPermissions:@[@"public_profile", @"email", @"user_friends"] block:^(PFUser *user, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            [self.buttonFacebook setEnabled:YES];
        }
        else {
            NSLog(@"User: %@", user);
            NSLog(@"Current user: %@", [PFUser currentUser]);

            [self performSegueWithIdentifier:@"IntroToCreateProfile" sender:self];
        }
    }];
}
@end
