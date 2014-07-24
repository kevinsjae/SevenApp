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

    [self.scrollview setPagingEnabled:YES];
    [self.scrollview setBounces:NO];
    [self addPlayers];
}

-(void)addPlayers {
    players = [NSMutableArray array];

    NSArray *movieList = @[@"SEVEN_IntroVideo_V01", @"SEVEN_IntroVideo_V02", @"SEVEN_IntroVideo_V03"];

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

-(AVPlayer *)currentPlayer {
    return players[(int)(self.scrollview.contentOffset.x / self.scrollview.frame.size.width)];
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
