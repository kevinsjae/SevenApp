//
//  ProfileViewController.m
//  SEVEN
//
//  Created by Bobby Ren on 8/7/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import "ProfileViewController.h"
#import <CoreMedia/CoreMedia.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "TraitAdjustorCell.h"
#import "ProfileDescriptionView.h"

@implementation ProfileViewController
-(void)viewDidLoad {
    if (!self.user) {
        self.user = [PFUser currentUser];
    }
    allColors = [NSMutableArray array];

#if AIRPLANE_MODE
    [self loadUserInfo];
    self.view.backgroundColor = [self randomColorFromLastColor:nil lastTwo:nil];
#else
    [self.user fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        [self loadUserInfo];
    }];
#endif
    
    initialOffset = constraintNameOffset.constant;

    // todo: viewInfo and tableview must be resized based on screen
    [self.view addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    [self.view setClipsToBounds:YES];
}

-(void)showsContent:(BOOL)shows{
    [tableview setHidden:!shows];
    [viewInfo setHidden:!shows];
}

-(void)createFakeTraits {
#if TESTING & AIRPLANE_MODE
    PFObject *trait0 = [PFObject objectWithClassName:@"Trait"];
    trait0[@"trait"] = @"Witty0";
    trait0[@"level"] = @0;
    PFObject *trait1 = [PFObject objectWithClassName:@"Trait"];
    trait1[@"trait"] = @"Witty1";
    trait1[@"level"] = @25;
    PFObject *trait2 = [PFObject objectWithClassName:@"Trait"];
    trait2[@"trait"] = @"Witty2";
    trait2[@"level"] = @50;
    PFObject *trait3 = [PFObject objectWithClassName:@"Trait"];
    trait3[@"trait"] = @"Witty3";
    trait3[@"level"] = @75;
    PFObject *trait4 = [PFObject objectWithClassName:@"Trait"];
    trait4[@"trait"] = @"Witty4";
    trait4[@"level"] = @99;
    PFObject *trait5 = [PFObject objectWithClassName:@"Trait"];
    trait5[@"trait"] = @"Witty4";
    trait5[@"level"] = @99;
    PFObject *trait6 = [PFObject objectWithClassName:@"Trait"];
    trait6[@"trait"] = @"Witty4";
    trait6[@"level"] = @99;
    PFObject *trait7 = [PFObject objectWithClassName:@"Trait"];
    trait7[@"trait"] = @"Witty4";
    trait7[@"level"] = @99;
    PFObject *trait8 = [PFObject objectWithClassName:@"Trait"];
    trait8[@"trait"] = @"Witty4";
    trait8[@"level"] = @99;
    PFObject *trait9 = [PFObject objectWithClassName:@"Trait"];
    trait9[@"trait"] = @"Witty4";
    trait9[@"level"] = @99;
    PFObject *trait10 = [PFObject objectWithClassName:@"Trait"];
    trait10[@"trait"] = @"Witty4";
    trait10[@"level"] = @99;


    self.traits = @[trait0, trait1, trait2, trait3, trait4, trait5, trait6, trait7, trait8, trait9, trait10];
    [self randomizeColors];
#endif
}

-(void)loadUserInfo {
    CGRect bounds = self.view.bounds;
    // load things that require the user to be fully loaded
    NSLog(@"Loading userInfo for %@", self.user[@"name"]);

    self.facebookFriend = [self.user objectForKey:@"facebookFriend"];
#if !AIRPLANE_MODE
    [self.facebookFriend fetchIfNeeded];
#endif
    
    [viewInfo setupWithUser:self.user];
    [viewInfo setDelegate:self];

#if TESTING & AIRPLANE_MODE
    [self createFakeTraits];
    [self reloadData];
#else
    PFRelation *traitsRelation = [self.user relationForKey:@"traits"];
    [[traitsRelation query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.traits = objects;
        [self randomizeColors];
        [self reloadData];
    }];
#endif

    self.profileVideo = [self.user objectForKey:@"profileVideo"];
#if !AIRPLANE_MODE
    [self.profileVideo fetchIfNeeded];
#endif
    [self playCurrentMedia];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    CGRect bounds = self.view.bounds;

    if (bounds.size.height <= 480) {
        // what a hack
        viewVideo.transform = CGAffineTransformTranslate(CGAffineTransformMakeScale(1.2, 1.2), -50, 0);
    }
}

#pragma mark Video
-(void)playCurrentMedia {
    NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
    NSString  *filePath = [NSString stringWithFormat:@"%@/%@.mp4", documentsDirectory,self.user.objectId];

    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if ([fileManager fileExistsAtPath:filePath]) {
        NSURL *profileVideoURL = [NSURL fileURLWithPath:filePath];
        [self playMedia:profileVideoURL];
    }
    else {
        PFFile *file = self.profileVideo[@"video"];
        if (!file) {
            NSLog(@"No video loaded");
        }
        // load videos locally. not ideal, but it seems to be fine without having to stream it
        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            [data writeToFile:filePath atomically:YES];
            NSURL *profileVideoURL = [NSURL fileURLWithPath:filePath];
            [self playMedia:profileVideoURL];
        }];
    }
}

-(void)playMedia:(NSURL *)profileVideoURL {
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:profileVideoURL];
    player = [[AVPlayer alloc] initWithPlayerItem:item];
    [player addObserver:self forKeyPath:@"status" options:0 context:nil];

    if (self.playerLayer) {
        [self.playerLayer removeFromSuperlayer];
    }
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    self.playerLayer.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [viewVideo.layer addSublayer:self.playerLayer];

    [self listenFor:AVPlayerItemDidPlayToEndTimeNotification action:@selector(playerDidReachEnd:) object:item];
    [self readyToPlay];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        NSLog(@"Status: %@", change);
    }
    else {
        NSLog(@"%@ %@", keyPath, change);
        [self reloadData];
    }
}

-(void)notPlaying {
    // backup for if notification isn't heard, force replay
    playing = NO;
    NSLog(@"%@ Not playing", self.user[@"name"]);
    [self readyToPlay];
}

-(void)readyToPlay {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(notPlaying) object:nil];
    [player play];
    playing = YES;
    float duration = CMTimeGetSeconds(player.currentItem.duration);
    [self performSelector:@selector(notPlaying) withObject:nil afterDelay:duration+.5];
}

-(void)playerDidReachEnd:(NSNotification *)n {
    [self stopListeningFor:AVPlayerItemDidPlayToEndTimeNotification];
    NSLog(@"Player for user %@ reset", self.user[@"name"]);
    [player seekToTime:kCMTimeZero];
    AVPlayerItem *item = n.object;
    [self readyToPlay];
    [self listenFor:AVPlayerItemDidPlayToEndTimeNotification action:@selector(playerDidReachEnd:) object:item];
}

-(CMTime)currentVideoOffset {
    AVPlayerItem *item = player.currentItem;
    CMTime time = item.currentTime;
    CMTime time2 = player.currentTime;
    return player.currentItem.currentTime;
}

-(void)jumpToVideoTime:(CMTime)newTime {
    [player seekToTime:newTime];
}

-(AVPlayer *)player {
    return player;
}

#pragma mark TableViewDataSource
-(void)reloadData {
    int toShow = MIN(self.traits.count, 2);
    int offset = tableview.frame.size.height - toShow * TRAIT_HEIGHT;
    tableview.contentInset = UIEdgeInsetsMake(offset, 0, 0, 0);
    [tableview reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.traits count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return TRAIT_HEIGHT;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TraitAdjustorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TraitAdjustorCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;

    NSInteger row = indexPath.row;
    PFObject *trait = self.traits[row];
    NSString *name = trait[@"trait"];
    NSNumber *level = trait[@"level"];
    if (!level)
        level = @0;
    [cell setupWithInfo:@{@"trait":name, @"color":allColors[row], @"level":level}];

    cell.canAdjust = NO;

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark Colors
-(void)randomizeColors {
    [allColors addObject:[self randomColorFromLastColor:nil lastTwo:nil]];
    [allColors addObject:[self randomColorFromLastColor:allColors[0] lastTwo:nil]];
    for (int i=2; i<[self.traits count]; i++) {
        UIColor *lastColor = allColors[i-1];
        UIColor *lastTwo = allColors[i-2];
        [allColors addObject:[self randomColorFromLastColor:lastColor lastTwo:lastTwo]];
    }
}

-(UIColor *)randomColorFromLastColor:(UIColor *)lastColor lastTwo:(UIColor *)lastTwo {
    static const int numColors = 10;
    int ALL_COLORS[numColors] = {0xbdd200, 0xff0e0e, 0x670063, 0x9e005d, 0x2ed0ff, 0xff6015, 0x00809c, 0x07a5cb, 0xdf0000, 0x009c8e};

    const CGFloat* lastColorComponents = CGColorGetComponents( lastColor.CGColor);

    while (1) {
        int index = arc4random() % numColors;
        UIColor *newColor = UIColorFromHex(ALL_COLORS[index]);
        const CGFloat* newColorComponents = CGColorGetComponents(   newColor.CGColor);
        if (!lastColor) {
            return newColor;
        }
        float dist = fabs(newColorComponents[0] - lastColorComponents[0]) + fabs(newColorComponents[1] != lastColorComponents[1]) + fabs(newColorComponents[2] != lastColorComponents[2]);
        NSLog(@"distance between %@ and %@: %f", lastColor, newColor, dist);
        if (dist <= 1)
            continue;
        if (!lastTwo)
            return newColor;

        const CGFloat* lastColorComponents2 = CGColorGetComponents( lastTwo.CGColor);
        float dist2 = fabs(newColorComponents[0] - lastColorComponents2[0]) + fabs(newColorComponents[1] != lastColorComponents2[1]) + fabs(newColorComponents[2] != lastColorComponents2[2]);
        if (dist2 <= 2.2)
            continue;

        return newColor;
    }
}

#pragma mark ProfileDescriptionDelegate
-(void)didClickExpand {
    // constraintNameOffset is based on vertical distance from the bottom of the screen. That means when
    // it is down, it is at -40, and when it is up, it should be at -(screensize) < -40
    // initialOffset should always be -40
    if (constraintNameOffset.constant < initialOffset) {
        [self expandDown];
    }
    else {
        [self expandUp];
    }
}

-(void)expandDown {
    if (constraintNameOffset.constant < initialOffset) {
        [constraintNameOffset setConstant:initialOffset];
    }
    [self.view setNeedsUpdateConstraints];
    [UIView animateWithDuration:.2 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [viewInfo pointerUp];
    }];
}

-(void)expandUp {
    if (!(constraintNameOffset.constant < initialOffset)) {
        [constraintNameOffset setConstant:-(tableview.frame.size.height+1)];
    }
    [self.view setNeedsUpdateConstraints];
    [UIView animateWithDuration:.2 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [viewInfo pointerDown];;
    }];
}

@end
