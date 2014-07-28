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

    movieList = @[@"SEVEN_IntroVideo_V01", @"SEVEN_IntroVideo_V02", @"SEVEN_IntroVideo_V03"];

    [self.scrollview setPagingEnabled:YES];
    [self.scrollview setBounces:NO];
    [self addPlayers];

    [self.pageControl setNumberOfPages:[movieList count]];
    [self.pageControl setCurrentPage:0];

    [self animateBars];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark animations
-(void)animateBars {
    NSLog(@"Started");

    self.constraintWidthRed.constant = 70;
    [self.barRed setNeedsUpdateConstraints];
    [UIView animateWithDuration:1.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.barRed layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.constraintWidthBlue.constant = 45;
        [self.barBlue setNeedsUpdateConstraints];
        [UIView animateWithDuration:1.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self.barBlue layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.constraintWidthGreen.constant = 60;
            [self.barGreen setNeedsUpdateConstraints];
            [UIView animateWithDuration:1.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.barGreen layoutIfNeeded];
            } completion:^(BOOL finished) {
                NSLog(@"Done");
            }];
        }];
    }];
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
