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

#define TAG_USER_ID 111

@class AVPlayer;
@class AVPlayerLayer;
@class ProfileDescriptionView;
@interface ProfileViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ProfileDescriptionDelegate>
{
    IBOutlet ProfileDescriptionView *viewInfo;
    IBOutlet NSLayoutConstraint *constraintNameOffset;
    float initialOffset;

    IBOutlet UIView *viewVideo;
    IBOutlet UIImageView *viewVideoFrame;

    IBOutlet UITableView *tableview;

    NSMutableArray *allColors;
    AVPlayer *player;

    BOOL playing;
    UILabel *labelTag;
}
@property (nonatomic) PFUser *user;
@property (nonatomic) PFObject *facebookFriend;
@property (nonatomic) NSString *name;
@property (nonatomic) PFObject *profileVideo;
@property (nonatomic) NSArray *traits;

-(void)showsContent:(BOOL)shows;
-(AVPlayer *)player;
@property (nonatomic) AVPlayerLayer *playerLayer;

-(CMTime)currentVideoOffset;
-(void)jumpToVideoTime:(CMTime)newTime;
@end
