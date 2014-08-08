//
//  ProfileViewController.h
//  SEVEN
//
//  Created by Bobby Ren on 8/7/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AVPlayer;
@class AVPlayerLayer;
@interface ProfileViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UIView *viewName;
    IBOutlet UILabel *labelName;

    IBOutlet UIView *viewVideo;

    IBOutlet UITableView *tableview;

    NSMutableArray *allColors;
    AVPlayer *player;
}
@property (nonatomic) PFUser *user;
@property (nonatomic) PFObject *facebookFriend;
@property (nonatomic) NSString *name;
@property (nonatomic) PFObject *profileVideo;
@property (nonatomic) NSArray *traits;
@property (nonatomic) BOOL hideTable;
@end
