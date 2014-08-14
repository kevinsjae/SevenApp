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
#import "TraitAdjustorCell.h"

#define CELL_HEIGHT 51

@implementation ProfileViewController
-(void)viewDidLoad {
    if (!self.user) {
        self.user = [PFUser currentUser];
    }

    [self.user fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        [self loadUserInfo];
    }];

    [self setupFonts];
    allColors = [NSMutableArray array];

    if (self.hideTable) {
        [tableview setHidden:YES];
        [viewName setHidden:YES];
    }
}

-(void)loadUserInfo {
    // load things that require the user to be fully loaded
    NSLog(@"Loading userInfo for %@", self.user[@"name"]);

    self.facebookFriend = [self.user objectForKey:@"facebookFriend"];
    [self.facebookFriend fetchIfNeeded];

    self.name = self.facebookFriend[@"name"];
    if (self.facebookFriend[@"firstName"])
        self.name = self.facebookFriend[@"firstName"];
    if (self.name) {
        [labelName setText:self.name];
        constraintNameHeight.constant = 60;
        [viewName setNeedsLayout];
        [viewName layoutIfNeeded];
    }

    if (!self.hideTable) {
        PFRelation *traitsRelation = [self.user relationForKey:@"traits"];
        [[traitsRelation query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            self.traits = objects;
            [self randomizeColors];
            [self reloadData];
        }];
    }

    self.profileVideo = [self.user objectForKey:@"profileVideo"];
    [self.profileVideo fetchIfNeeded];
    [self playCurrentMedia];
    self.view.backgroundColor = [self randomColorFromLastColor:nil lastTwo:nil];
}

-(void)setupFonts {
    [labelName setFont:FontMedium(16)];
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

    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:player];
    layer.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [viewVideo.layer addSublayer:layer];

    [self listenFor:AVPlayerItemDidPlayToEndTimeNotification action:@selector(playerDidReachEnd:) object:item];
    [self readyToPlay];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        NSLog(@"Status: %@", change);
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
    if (item != player.currentItem) {
        NSLog(@"Here");
    }
    [self listenFor:AVPlayerItemDidPlayToEndTimeNotification action:@selector(playerDidReachEnd:) object:item];
}

#pragma mark TableViewDataSource
-(void)reloadData {
    int offset = tableview.frame.size.height - 3 * CELL_HEIGHT;
    tableview.contentInset = UIEdgeInsetsMake(offset, 0, 0, 0);
    [tableview reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.traits count];
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

@end
