//
//  ShellViewController.m
//  SEVEN
//
//  Created by Bobby Ren on 8/8/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import "ShellViewController.h"
#import "ProfileMiniViewController.h"
#import "MBProgressHUD.h"
#import "FacebookHelper.h"
#import "ProfileFullViewController.h"
#import "ProfileViewController.h"

@interface ShellViewController ()

@end

@implementation ShellViewController

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
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;

    progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progress.mode = MBProgressHUDModeIndeterminate;
    progress.labelText = @"Loading users";

    [[PFUser query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        allUsers = [objects mutableCopy];
        if (error) {
            progress.labelText = @"Failed to load users!";
            progress.detailsLabelText = @"Please restart the app and try again";
            [progress hide:YES afterDelay:3];
        }
        else {
            for (PFUser *user in allUsers) {
                if ([user.objectId isEqualToString:[PFUser currentUser].objectId]) {
                    //                [allUsers removeObject:user];
                }
            }
            [progress hide:YES];
            [self switchToFullProfile];
        }
    }];

    UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"seven_icon_logo_white"]];
    titleView.contentMode = UIViewContentModeScaleAspectFit;
    [titleView setFrame:CGRectMake(0, 0, 90, 20)]; // todo: icon is not centered
    self.navigationItem.titleView = titleView;

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleDone target:self action:@selector(didClickLogOut:)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Message" style:UIBarButtonItemStyleDone target:self action:@selector(didClickMessage:)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchToMiniProfile) name:@"profile:full:tapped" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchToFullProfile) name:@"profile:fastscroll:tapped" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)switchToFullProfile {
    NSLog(@"Switching to full");
    if (!fullProfile) {
        fullProfile = [_storyboard instantiateViewControllerWithIdentifier:@"ProfileFullViewController"];
        fullProfile.delegate = self;
        fullProfile.allUsers = allUsers;
        [self.view addSubview:fullProfile.view];
    }
    [fullProfile jumpToPage:currentPage animated:NO];

    ProfileViewController *profileView = miniProfile.currentProfile;
    [self.view addSubview:profileView.view];
    profileView.view.center = self.view.center;
    float scale = self.view.frame.size.width / SMALL_PAGE_WIDTH;
    [UIView animateWithDuration:.5 animations:^{
        profileView.view.transform = CGAffineTransformMakeScale(scale, scale);
    } completion:^(BOOL finished) {
        [miniProfile.view setAlpha:0];
        [fullProfile.view setAlpha:1];
        [fullProfile refresh];
        [profileView.view removeFromSuperview];
        profileView.view.transform = CGAffineTransformIdentity;
    }];
}

-(void)switchToMiniProfile {
    NSLog(@"Switching to fast");
    if (!miniProfile) {
        miniProfile = [_storyboard instantiateViewControllerWithIdentifier:@"ProfileMiniViewController"];
        miniProfile.delegate = self;
        miniProfile.allUsers = allUsers;
        [self.view addSubview:miniProfile.view];
    }
    [miniProfile jumpToPage:currentPage animated:NO];

    ProfileViewController *profileView = fullProfile.currentProfile;
    [self.view addSubview:profileView.view];
    profileView.view.center = self.view.center;
    float scale = SMALL_PAGE_WIDTH / self.view.frame.size.width;
    [fullProfile.view setAlpha:0];
    [miniProfile.view setAlpha:1];
    [UIView animateWithDuration:.5 animations:^{
        profileView.view.transform = CGAffineTransformMakeScale(scale, scale);
    } completion:^(BOOL finished) {
        [miniProfile refresh];
        [profileView.view removeFromSuperview];
        profileView.view.transform = CGAffineTransformIdentity;
    }];

}

-(void)didScrollToPage:(int)page {
    currentPage = page;
}

-(void)didClickLogOut:(id)sender {
    NSLog(@"Log out");
    [PFUser logOut];
    [FacebookHelper logout];

    [_appDelegate goToIntro];
}

-(void)didClickMessage:(id)sender {
    NSLog(@"Message");
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
