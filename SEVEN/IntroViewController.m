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

    movieList = @[@"SEVEN_IntroVideo_V01", @"SEVEN_IntroVideo_V02", @"SEVEN_IntroVideo_V03", @"SEVEN_IntroVideo_V01"];

    [self.scrollview setPagingEnabled:YES];
    [self.scrollview setBounces:NO];
    [self addPlayers];

    [self.pageControl setNumberOfPages:[movieList count]];
    [self.pageControl setCurrentPage:0];

    [self animateBarsWithDuration:3];
    [self animateFade:self.viewTitle duration:4];
    [self animateFade:self.labelSubtitle duration:4];
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

-(void)animateFade:(UIView *)view duration:(float)duration{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    int w = view.frame.size.width;
    gradient.frame = CGRectMake(-w*2, 0, w*3, view.frame.size.height);
    gradient.colors = [NSArray arrayWithObjects:(id)[UIColor whiteColor].CGColor, [UIColor whiteColor].CGColor,(id)[UIColor clearColor].CGColor, (id)[UIColor clearColor].CGColor, nil];
    gradient.startPoint = CGPointMake(0, 0.5);
    gradient.endPoint = CGPointMake(1, 0.5);
    gradient.locations = @[@0, @0.33, @0.66, @1];
    [view.layer setMask:gradient];

    [CATransaction begin];
    CABasicAnimation *frameAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    frameAnimation.duration = duration;
    CATransform3D transform = CATransform3DMakeTranslation(w*2, 0, 0);
    frameAnimation.toValue = [NSValue valueWithCATransform3D:transform];
    [CATransaction setCompletionBlock:^{
        view.layer.mask = nil;
    }];
    [view.layer.mask addAnimation:frameAnimation forKey:@"translate"];
    [CATransaction commit];
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
