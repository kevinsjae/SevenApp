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
#import "VideoPlayerViewController.h"

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

    [self.view setClipsToBounds:YES];

    labelTag = [[UILabel alloc] init];
    [labelTag setHidden:YES];
    [labelTag setTag:TAG_USER_ID];
    [labelTag setText:self.user.objectId];
    [self.view addSubview:labelTag];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"LoadVideoURLSegue"]) {
        VideoPlayerViewController *playerController = segue.destinationViewController;
        playerController.delegate = self;
        playerController.view.backgroundColor = [UIColor clearColor];
        self.playerController = playerController;
    }
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

//    self.facebookFriend = [self.user objectForKey:@"facebookFriend"];
#if !AIRPLANE_MODE
//    [self.facebookFriend fetchIfNeeded];
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
    PFFile *imageFile = self.profileVideo[@"thumb"];
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            viewVideoFrame.image = image;
        }
    }];
    [self playCurrentMedia];
}

-(void)didShowPage {
    if (self.playerController.playing == NO) {
        NSLog(@"Page for %@ appeared while stopped, restarting video", self.user[@"name"]);
        [self.playerController restart];
    }
}

#pragma mark VideoPlayerDelegate
-(void)didRestart {
    NSLog(@"Player for user %@ reset", self.user[@"name"]);
}
-(void)didStopPlaying {
    NSLog(@"Player for user %@ stopped", self.user[@"name"]);
    if ([self.delegate isProfileVisible:self]) {
        [self didShowPage];
    }
}

#pragma mark Video
-(void)playCurrentMedia {
    PFFile *file = self.profileVideo[@"video"];
    if (!file) {
        NSLog(@"No video loaded");
        [self.profileVideo fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            PFFile *file = self.profileVideo[@"video"];
            NSURL *url = [NSURL URLWithString:[file url]];
            [self playMedia:url];
        }];
    }
    else {
        NSURL *url = [NSURL URLWithString:[file url]];
        [self playMedia:url];
    }
}

-(void)playMedia:(NSURL *)profileVideoURL {
    if (self.playerController) {
        [self.playerController setURL:profileVideoURL];
    }
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
        //NSLog(@"distance between %@ and %@: %f", lastColor, newColor, dist);
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
        //[constraintNameOffset setConstant:-(tableview.frame.size.height+1)];
        [constraintNameOffset setConstant:-(self.view.frame.size.height/2+1)];
    }
    [self.view setNeedsUpdateConstraints];
    [UIView animateWithDuration:.2 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [viewInfo pointerDown];;
    }];
}

@end
