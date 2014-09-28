//
//  ProfileViewController.h
//  SEVEN
//
//  Created by Bobby Ren on 8/7/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileDescriptionView.h"
#import <AVFoundation/AVFoundation.h>
#import "VideoPlayerViewController.h"

#define TAG_USER_ID 111

@class ProfileViewController;
@protocol ProfileViewDelegate <NSObject>

-(BOOL)isProfileVisible:(ProfileViewController *)profile;

@end

@class AVPlayer;
@class AVPlayerLayer;
@class ProfileDescriptionView;
@class VideoPlayerViewController;
@interface ProfileViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ProfileDescriptionDelegate, VideoPlayerDelegate>
{
    IBOutlet ProfileDescriptionView *viewInfo;
    IBOutlet NSLayoutConstraint *constraintNameOffset;
    float initialOffset;

    IBOutlet UIView *viewVideo;
    IBOutlet UIImageView *viewVideoFrame;

    IBOutlet UITableView *tableview;

    NSMutableArray *allColors;
    AVPlayer *player;

    UILabel *labelTag;
}
@property (nonatomic, weak) id delegate;
@property (nonatomic) PFUser *user;
@property (nonatomic) PFObject *facebookFriend;
@property (nonatomic) NSString *name;
@property (nonatomic) PFObject *profileVideo;
@property (nonatomic) NSArray *traits;

@property (nonatomic) VideoPlayerViewController *playerController;

-(void)showsContent:(BOOL)shows;
-(AVPlayer *)player;

@property (nonatomic) AVPlayerLayer *playerLayer;

-(CMTime)currentVideoOffset;
-(void)jumpToVideoTime:(CMTime)newTime;

-(void)didShowPage;
@end
