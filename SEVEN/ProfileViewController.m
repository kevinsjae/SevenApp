//
//  ProfileViewController.m
//  SEVEN
//
//  Created by Bobby Ren on 8/7/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import "ProfileViewController.h"

@implementation ProfileViewController
-(void)viewDidLoad {
    PFUser *user = [PFUser currentUser];

}

-(void)setupMedia:(NSArray *)mediaURLs {
    self.mediaURLs = mediaURLs;
    
    // setup media player
    profileVideoURL = self.mediaURLs[0];
    [self playCurrentMedia];
}

@end
