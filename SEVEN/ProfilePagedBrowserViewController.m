//
//  ProfilePagedBrowserViewController.m
//  SEVEN
//
//  Created by Bobby Ren on 8/8/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import "ProfilePagedBrowserViewController.h"
#import "ProfileViewController.h"

@interface ProfilePagedBrowserViewController ()

@end

@implementation ProfilePagedBrowserViewController

@synthesize allUsers;

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

    if (!profileViewControllers)
        profileViewControllers = [NSMutableDictionary dictionary];

    [self setupPages];
    
    // double tap to close
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    tap.numberOfTapsRequired = 2;
    [scrollView addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadCurrentPage {
    if (![allUsers count])
        return;

    PFUser *user = allUsers[page];
    if (!profileViewControllers[user.objectId]) {
        ProfileViewController *controller = [_storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
        [controller setUser:user];
        profileViewControllers[user.objectId] = controller;
    }
    currentPage = profileViewControllers[user.objectId];

    [super loadCurrentPage];
}

-(void)loadLeftPage {
    if (![self canGoLeft]) {
        return;
    }

    PFUser *user = allUsers[page-1];
    if (!profileViewControllers[user.objectId]) {
        ProfileViewController *controller = [_storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
        [controller setUser:user];
        profileViewControllers[user.objectId] = controller;
    }
    prevPage = profileViewControllers[user.objectId];

    [super loadLeftPage];
}

-(void)loadRightPage {
    if (![self canGoRight]) {
        return;
    }

    PFUser *user = allUsers[page+1];
    if (!profileViewControllers[user.objectId]) {
        ProfileViewController *controller = [_storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
        [controller setUser:user];
        profileViewControllers[user.objectId] = controller;
    }
    nextPage = profileViewControllers[user.objectId];

    [super loadRightPage];
}

-(BOOL)canGoLeft {
    return page > 0;
}

-(BOOL)canGoRight {
    return page < allUsers.count - 1;
}

-(void)pageLeft {
    page -= 1;
    [self.delegate didScrollToPage:page];
    [super pageLeft];
}

-(void)pageRight {
    page += 1;
    [self.delegate didScrollToPage:page];
    [super pageRight];
}

-(void)jumpToPage:(int)_page animated:(BOOL)animated {
    page = _page;
    [self setupPages];
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

-(void)handleGesture:(UIGestureRecognizer *)gesture {
    if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"profile:full:tapped" object:nil];
    }
}

@end
